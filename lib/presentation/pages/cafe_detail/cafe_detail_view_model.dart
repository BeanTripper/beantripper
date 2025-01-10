import 'package:bean_tripper/presentation/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/domain/usecase/fetch_cafe_item_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CafeDetailState {
  final bool isLoading;
  final CafeDetail? cafeDetail;
  final String? error;
  final bool isFavorite;

  CafeDetailState({
    this.isLoading = false,
    this.cafeDetail,
    this.error,
    this.isFavorite = false,
  });

  CafeDetailState copyWith({
    bool? isLoading,
    CafeDetail? cafeDetail,
    String? error,
    bool? isFavorite,
  }) {
    return CafeDetailState(
      isLoading: isLoading ?? this.isLoading,
      cafeDetail: cafeDetail ?? this.cafeDetail,
      error: error ?? this.error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CafeDetailViewModel extends StateNotifier<CafeDetailState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _cafeName;

  CafeDetailViewModel(FetchCafeItemUsecase watch) : super(CafeDetailState()) {
    if (_cafeName != null) {
      initWithCafeName(_cafeName!);
    }
  }

  void setCafeName(String name) {
    _cafeName = name;
    initWithCafeName(name);
  }

  Future<void> checkFavoriteStatus(String cafeName) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        state = state.copyWith(isFavorite: false);
        return;
      }

      final favoritesSnapshot = await _firestore
          .collection('user')
          .doc(userId)
          .collection('favoriteCafe')
          .get();

      final isFavorite = favoritesSnapshot.docs.any((doc) {
        final data = doc.data();
        return data['cafeName'] == cafeName;
      });

      state = state.copyWith(isFavorite: isFavorite);
    } catch (e) {
      state = state.copyWith(isFavorite: false);
    }
  }

  Future<void> toggleFavorite() async {
    try {
      final userId = _auth.currentUser?.uid;
      final cafeName = state.cafeDetail?.name;

      if (userId == null || cafeName == null) return;

      final userFavoriteRef =
          _firestore.collection('user').doc(userId).collection('favoriteCafe');

      if (state.isFavorite) {
        final favoritesSnapshot = await userFavoriteRef.get();
        final docToDelete = favoritesSnapshot.docs.firstWhere(
          (doc) => doc.data()['cafeName'] == cafeName,
          orElse: () => throw Exception('Document not found'),
        );

        await userFavoriteRef.doc(docToDelete.id).delete();
      } else {
        final docRef = await userFavoriteRef.add({
          'cafeName': cafeName,
        });
      }

      state = state.copyWith(isFavorite: !state.isFavorite);
    } catch (e) {}
  }

  Future<void> fetchCafeDetail(String cafeId) async {
    try {
      final docSnapshot = await _firestore.collection('cafe').doc(cafeId).get();
      final data = docSnapshot.data()!;

      final cafeDetail = CafeDetail(
        id: docSnapshot.id,
        name: data['name'] ?? '',
        address: data['address'] ?? '',
        lat: (data['lat'] ?? 0.0).toDouble(),
        lng: (data['lng'] ?? 0.0).toDouble(),
        tel: data['tel'],
        feedImageUrls: data['feedImageUrls'],
      );

      state = state.copyWith(
        isLoading: false,
        cafeDetail: cafeDetail,
      );
      await checkFavoriteStatus(cafeDetail.name);
    } catch (e) {
      print('Error in fetchCafeDetail: $e');
    }
  }

  Future<void> initWithCafeName(String cafeName) async {
    try {
      state = state.copyWith(isLoading: true);

      final snapshot = await _firestore
          .collection('cafe')
          .where('name', isEqualTo: cafeName)
          .get();

      final doc = snapshot.docs.first;
      final cafeId = doc.id;
      await fetchCafeDetail(cafeId);

      await checkFavoriteStatus(cafeName);
    } catch (e) {
      print('Error in initWithCafeName: $e');
    }
  }

  // 지도 관련 메서드
  double? get latitude => state.cafeDetail?.lat;
  double? get longitude => state.cafeDetail?.lng;
}

final cafeDetailViewModelProvider =
    StateNotifierProvider<CafeDetailViewModel, CafeDetailState>(
  (ref) => CafeDetailViewModel(
    ref.watch(fetchCafeItemUsecaseProvider),
  ),
);
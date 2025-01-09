import 'package:bean_tripper/presentation/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/domain/usecase/fetch_cafe_item_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CafeDetailState {
  final bool isLoading;
  final CafeDetail? cafeDetail;
  final String? error;

  CafeDetailState({
    this.isLoading = false,
    this.cafeDetail,
    this.error,
  });

  CafeDetailState copyWith({
    bool? isLoading,
    CafeDetail? cafeDetail,
    String? error,
  }) {
    return CafeDetailState(
      isLoading: isLoading ?? this.isLoading,
      cafeDetail: cafeDetail ?? this.cafeDetail,
      error: error ?? this.error,
    );
  }
}

class CafeDetailViewModel extends StateNotifier<CafeDetailState> {
  final FetchCafeItemUsecase _fetchCafeItemUsecase;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CafeDetailViewModel(this._fetchCafeItemUsecase) : super(CafeDetailState()) {
    _initFirstCafe();
  }

  Future<void> _initFirstCafe() async {
    try {
      final snapshot = await _firestore.collection('cafe').limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        final firstCafeId = snapshot.docs[0].id;
        await fetchCafeDetail(firstCafeId);
      } else {}
    } catch (e) {
      state = state.copyWith(
        error: '카페 정보를 불러오는데 실패했습니다.',
      );
    }
  }

  Future<void> fetchCafeDetail(String cafeId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final cafeDetail = await _fetchCafeItemUsecase.excute(cafeId);

      if (cafeDetail != null) {
        state = state.copyWith(
          isLoading: false,
          cafeDetail: cafeDetail,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: '카페 정보를 찾을 수 없습니다.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '카페 정보를 불러오는데 실패했습니다.',
      );
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

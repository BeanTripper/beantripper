import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/domain/repository/cafe_repository.dart';

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
  final CafeRepository _cafeRepository;

  CafeDetailViewModel(this._cafeRepository) : super(CafeDetailState());

  Future<void> fetchCafeDetail(String cafeId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final cafeDetail = await _cafeRepository.fetchCafeItem(cafeId);

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
    StateNotifierProvider.family<CafeDetailViewModel, CafeDetailState, String>(
  (ref, cafeId) => CafeDetailViewModel(
    ref.watch(_cafeRepository),
  )..fetchCafeDetail(cafeId),
);

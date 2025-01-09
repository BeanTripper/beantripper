import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/domain/repository/cafe_repository.dart';

class CafeDetailState {
  final bool isLoading;
  final CafeDetail? cafeDetail;
  final String? error;
  final bool isOperating; // 현재 영업 중인지 여부

  CafeDetailState({
    this.isLoading = false,
    this.cafeDetail,
    this.error,
    this.isOperating = false,
  });

  CafeDetailState copyWith({
    bool? isLoading,
    CafeDetail? cafeDetail,
    String? error,
    bool? isOperating,
  }) {
    return CafeDetailState(
      isLoading: isLoading ?? this.isLoading,
      cafeDetail: cafeDetail ?? this.cafeDetail,
      error: error ?? this.error,
      isOperating: isOperating ?? this.isOperating,
    );
  }
}

class CafeDetailViewModel extends StateNotifier<CafeDetailState> {
  final CafeRepository _cafeRepository;

  CafeDetailViewModel(this._cafeRepository) : super(CafeDetailState());

  // 카페 상세 정보 불러오기
  Future<void> fetchCafeDetail(String cafeId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final cafeDetail = await _cafeRepository.fetchCafeItem(cafeId);

      if (cafeDetail != null) {
        final isOperating = _checkOperatingStatus(cafeDetail.operatingTime);
        state = state.copyWith(
          isLoading: false,
          cafeDetail: cafeDetail,
          isOperating: isOperating,
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

  // 영업 시간 확인 로직
  bool _checkOperatingStatus(String? operatingTime) {
    if (operatingTime == null) return false;

    try {
      // 예시: "09:00-22:00" 형식
      final times = operatingTime.split('-');
      if (times.length != 2) return false;

      final openTime = times[0];
      final closeTime = times[1];

      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      return currentTime.compareTo(openTime) >= 0 &&
          currentTime.compareTo(closeTime) < 0;
    } catch (e) {
      return false;
    }
  }

  // 지도 관련 메서드
  double? get latitude => state.cafeDetail?.lat;
  double? get longitude => state.cafeDetail?.lng;
}

final cafeDetailViewModelProvider =
    StateNotifierProvider.family<CafeDetailViewModel, CafeDetailState, String>(
  (ref, cafeId) => CafeDetailViewModel(
    ref.watch(cafeRepositoryProvider),
  )..fetchCafeDetail(cafeId),
);

final cafeRepositoryProvider = Provider<CafeRepository>((ref) {
  throw UnimplementedError();
});

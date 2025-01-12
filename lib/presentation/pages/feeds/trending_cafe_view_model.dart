import 'package:bean_tripper/data/repository/trending_cafe_repository_impl.dart';
import 'package:bean_tripper/domain/usecase/get_trending_cafes_usecase.dart';
import 'package:bean_tripper/presentation/pages/feeds/trending_cafe_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingCafeViewModel extends StateNotifier<TrendingCafeState> {
  final GetTrendingCafesUseCase _getTrendingCafesUseCase;

  TrendingCafeViewModel(this._getTrendingCafesUseCase)
      : super(TrendingCafeState()) {
    fetchTrendingCafes();
  }

  Future<void> refresh() async {
    await fetchTrendingCafes();
  }

  Future<void> fetchTrendingCafes() async {
    try {
      state = state.copyWith(isLoading: true);
      final cafes = await _getTrendingCafesUseCase.execute();
      print('Fetched Trending Cafes: $cafes');
      state = state.copyWith(
        isLoading: false,
        cafes: cafes,
      );
    } catch (e) {
      print('Error fetching trending cafes: $e');
      state = state.copyWith(
        isLoading: false,
        error: '오늘의 카페를 불러오는데 실패했습니다.',
      );
    }
  }
}

// Provider 정의
final trendingCafeViewModelProvider =
    StateNotifierProvider<TrendingCafeViewModel, TrendingCafeState>((ref) {
  final useCase = ref.watch(getTrendingCafesUseCaseProvider);
  return TrendingCafeViewModel(useCase);
});

// UseCase Provider
final getTrendingCafesUseCaseProvider = Provider((ref) {
  final repository = ref.watch(trendingCafeRepositoryProvider);
  return GetTrendingCafesUseCase(repository);
});

// Repository Provider
final trendingCafeRepositoryProvider = Provider((ref) {
  return TrendingCafeRepositoryImpl();
});

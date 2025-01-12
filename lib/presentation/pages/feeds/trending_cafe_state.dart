import 'package:bean_tripper/domain/entity/trending_cafe.dart';

class TrendingCafeState {
  final bool isLoading;
  final List<TrendingCafe> cafes;
  final String? error;

  TrendingCafeState({
    this.isLoading = false,
    this.cafes = const [],
    this.error,
  });

  TrendingCafeState copyWith({
    bool? isLoading,
    List<TrendingCafe>? cafes,
    String? error,
  }) {
    return TrendingCafeState(
      isLoading: isLoading ?? this.isLoading,
      cafes: cafes ?? this.cafes,
      error: error ?? this.error,
    );
  }
}

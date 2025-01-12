import 'package:bean_tripper/domain/entity/trending_cafe.dart';
import 'package:bean_tripper/domain/repository/trending_cafe_repository.dart';

class GetTrendingCafesUseCase {
  final TrendingCafeRepository _repository;

  GetTrendingCafesUseCase(this._repository);

  Future<List<TrendingCafe>> execute() async {
    try {
      return await _repository.getTrendingCafes();
    } catch (e) {
      // 에러 발생 시 빈 리스트 반환
      return [];
    }
  }
}

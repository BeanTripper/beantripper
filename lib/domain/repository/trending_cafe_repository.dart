import 'package:bean_tripper/domain/entity/trending_cafe.dart';

abstract class TrendingCafeRepository {
  /// 오늘의 인기 카페 5개를 가져옵니다.
  Future<List<TrendingCafe>> getTrendingCafes();
}

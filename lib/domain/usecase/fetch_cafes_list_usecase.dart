import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/domain/repository/cafe_repository.dart';

class FetchCafesListUsecase {
  final CafeRepository _cafeRepository;
  FetchCafesListUsecase(this._cafeRepository);

  Future<List<Cafe>?> excute(double lat, double lng) async {
    return await _cafeRepository.fetchCafesList(lat, lng);
  }
}

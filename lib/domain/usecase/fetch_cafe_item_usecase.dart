import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/domain/repository/cafe_repository.dart';

class FetchCafeItemUsecase {
  final CafeRepository _cafeRepository;
  FetchCafeItemUsecase(this._cafeRepository);

  Future<CafeDetail?> excute(String id) async {
    return await _cafeRepository.fetchCafeItem(id);
  }
}

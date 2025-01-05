import 'package:bean_tripper/data/dto/cafe_dto.dart';

abstract interface class CafeDataSource {
  Future<List<CafeDto>?> fetchCafesList();

  Future<CafeDto?> fetchCafeItem(int id);
}

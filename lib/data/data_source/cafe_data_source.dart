import 'package:bean_tripper/data/dto/cafe_detail_dto.dart';
import 'package:bean_tripper/data/dto/cafe_dto.dart';

abstract interface class CafeDataSource {
  Future<List<CafeDto>?> fetchCafesList(double lat, double lng);

  Future<CafeDetailDto?> fetchCafeItem(String id);

  Future<void> addCafeItem(CafeDetailDto item);
}

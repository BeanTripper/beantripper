import 'package:bean_tripper/data/dto/cafe_detail_dto.dart';
import 'package:bean_tripper/data/dto/cafe_marker_dto.dart';

abstract interface class CafeDataSource {
  Future<List<CafeMarkerDto>?> fetchCafesList();

  Future<CafeDetailDto?> fetchCafeItem(String id);

  Future<void> addCafeItem(CafeDetailDto item);
}

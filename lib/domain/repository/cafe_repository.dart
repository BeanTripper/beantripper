import 'package:bean_tripper/domain/entity/cafe_marker.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';

abstract interface class CafeRepository {
  Future<List<CafeMarker>?> fetchCafesList(double lat, double lng);

  Future<CafeDetail?> fetchCafeItem(String id);

  Future<void> addCafeItem(CafeDetail item);
}
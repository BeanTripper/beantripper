import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';

abstract interface class CafeRepository {
  Future<List<Cafe>?> fetchCafesList();

  Future<CafeDetail?> fetchCafeItem(String id);

  Future<void> addCafeItem(CafeDetail item);
}

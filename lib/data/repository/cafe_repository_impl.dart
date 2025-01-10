import 'package:bean_tripper/data/data_source/cafe_data_source.dart';
import 'package:bean_tripper/data/dto/cafe_detail_dto.dart';
import 'package:bean_tripper/domain/entity/cafe_marker.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/domain/repository/cafe_repository.dart';

class CafeRepositoryImpl implements CafeRepository {
  final CafeDataSource _cafeDataSource;
  CafeRepositoryImpl(this._cafeDataSource);

  @override
  Future<void> addCafeItem(CafeDetail cafe) async {
    _cafeDataSource.addCafeItem(cafe as CafeDetailDto);
  }

  @override
  Future<CafeDetail?> fetchCafeItem(String id) async {
    final result = await _cafeDataSource.fetchCafeItem(id);
    if (result != null) {
      return CafeDetail(
        id: id,
        name: result.name,
        address: result.address,
        lat: result.lat,
        lng: result.lng,
        tel: result.tel,
        feedImageUrls: '',
      );
    }
    return null;
  }

  @override
  Future<List<CafeMarker>?> fetchCafesList(double lat, double lng) async {
    final result = await _cafeDataSource.fetchCafesList(lat, lng);
    return result
        ?.map(
          (e) => CafeMarker(
            id: e.id,
            lat: e.lat,
            lng: e.lng,
          ),
        )
        .toList();
  }
}
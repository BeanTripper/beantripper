import 'dart:convert';

import 'package:bean_tripper/data/data_source/cafe_data_source.dart';
import 'package:bean_tripper/data/dto/cafe_dto.dart';
import 'package:flutter/services.dart';

class CafeDataSourceImpl implements CafeDataSource {
  final AssetBundle _assetBundle;
  CafeDataSourceImpl(this._assetBundle);

  @override
  Future<CafeDto?> fetchCafeItem(int id) {
    // TODO: implement fetchCafeItem
    throw UnimplementedError();
  }

  @override
  Future<List<CafeDto>?> fetchCafesList() async {
    final jsonString = await _assetBundle.loadString('assets/cafes.json');
    return List.from(jsonDecode(jsonString))
        .map((e) => CafeDto.fromJson(e))
        .toList();
  }
}

import 'dart:convert';

import 'package:bean_tripper/data/data_source/cafe_data_source.dart';
import 'package:bean_tripper/data/dto/cafe_detail_dto.dart';
import 'package:bean_tripper/data/dto/cafe_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class CafeDataSourceImpl implements CafeDataSource {
  // final AssetBundle _assetBundle;
  // CafeDataSourceImpl(this._assetBundle);

  @override
  Future<CafeDetailDto?> fetchCafeItem(String id) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('cafe');
    final docRef = collectionRef.doc(id);

    final doc = await docRef.get();

    return CafeDetailDto.fromJson({
      'id': doc.id,
      ...?doc.data(),
    });
  }

  @override
  Future<List<CafeDto>?> fetchCafesList() async {
    // final jsonString = await _assetBundle.loadString('assets/cafes.json');
    // return List.from(jsonDecode(jsonString))
    //     .map((e) => CafeDto.fromJson(e))
    //     .toList();

    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('cafe');
    final result = await collectionRef.get();
    final docs = result.docs;

    return docs.map((doc) {
      final map = {
        'id': doc.id,
        ...doc.data(),
      };
      return CafeDto.fromJson(map);
    }).toList();
  }

  @override
  Future<void> addCafeItem(CafeDetailDto item) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('cafe');
    final docRef = collectionRef.doc();

    await docRef.set(item.toJson());
  }
}

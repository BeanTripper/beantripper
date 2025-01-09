import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/data/data_source/cafe_data_source.dart';
import 'package:bean_tripper/data/dto/cafe_detail_dto.dart';
import 'package:bean_tripper/data/dto/cafe_marker_dto.dart';

class CafeDataSourceImpl implements CafeDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<CafeDetailDto?> fetchCafeItem(String id) async {
    try {
      final docSnapshot = await _firestore.collection('cafe').doc(id).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;

        return CafeDetailDto(
          id: docSnapshot.id,
          name: data['name'] ?? '',
          address: data['address'] ?? '',
          lat: (data['lat'] ?? 0.0).toDouble(),
          lng: (data['lng'] ?? 0.0).toDouble(),
          tel: data['tel'],
          feedImageUrls: '',
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CafeMarkerDto>?> fetchCafesList() async {
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
      return CafeMarkerDto.fromJson(map);
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

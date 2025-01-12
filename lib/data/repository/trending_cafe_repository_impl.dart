import 'package:bean_tripper/domain/entity/trending_cafe.dart';
import 'package:bean_tripper/domain/repository/trending_cafe_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/data/dto/trending_cafe_dto.dart';

class TrendingCafeRepositoryImpl implements TrendingCafeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<TrendingCafe>> getTrendingCafes() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

      print('Fetching feeds between: $startOfDay and $endOfDay');

      final snapshot = await _firestore
          .collection('feed')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      print('Found ${snapshot.docs.length} feeds today');

      final cafeMap = <String, Map<String, dynamic>>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        print('Processing feed data: $data');

        final cafeName = data['cafeName'] as String;
        final imageUrls = data['imageUrls'] as List<dynamic>? ?? [];
        final imageUrl =
            imageUrls.isNotEmpty ? imageUrls.first as String : null;

        final categories = (data['categories'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .join(', ') ??
            '카테고리 없음';

        print(
            'Extracted cafe info - name: $cafeName, imageUrl: $imageUrl, categories: $categories');

        cafeMap[cafeName] = {
          'name': cafeName,
          'imageUrl': imageUrl ?? cafeMap[cafeName]?['imageUrl'],
          'category': categories,
        };
      }

      print('Final cafe map: $cafeMap');

      final trendingCafes = cafeMap.values.take(5).map((data) {
        print('Converting data to DTO: $data');
        return TrendingCafeDto(
          name: data['name'],
          imageUrl: data['imageUrl'],
          category: data['category'],
        ).toEntity();
      }).toList();

      print('Final trending cafes list: $trendingCafes');
      return trendingCafes;
    } catch (e) {
      print('Error fetching trending cafes: $e');
      print('Error stack trace: ${StackTrace.current}');
      return [];
    }
  }
}

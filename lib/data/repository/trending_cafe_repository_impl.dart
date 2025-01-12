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

      final snapshot = await _firestore
          .collection('feed')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThanOrEqualTo: endOfDay)
          .get();

      final cafeCountMap = <String, int>{};
      final cafeImageMap = <String, String?>{};
      final cafeCategoryMap = <String, String>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final cafeName = data['cafeName'] as String;
        final imageUrl =
            (data['imageUrls'] as List<dynamic>?)?.first as String?;
        final category = data['category'] as String;

        cafeCountMap[cafeName] = (cafeCountMap[cafeName] ?? 0) + 1;
        cafeImageMap[cafeName] ??= imageUrl;
        cafeCategoryMap[cafeName] = category;
      }

      final trendingCafes = cafeCountMap.entries
          .map((entry) => TrendingCafeDto(
                name: entry.key,
                imageUrl: cafeImageMap[entry.key],
                category: cafeCategoryMap[entry.key]!,
              ).toEntity())
          .toList();

      trendingCafes.sort((a, b) => b.feedCount.compareTo(a.feedCount));

      return trendingCafes.take(5).toList();
    } catch (e) {
      print('Error fetching trending cafes: $e');
      return [];
    }
  }
}

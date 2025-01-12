import 'package:bean_tripper/domain/entity/trending_cafe.dart';
import 'package:bean_tripper/domain/repository/trending_cafe_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/data/dto/trending_cafe_dto.dart';

class TrendingCafeRepositoryImpl implements TrendingCafeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<TrendingCafe>> getTrendingCafes() async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      final startTimestamp = Timestamp.fromDate(today);
      final endTimestamp = Timestamp.fromDate(tomorrow);

      final snapshot = await _firestore
          .collection('feed')
          .orderBy('createdAt')
          .startAt([startTimestamp]).endBefore([endTimestamp]).get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      final cafeMap = <String, Map<String, dynamic>>{};
      final cafeCount = <String, int>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final cafeName = data['cafeName'] as String;
        (data['createdAt'] as Timestamp).toDate();

        cafeCount[cafeName] = (cafeCount[cafeName] ?? 0) + 1;

        if (!cafeMap.containsKey(cafeName)) {
          final imageUrls = data['imageUrls'] as List<dynamic>? ?? [];
          final imageUrl =
              imageUrls.isNotEmpty ? imageUrls.first as String : null;
          final categories = (data['categories'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .join(', ') ??
              '카테고리 없음';

          cafeMap[cafeName] = {
            'name': cafeName,
            'imageUrl': imageUrl,
            'category': categories,
          };
        }
      }

      final sortedCafes = cafeCount.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final trendingCafes = sortedCafes.take(5).map((entry) {
        final cafeInfo = cafeMap[entry.key]!;
        return TrendingCafeDto(
          name: cafeInfo['name'],
          imageUrl: cafeInfo['imageUrl'],
          category: cafeInfo['category'],
        ).toEntity();
      }).toList();

      return trendingCafes;
    } catch (e) {
      print('Error fetching trending cafes: $e');
      return [];
    }
  }
}

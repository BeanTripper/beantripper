import 'package:bean_tripper/constant/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CafeFeedCollection extends StatelessWidget {
  final String cafeName;

  const CafeFeedCollection({
    super.key,
    required this.cafeName,
  });

  @override
  Widget build(BuildContext context) {
    if (cafeName.isEmpty) {
      return const SizedBox();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('feed').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('에러가 발생했습니다'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allFeeds = snapshot.data!.docs;

        final feeds = allFeeds.where((feed) {
          final data = feed.data() as Map<String, dynamic>;
          return data['cafeName'] == cafeName;
        }).toList()
          ..sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['createdAt'] as Timestamp;
            final bTime = bData['createdAt'] as Timestamp;
            return bTime.compareTo(aTime); // 내림차순 정렬 (최신순)
          });

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 1.0,
            mainAxisSpacing: 1.0,
          ),
          itemCount: feeds.length,
          itemBuilder: (context, index) {
            final feed = feeds[index].data() as Map<String, dynamic>;
            final imageUrls = List<String>.from(feed['imageUrls'] ?? []);

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/cafe_feed_page',
                  arguments: {
                    'cafeId': cafeName,
                    'selectedFeedId': feeds[index].id,
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CustomColors.darkGray,
                ),
                child: imageUrls.isNotEmpty
                    ? Image.network(
                        imageUrls[0],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      )
                    : const Center(
                        child: Text(
                          'No Image',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

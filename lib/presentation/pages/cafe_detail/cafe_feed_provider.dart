import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/domain/entity/feed.dart';

final cafeFeedProvider = StateNotifierProvider.family<CafeFeedNotifier,
    AsyncValue<List<Feed>>, String>(
  (ref, cafeId) => CafeFeedNotifier(cafeId),
);

class CafeFeedNotifier extends StateNotifier<AsyncValue<List<Feed>>> {
  final String cafeId;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  CafeFeedNotifier(this.cafeId) : super(const AsyncValue.loading()) {
    _loadInitialFeeds();
  }

  void _loadInitialFeeds() {
    _fetchFeedsFromFirebase().then((feeds) {
      if (mounted) {
        state = AsyncValue.data(feeds);
      }
    }).catchError((error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    });
  }

  Future<List<Feed>> _fetchFeedsFromFirebase(
      {DocumentSnapshot? startAfter}) async {
    try {
      print('Fetching feeds for cafe: $cafeId');

      // 먼저 모든 피드를 가져온 후 메모리에서 필터링
      final snapshot =
          await FirebaseFirestore.instance.collection('feed').get();

      print('Total documents: ${snapshot.docs.length}');

      // cafeName으로 필터링하고 날짜순 정렬
      final filteredDocs = snapshot.docs
          .where((doc) => doc.data()['cafeName'] == cafeId)
          .toList()
        ..sort((a, b) {
          final aTime = (a.data()['createdAt'] as Timestamp).toDate();
          final bTime = (b.data()['createdAt'] as Timestamp).toDate();
          return bTime.compareTo(aTime); // 내림차순 정렬
        });

      if (filteredDocs.isEmpty) {
        _hasMore = false;
        return [];
      }

      print('Filtered documents: ${filteredDocs.length}');

      final feeds = filteredDocs
          .map((doc) {
            try {
              print('Document ID: ${doc.id}');
              print('Document data: ${doc.data()}');
              return Feed.fromFirestore(doc);
            } catch (e) {
              print('Error parsing document: $e');
              return null;
            }
          })
          .whereType<Feed>()
          .toList();

      print('Processed ${feeds.length} valid feeds');
      return feeds;
    } catch (e) {
      print('Error fetching feeds: $e');
      return [];
    }
  }

  Future<void> fetchMoreFeeds() async {
    if (!_hasMore) return;
    try {
      final moreFeeds =
          await _fetchFeedsFromFirebase(startAfter: _lastDocument);
      if (moreFeeds.isEmpty) {
        _hasMore = false;
        return;
      }
      if (mounted) {
        state = state.whenData((feeds) => [...feeds, ...moreFeeds]);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      _lastDocument = null;
      _hasMore = true;
      final feeds = await _fetchFeedsFromFirebase();
      if (mounted) {
        state = AsyncValue.data(feeds);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncValue.error(e, st);
      }
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final feedProvider =
    StateNotifierProvider<FeedNotifier, AsyncValue<List<Feed>>>((ref) {
  return FeedNotifier();
});

class FeedNotifier extends StateNotifier<AsyncValue<List<Feed>>> {
  FeedNotifier() : super(const AsyncValue.loading()) {
    _loadInitialFeeds();
  }

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

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
    } catch (e, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<List<Feed>> _fetchFeedsFromFirebase(
      {DocumentSnapshot? startAfter}) async {
    List<Feed> feedList = [];
    final query = FirebaseFirestore.instance
        .collection('feed')
        .orderBy('createdAt', descending: true)
        .limit(10);

    final snapshot = startAfter != null
        ? await query.startAfterDocument(startAfter).get()
        : await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }
    for (var d in snapshot.docs) {
      feedList.add(Feed.fromFirestore(d));
    }

    return feedList;
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

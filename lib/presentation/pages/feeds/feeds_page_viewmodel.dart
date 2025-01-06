import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final feedProvider =
    StateNotifierProvider<FeedNotifier, AsyncValue<List<Feed>>>((ref) {
  return FeedNotifier();
});

class FeedNotifier extends StateNotifier<AsyncValue<List<Feed>>> {
  FeedNotifier() : super(AsyncValue.loading()) {
    _fetchFeeds();
  }

  Future<void> _fetchFeeds() async {
    try {
      final feeds = await fetchFeedsFromFirebase(); // Firebase에서 피드 데이터를 가져옴
      state = AsyncValue.data(feeds); // 데이터를 성공적으로 가져온 경우 상태를 업데이트
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // 예외 발생 시 예외 상태로 업데이트
    }
  }

  Future<void> fetchMoreFeeds() async {
    try {
      final moreFeeds =
          await fetchFeedsFromFirebase(); // Firebase에서 추가 데이터 가져오기
      state = state.whenData((feeds) => feeds + moreFeeds); // 기존 데이터에 추가 데이터 병합
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // 예외 발생 시 예외 상태로 업데이트
    }
  }

  Future<List<Feed>> fetchFeedsFromFirebase() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('feeds')
        .get(); // Firestore에서 'feeds' 컬렉션의 데이터를 가져옴
    return snapshot.docs
        .map((doc) => Feed.fromFirestore(doc))
        .toList(); // 각 문서를 Feed 객체로 변환하여 리스트로 반환
  }
}

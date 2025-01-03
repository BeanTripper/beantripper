import 'package:bean_tripper/domain/entity/feed.dart';

abstract interface class FeedRepository {
  Future<List<Feed>?> fetchFeedsList();

  Future<Feed?> fetchFeedItem(int id);
}
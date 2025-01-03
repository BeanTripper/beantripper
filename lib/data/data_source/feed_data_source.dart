import 'package:bean_tripper/domain/entity/Feed.dart';

abstract interface class FeedDataSource {
  Future<List<Feed>?> fetchFeedsList();

  Future<Feed?> fetchFeedItem(int id);
}

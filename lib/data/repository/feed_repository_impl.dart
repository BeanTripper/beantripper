import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/domain/repository/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl();

  @override
  Future<Feed?> fetchFeedItem(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<Feed>?> fetchFeedsList() {
    throw UnimplementedError();
  }
}

import 'package:bean_tripper/data/data_source/feed_data_source.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/domain/repository/feed_repository.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedDataSource _feedDataSource;
  FeedRepositoryImpl(this._feedDataSource);

  @override
  Future<Feed?> fetchFeedItem(int id) {
    // TODO: implement fetchFeedItem
    throw UnimplementedError();
  }

  @override
  Future<List<Feed>?> fetchFeedsList() {
    // TODO: implement fetchFeedsList
    throw UnimplementedError();
  }
}

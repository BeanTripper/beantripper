import 'package:bean_tripper/data/data_source/feed_data_source.dart';
import 'package:bean_tripper/data/dto/feed_dto.dart';

class FeedDataSourceImpl implements FeedDataSource {
  FeedDataSourceImpl();

  @override
  Future<FeedDto?> fetchFeedItem(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<FeedDto>?> fetchFeedsList() {
    throw UnimplementedError();
  }
}

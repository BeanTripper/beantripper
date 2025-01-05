import 'package:bean_tripper/data/dto/feed_dto.dart';

abstract interface class FeedDataSource {
  Future<List<FeedDto>?> fetchFeedsList();

  Future<FeedDto?> fetchFeedItem(int id);
}

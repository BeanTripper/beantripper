import 'package:bean_tripper/data/data_source/feed_data_source.dart';
import 'package:bean_tripper/data/dto/feed_dto.dart';
import 'package:flutter/services.dart';

class FeedDataSourceImpl implements FeedDataSource {
  final AssetBundle _assetBundle;
  FeedDataSourceImpl(this._assetBundle);

  @override
  Future<FeedDto?> fetchFeedItem(int id) {
    // TODO: implement fetchFeedItem
    throw UnimplementedError();
  }

  @override
  Future<List<FeedDto>?> fetchFeedsList() {
    // TODO: implement fetchFeedsList
    throw UnimplementedError();
  }
}

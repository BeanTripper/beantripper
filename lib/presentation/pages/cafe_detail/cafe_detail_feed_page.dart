import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CafeDetailFeedPage extends StatelessWidget {
  Feed feed;

  CafeDetailFeedPage({super.key, required this.feed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('카페 이름'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.favorite_border, size: 32),
            ),
          ],
        ),
        body: ListView(
          children: [
            FeedInfo(feed: feed),
          ],
        ));
  }
}

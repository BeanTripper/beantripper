import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cafe_feed_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CafeFeedsPage extends ConsumerStatefulWidget {
  final String cafeId;
  final String selectedFeedId;

  const CafeFeedsPage({
    super.key,
    required this.cafeId,
    required this.selectedFeedId,
  });

  @override
  ConsumerState<CafeFeedsPage> createState() => _CafeFeedsPageState();
}

class _CafeFeedsPageState extends ConsumerState<CafeFeedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  }

  void _scrollToSelectedFeed(List<Feed> feeds) {
    final index = feeds.indexWhere((feed) => feed.id == widget.selectedFeedId);
    if (index != -1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final itemHeight = MediaQuery.of(context).size.width + 200;
        _scrollController.jumpTo(index * itemHeight);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(cafeFeedProvider(widget.cafeId));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cafeId),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: feedState.when(
        data: (feeds) {
          if (feeds.isEmpty) {
            return const Center(child: Text('피드가 없습니다.'));
          }
          _scrollToSelectedFeed(feeds);
          return ListView.builder(
            controller: _scrollController,
            itemCount: feeds.length,
            itemBuilder: (context, index) {
              final feed = feeds[index];
              return Column(
                children: [
                  FeedInfo(feed: feed),
                  FeedContent(feed: feed),
                  SizedBox(height: 18),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('에러가 발생했습니다: $error')),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

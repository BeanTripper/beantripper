import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page_viewmodel.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/presentation/pages/profile/profile_page.dart';
import 'package:bean_tripper/presentation/pages/map/map_page.dart';

class FeedsPage extends ConsumerStatefulWidget {
  const FeedsPage({super.key});

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends ConsumerState<FeedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedProvider.notifier).fetchMoreFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedsAsyncValue = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/login_logo.png',
          height: 35,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              '오늘의 카페',
              style: TextStyle(
                color: Color(0xFFA47764),
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: feedsAsyncValue.when(
              data: (feeds) => ListView.builder(
                controller: _scrollController,
                itemCount: feeds.length,
                itemBuilder: (context, index) {
                  final feed = feeds[index];
                  return Column(
                    children: [
                      FeedInfo(feed: feed),
                      FeedContent(feed: feed),
                    ],
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/feeds_write_page');
        },
        child: const Icon(Icons.edit),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        backgroundColor: const Color(0xFFA47764),
      ),
    );
  }
}

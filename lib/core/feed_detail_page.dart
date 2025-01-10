import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedDetailPage extends ConsumerStatefulWidget {
  final Feed feed;

  const FeedDetailPage({super.key, required this.feed});

  @override
  _FeedDetailPageState createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends ConsumerState<FeedDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Feed> filteredFeeds = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchFeeds(); // 피드 데이터를 가져옴
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchFeeds() async {
    // Firebase에서 데이터를 가져와서 filtering
    final snapshot = await FirebaseFirestore.instance
        .collection('feed')
        .where('cafeName', isEqualTo: widget.feed.cafeName)
        .get();

    setState(() {
      filteredFeeds =
          snapshot.docs.map((doc) => Feed.fromFirestore(doc)).toList();
    });
  }

  Future<void> _scrollListener() async {
    if (!mounted) return;

    if (!_isLoading &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToFeedPage() {
    Navigator.pushNamed(context, '/feeds_page');
  }

  void navigateToCafeDetailPage(String cafeName) {
    Navigator.pushNamed(
      context,
      '/cafe_detail_page',
      arguments: cafeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feed.cafeName),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  print('좋아요 버튼 터치됨');
                },
                child: const Icon(
                  Icons.favorite_border,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: filteredFeeds.length,
        itemBuilder: (BuildContext context, int index) {
          final feed = filteredFeeds[index];
          return GestureDetector(
            onTap: () {
              navigateToCafeDetailPage(feed.cafeName);
            },
            child: Column(
              children: [
                FeedInfo(feed: feed),
                const SizedBox(height: 12),
                FeedContent(feed: feed),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToFeedPage, // 전체 피드를 보기 위해 feeds_page로 이동
        child: Icon(Icons.arrow_back),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        backgroundColor: Color(0xFFA47764),
      ),
    );
  }
}

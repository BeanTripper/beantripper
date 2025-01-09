import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:flutter/material.dart';

class FeedDetailPage extends StatefulWidget {
  final Feed feed; // Add a field for the feed object

  const FeedDetailPage({super.key, required this.feed});

  @override
  State<FeedDetailPage> createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  final ScrollController _scrollController = ScrollController();
  List<int> items = List.generate(20, (index) => index);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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
        items.addAll(List.generate(10, (index) => items.length + index));
        _isLoading = false;
      });
    }
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
          )
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              FeedInfo(feed: widget.feed),
              const SizedBox(height: 12),
              FeedContent(feed: widget.feed),
            ],
          );
        },
      ),
    );
  }
}

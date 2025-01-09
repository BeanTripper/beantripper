import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:flutter/material.dart';

class FeedDetailPage extends StatefulWidget {
  const FeedDetailPage({super.key});

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
        title: Text('블루보틀'),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  print('좋아요 버튼 터치됨');
                },
                child: Icon(
                  Icons.favorite_border,
                  size: 32,
                ),
              ),
              SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 70,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              FeedInfo(),
              SizedBox(height: 12),
              FeedContent(),
            ],
          );
        },
      ),
    );
  }
}

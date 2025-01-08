import 'package:bean_tripper/presentation/pages/cafe_detail/widgets/cafe_feed_collection.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/widgets/cafe_info.dart';
import 'package:flutter/material.dart';

class CafeDetailPage extends StatefulWidget {
  const CafeDetailPage({super.key});

  @override
  State<CafeDetailPage> createState() => _CafeDetailPageState();
}

class _CafeDetailPageState extends State<CafeDetailPage> {
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
                  print('좋아요');
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
      body: ListView(
        controller: _scrollController,
        children: [
          SizedBox(height: 20),
          CafeInfo(),
          SizedBox(height: 20),
          CafeFeedCollection(items: items),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

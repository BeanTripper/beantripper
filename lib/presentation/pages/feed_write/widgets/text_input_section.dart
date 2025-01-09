import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';

class TextInputSection extends StatefulWidget {
  final FeedWriteViewModel viewModel;

  const TextInputSection({Key? key, required this.viewModel}) : super(key: key);

  @override
  _TextInputSectionState createState() => _TextInputSectionState();
}

class _TextInputSectionState extends State<TextInputSection> {
  bool isLoading = false;

  // 네이버 지도 API 호출
  Future<void> fetchCafes(String query) async {
    if (query.isEmpty) {
      setState(() {
        widget.viewModel.searchResults.clear();
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await widget.viewModel.searchCafes(query);
    } catch (e) {
      print('카페 검색 중 오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = widget.viewModel.searchResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카페',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            hintText: '카페 이름을 입력해주세요',
            border: OutlineInputBorder(),
          ),
          onChanged: (query) {
            widget.viewModel.setCafeName(query);
            fetchCafes(query);
          },
        ),
        const SizedBox(height: 20),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (searchResults.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final cafe = searchResults[index];
              return ListTile(
                title: Text(cafe['name']),
                subtitle: Text(cafe['address']),
                onTap: () {
                  widget.viewModel.setCafeName(cafe['name']);
                  setState(() {
                    widget.viewModel.searchResults.clear();
                  });
                },
              );
            },
          ),
        const Text(
          '게시글',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '게시글을 작성해주세요',
            border: OutlineInputBorder(),
          ),
          onChanged: widget.viewModel.setPostContent,
        ),
      ],
    );
  }
}


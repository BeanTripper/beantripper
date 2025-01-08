import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';

class TextInputSection extends StatefulWidget {
  final FeedWriteViewModel viewModel;

  const TextInputSection({Key? key, required this.viewModel}) : super(key: key);

  @override
  _TextInputSectionState createState() => _TextInputSectionState();
}

class _TextInputSectionState extends State<TextInputSection> {
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  // 네이버 지도 API 호출
  Future<void> fetchCafes(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      // 네이버 지도 API 호출 (여기에 실제 API 호출 로직을 추가하세요)
      final response = await widget.viewModel.searchCafes(query);

      setState(() {
        searchResults = response; // 검색 결과 설정
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('카페 검색 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    searchResults.clear();
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

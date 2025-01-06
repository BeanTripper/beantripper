import 'package:flutter/material.dart';

class FeedWritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작성하기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // 배경 터치 시 키보드 숨기기
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지 선택 섹션
                const SizedBox(height: 20),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () {
                      // 이미지 추가 기능
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // 카페 입력 섹션
                const Text(
                  '카페',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: '카페 이름을 입력해주세요',
                            hintStyle: TextStyle(fontSize: 16),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // 검색 아이콘 동작
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // 게시글 입력 섹션
                const Text(
                  '게시글',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: '게시글을 작성해주세요',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 태그 버튼 섹션
                const Text(
                  '태그',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatefulTagButton(label: '커피맛집'),
                    StatefulTagButton(label: '모던한'),
                    StatefulTagButton(label: '디자인이 예쁜'),
                    StatefulTagButton(label: '따뜻한'),
                    StatefulTagButton(label: '깔끔한'),
                    StatefulTagButton(label: '다시 방문하고 싶은'),
                  ],
                ),
                const SizedBox(height: 20),
                // 작성 완료 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 작성 완료 버튼 기능
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA47764),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      '작성 완료',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatefulTagButton extends StatefulWidget {
  final String label;

  const StatefulTagButton({Key? key, required this.label}) : super(key: key);

  @override
  _StatefulTagButtonState createState() => _StatefulTagButtonState();
}

class _StatefulTagButtonState extends State<StatefulTagButton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFA47764) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

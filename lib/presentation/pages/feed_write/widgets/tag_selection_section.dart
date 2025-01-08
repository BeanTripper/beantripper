import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';

class TagSelectionSection extends StatelessWidget {
  final FeedWriteViewModel viewModel;

  const TagSelectionSection({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = ['커피맛집', '모던한', '디자인이 예쁜', '따뜻한', '깔끔한', '다시 방문하고 싶은'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text( 
          '태그',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            final isSelected = viewModel.categories.contains(tag); // 변경된 부분
            return GestureDetector(
              onTap: () {
                viewModel.toggleTagSelection(tag);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFA47764) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';

class TextInputSection extends StatelessWidget {
  final FeedWriteViewModel viewModel;

  const TextInputSection({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '카페',
          style: TextStyle(
            fontSize: 20,
            color: CustomColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          viewModel.cafeName.isNotEmpty ? viewModel.cafeName : '카페 이름이 없습니다.',
          style: const TextStyle(fontSize: 18, color: CustomColors.darkGray),
        ),
        const SizedBox(height: 20),
        const Text(
          '게시글',
          style: TextStyle(
            fontSize: 20,
            color: CustomColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '게시글을 작성해주세요',
            border: OutlineInputBorder(),
          ),
          onChanged: viewModel.setPostContent,
        ),
      ],
    );
  }
}

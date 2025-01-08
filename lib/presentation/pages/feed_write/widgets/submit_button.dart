import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';

class SubmitButton extends StatelessWidget {
  final FeedWriteViewModel viewModel;

  const SubmitButton({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await viewModel.uploadDataToFirebase();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('업로드 성공!')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('업로드 실패: $e')),
            );
          }
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
    );
  }
}

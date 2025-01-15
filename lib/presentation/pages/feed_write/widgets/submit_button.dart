import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';
import 'package:bean_tripper/presentation/pages/home/home_page.dart';

class SubmitButton extends StatelessWidget {
  final FeedWriteViewModel viewModel;
  final String userName; // userName 파라미터 추가

  const SubmitButton({
    Key? key,
    required this.viewModel,
    required this.userName, // userName 파라미터 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await viewModel.uploadDataToFirebase(userName); // userName 전달
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('업로드 성공!')),
            );
            Navigator.pushReplacementNamed(context, '/feeds_page');
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

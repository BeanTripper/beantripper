import 'package:flutter/material.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';
import 'package:bean_tripper/presentation/pages/home/home_page.dart';

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

            // 업로드 성공 시 홈 페이지로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('게시글 작성과 태그선택을 완료해 주세요.')),
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

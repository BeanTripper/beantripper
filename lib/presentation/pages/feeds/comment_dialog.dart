import 'package:flutter/material.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/data/repository/comment_repository.dart';

void showCommentDialog(BuildContext context, Feed post) {
  final TextEditingController _commentController = TextEditingController();
  final CommentRepository _commentRepository =
      CommentRepository(); // Repository 인스턴스 생성

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글 입력',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Repository를 사용하여 Firebase에 댓글 저장
                await _commentRepository.addComment(
                    post.id, _commentController.text);
                Navigator.pop(context); // 댓글 입력 후 창 닫기
              },
              child: Text('댓글 등록'),
            ),
          ],
        ),
      );
    },
  );
}

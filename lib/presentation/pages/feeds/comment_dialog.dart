import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/domain/entity/feed.dart';

void showCommentDialog(BuildContext context, Feed post) {
  final TextEditingController _commentController = TextEditingController();
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
                // Firebase에 댓글 저장
                await FirebaseFirestore.instance.collection('comments').add({
                  'postId': post.id,
                  'comment': _commentController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });
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

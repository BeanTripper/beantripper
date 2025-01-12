import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/data/repository/comment_repository.dart';

class CommentPage extends StatefulWidget {
  final Feed feed;

  const CommentPage({Key? key, required this.feed}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CommentRepository _commentRepository = CommentRepository();

  Future<void> _addComment(String comment) async {
    if (comment.isNotEmpty) {
      final user = _auth.currentUser;
      if (user != null) {
        await _commentRepository.addComment(
          widget.feed.id,
          user.uid,
          user.displayName ?? 'Unknown',
          comment,
        );
        _commentController.clear();
      }
    }
  }

  String formatDate(Timestamp timestamp) {
    var date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'; // 날짜 형식 변경
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('댓글'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('feed')
                  .doc(widget.feed.id)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0), // 간격 조정
                      child: ListTile(
                        title: Text(comment['userName']),
                        subtitle: Text(comment['content']),
                        trailing: Text(
                          formatDate(comment['timestamp']), // 날짜 형식 변경
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: '댓글 입력',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _addComment(_commentController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

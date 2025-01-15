import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/data/repository/comment_repository.dart';
import 'package:bean_tripper/domain/repository/report_repository.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  final ReportRepository _reportRepository = ReportRepository(); // 신고 리포지토리 추가

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  }

  Future<void> _addComment(String comment) async {
    if (comment.isNotEmpty) {
      final user = _auth.currentUser;
      if (user != null) {
        await _commentRepository.addComment(
          widget.feed.id,
          comment,
        );
        _commentController.clear();
      }
    }
  }

  Future<void> _reportComment(String commentId, String reason) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _reportRepository.reportComment(
        widget.feed.id,
        commentId,
        reason,
      );
    }
  }

  String formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final date = timestamp.toDate();

    if (now.difference(date).inHours < 24) {
      return timeago.format(date, locale: 'ko');
    }

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void showReportDialog(String commentId) {
    TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('신고 사유를 입력하세요'),
          content: TextField(
            controller: reportController,
            decoration: InputDecoration(hintText: '신고 사유'),
          ),
          actions: [
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('신고'),
              onPressed: () {
                _reportComment(commentId, reportController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: CustomColors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  final currentSize = scrollController.position.pixels /
                      MediaQuery.of(context).size.height;
                  final newSize = currentSize -
                      (details.primaryDelta! /
                          MediaQuery.of(context).size.height);
                  final clampedSize = newSize.clamp(0.3, 0.9);
                  scrollController
                      .jumpTo(clampedSize * MediaQuery.of(context).size.height);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColors.darkGray,
                      ),
                    ),
                  ),
                ),
              ),
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
                      controller: scrollController,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        final commentId = comment.id;
                        final timestamp = comment['timestamp'] as Timestamp?;
                        return ListTile(
                          title: Text(comment['userName'] ?? '게스트'),
                          subtitle: Text(comment['content'] ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(formatDate(timestamp)),
                              IconButton(
                                icon: Icon(Icons.flag),
                                onPressed: () {
                                  showReportDialog(commentId);
                                },
                              ),
                            ],
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
      },
    );
  }
}

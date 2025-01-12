import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/core/comment_page.dart';

class FeedContent extends StatefulWidget {
  final Feed feed;

  const FeedContent({
    super.key,
    required this.feed,
  });

  @override
  _FeedContentState createState() => _FeedContentState();
}

class _FeedContentState extends State<FeedContent> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    checkIfLiked();
    getLikeCount();
  }

  // 현재 사용자가 이 피드를 좋아요 했는지 확인
  void checkIfLiked() async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    final favoriteFeedRef = FirebaseFirestore.instance
        .collection('feed')
        .doc(widget.feed.id)
        .collection('favoriteFeed')
        .where('user_list', arrayContains: userId);

    final snapshot = await favoriteFeedRef.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isLiked = true;
      });
    }
  }

  // 좋아요 수 가져오기
  void getLikeCount() async {
    final favoriteFeedRef = FirebaseFirestore.instance
        .collection('feed')
        .doc(widget.feed.id)
        .collection('favoriteFeed');

    final snapshot = await favoriteFeedRef.get();
    int count = 0;
    for (var doc in snapshot.docs) {
      final userList = List<String>.from(doc['user_list']);
      count += userList.length;
    }
    setState(() {
      likeCount = count;
    });
  }

  // 댓글 수를 실시간으로 가져오는 Stream
  Stream<int> getCommentCountStream() {
    return FirebaseFirestore.instance
        .collection('feed')
        .doc(widget.feed.id)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // 좋아요 토글 기능
  void toggleLike() async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final favoriteFeedRef = FirebaseFirestore.instance
        .collection('feed')
        .doc(widget.feed.id)
        .collection('favoriteFeed')
        .where('user_list', arrayContains: userId);

    final snapshot = await favoriteFeedRef.get();
    if (snapshot.docs.isNotEmpty) {
      // 좋아요 취소 로직
      final docId = snapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('feed')
          .doc(widget.feed.id)
          .collection('favoriteFeed')
          .doc(docId)
          .update({
        'user_list': FieldValue.arrayRemove([userId]),
      });
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      // 좋아요 추가 로직
      await FirebaseFirestore.instance
          .collection('feed')
          .doc(widget.feed.id)
          .collection('favoriteFeed')
          .add({
        'user_list': FieldValue.arrayUnion([userId]),
      });
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  // 바텀시트로 댓글 페이지 띄우기
  void showCommentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: CommentPage(
                    feed: widget.feed,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 카테고리 변환 함수
  String convertCategoriesToTags(List<String> categories) {
    return categories.map((category) => '#$category').join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        if (widget.feed.imageUrls.isNotEmpty)
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemCount: widget.feed.imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: CustomColors.darkGray,
                    image: DecorationImage(
                      image: NetworkImage(widget.feed.imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),

        // 좋아요 및 댓글 버튼 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              InkWell(
                onTap: toggleLike, // 좋아요 토글 기능 연결
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                  color: isLiked ? Colors.red : null,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '$likeCount', // 좋아요 수 표시
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, size: 30),
                onPressed: showCommentsBottomSheet, // 바텀시트로 댓글 페이지 띄우기
              ),
              SizedBox(width: 6),
              StreamBuilder<int>(
                stream: getCommentCountStream(),
                builder: (context, snapshot) {
                  final commentCount = snapshot.data ?? 0;
                  return Text(
                    '$commentCount',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ],
          ),
        ),

        // 해시태그 표시 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            convertCategoriesToTags(widget.feed.categories), // 카테고리 변환
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.white), // 텍스트 스타일 설정
          ),
        ),

        // 피드 내용 표시 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpandableText(
            widget.feed.content, // 피드 내용
            style: TextStyle(fontSize: 16, height: 1.3), // 텍스트 스타일 설정
            expandText: '더보기', // 펼치기 버튼 텍스트
            collapseText: '접기', // 접기 버튼 텍스트
            maxLines: 2, // 최대 줄 수 설정
            linkColor: CustomColors.darkGray, // 링크 색상 설정
          ),
        ),
        SizedBox(height: 27), // 하단 공간 추가
      ],
    );
  }
}

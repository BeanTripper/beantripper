import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/core/feed_categories.dart';
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
        .where('userId', isEqualTo: userId);

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
    setState(() {
      likeCount = snapshot.docs.length;
    });
  }

  // 좋아요 토글 기능
  void toggleLike() async {
    final userId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final favoriteFeedRef = FirebaseFirestore.instance
        .collection('feed')
        .doc(widget.feed.id)
        .collection('favoriteFeed')
        .where('userId', isEqualTo: userId);

    final snapshot = await favoriteFeedRef.get();
    if (snapshot.docs.isNotEmpty) {
      // 좋아요 취소 로직
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
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
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  // 댓글 페이지로 이동
  void navigateToComments() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentPage(feed: widget.feed), // CommentPage로 이동
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 피드 이미지 표시 영역
        SizedBox(
          height: MediaQuery.of(context).size.width,
          child: PageView.builder(
            itemCount: widget.feed.imageUrls.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: CustomColors.darkGray, // 배경색 설정
                  image: DecorationImage(
                    image:
                        NetworkImage(widget.feed.imageUrls[index]), // 각 이미지 사용
                    fit: BoxFit.cover, // 이미지 비율 유지하면서 크기에 맞게 조절
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12), // 이미지와 버튼 사이에 공간 추가

        // 좋아요 및 댓글 버튼 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                onPressed: navigateToComments, // 댓글 페이지로 이동 기능 연결
              ),
              SizedBox(width: 6),
              Text(
                '${widget.feed.commentCount}', // 댓글 수 표시
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // 피드 카테고리 표시 영역
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: feedCategories(widget.feed.categories), // 카테고리 표시
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
        Text(widget.feed.cafeName), // 테스트를 위해 카페 이름을 추가
      ],
    );
  }
}

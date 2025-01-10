import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/core/feed_categories.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  void initState() {
    super.initState();
    checkIfLiked();
  }

  void checkIfLiked() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null &&
        widget.feed.popularList != null &&
        widget.feed.popularList!.any((user) => user.id == userId)) {
      setState(() {
        isLiked = true;
      });
    }
  }

  void toggleLike() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final feedRef =
        FirebaseFirestore.instance.collection('feed').doc(widget.feed.id);
    if (isLiked) {
      widget.feed.popularList!.removeWhere((user) => user.id == userId);
      await feedRef.update({
        'popularList': FieldValue.arrayRemove([userId])
      });
    } else {
      widget.feed.popularList!.add(User(
          id: userId,
          name: FirebaseAuth.instance.currentUser!.displayName ?? ''));
      await feedRef.update({
        'popularList': FieldValue.arrayUnion([userId])
      });
    }

    setState(() {
      isLiked = !isLiked;
    });
  }

  void navigateToComments() {
    Navigator.pushNamed(context, '/comment_page', arguments: widget.feed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: CustomColors.darkGray,
            image: widget.feed.imageUrls.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(
                        widget.feed.imageUrls.first), // 첫 번째 이미지 사용
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              GestureDetector(
                onTap: toggleLike,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                  color: isLiked ? Colors.red : null,
                ),
              ),
              SizedBox(width: 6),
              Text(
                '${widget.feed.popularCount}', // 좋아요 수
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: navigateToComments,
                child: Icon(Icons.chat_bubble_outline, size: 30),
              ),
              SizedBox(width: 6),
              Text(
                '${widget.feed.commentCount}', // 댓글 수
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: feedCategories(widget.feed.categories),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpandableText(
            widget.feed.content,
            style: TextStyle(fontSize: 16, height: 1.3),
            expandText: '더보기',
            collapseText: '접기',
            maxLines: 2,
            linkColor: CustomColors.darkGray,
          ),
        ),
        SizedBox(height: 27),
      ],
    );
  }
}

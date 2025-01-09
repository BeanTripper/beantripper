import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/core/feed_categories.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class FeedContent extends StatelessWidget {
  final Feed feed;

  const FeedContent({
    super.key,
    required this.feed,
  });

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
            image: feed.imageUrls.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(feed.imageUrls.first), // 첫 번째 이미지 사용
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
                onTap: () {
                  print('좋아요');
                },
                child: Icon(Icons.favorite_border, size: 30),
              ),
              SizedBox(width: 6),
              Text(
                '123', // 좋아요 수는 현재 Feed 엔티티에 정의되지 않았으므로 기본값 사용
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  print('댓글');
                },
                child: Icon(Icons.chat_bubble_outline, size: 30),
              ),
              SizedBox(width: 6),
              Text(
                '123', // 댓글 수는 현재 Feed 엔티티에 정의되지 않았으므로 기본값 사용
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: feedCategories(feed.categories), // 수정: categories 사용
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpandableText(
            feed.content, // 수정: content 사용
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

import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/core/feed_categories.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class FeedContent extends StatelessWidget {
  const FeedContent({super.key});

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
                '123',
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
                '123',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: feedCategories(['따듯한', '다시 방문하고 싶은', '모던한']),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ExpandableText(
            '나는 무엇인지 그리워 이 많은 별빛이 내린 언덕 위에 내 이름자를 써보고 흙으로 덮어 버리었읍니다. 가슴 속에 하나 둘 새겨지는 별을 이제 다 ',
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

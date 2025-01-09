import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:flutter/material.dart';

class FeedInfo extends StatelessWidget {
  final Feed feed;

  const FeedInfo({
    super.key,
    required this.feed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: CustomColors.darkGray,
              ),
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feed.writerName, // 수정: writerName 사용
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${feed.createdAt.toDate()}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

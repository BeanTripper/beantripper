import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedInfo extends ConsumerWidget {
  Feed feed;

  FeedInfo({
    super.key,
    required this.feed,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                feed.writerName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${feed.createdAt.toDate()}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              final viewModel = ref.read(cafeDetailViewModelProvider.notifier);
              viewModel.setCafeName(feed.cafeName);
              Navigator.pushNamed(
                context,
                '/cafe_detail_page',
              );
            },
            child: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

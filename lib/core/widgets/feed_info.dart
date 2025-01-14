import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class FeedInfo extends ConsumerWidget {
  Feed feed;

  FeedInfo({
    super.key,
    required this.feed,
  });
  // 한국어 로케일 설정을 위한 초기화

  String formatDate(DateTime date) {
    final now = DateTime.now();

    // 24시간 이내인 경우 "~분 전", "~시간 전"으로 표시
    if (now.difference(date).inHours < 24) {
      return timeago.format(date, locale: 'ko');
    }

    // 24시간 이상인 경우 "yyyy-MM-dd" 형식으로 표시
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: feed.userProfile.isNotEmpty
                ? NetworkImage(feed.userProfile)
                : null, // 프로필 이미지 설정
            radius: 21,
            child: feed.userProfile.isEmpty
                ? Icon(Icons.person, size: 30, color: Colors.grey) // 기본 아이콘 설정
                : null,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feed.userName, // 닉네임 표시
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                formatDate(feed.createdAt.toDate()),
                style: TextStyle(
                  color: CustomColors.darkGray,
                  fontSize: 14,
                ),
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

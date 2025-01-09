import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_view_model.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/widgets/cafe_feed_collection.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/widgets/cafe_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CafeDetailPage extends ConsumerWidget {
  const CafeDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeDetailViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.cafeDetail?.name ?? '카페 상세'),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  print('좋아요');
                },
                child: Icon(
                  Icons.favorite_border,
                  size: 32,
                ),
              ),
              SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          CafeInfo(),
          SizedBox(height: 20),
          CafeFeedCollection(items: List.generate(20, (index) => index)),
        ],
      ),
    );
  }
}

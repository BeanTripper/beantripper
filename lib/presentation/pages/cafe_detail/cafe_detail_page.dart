import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_view_model.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/widgets/cafe_feed_collection.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/widgets/cafe_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CafeDetailPage extends ConsumerWidget {
  const CafeDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeDetailViewModelProvider);
    final viewModel = ref.read(cafeDetailViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.cafeDetail?.name ?? '카페 상세'),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    // 로그인되지 않은 경우 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('로그인이 필요한 기능입니다.')),
                    );
                    return;
                  }
                  await viewModel.toggleFavorite();
                },
                child: Icon(
                  state.isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 32,
                  color: state.isFavorite ? CustomColors.onError : null,
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
          if (state.cafeDetail?.name != null)
            CafeFeedCollection(cafeName: state.cafeDetail!.name),
        ],
      ),
    );
  }
}
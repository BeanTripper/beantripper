import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CafeInfo extends ConsumerWidget {
  const CafeInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cafeDetailViewModelProvider);
    final cafeDetail = state.cafeDetail;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cafeDetail?.address ?? '주소 정보 없음',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Icon(Icons.local_phone),
                    SizedBox(width: 6),
                    Text(cafeDetail?.tel ?? '전화번호 정보 없음'),
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: CustomColors.brown,
              ),
              child: Text(
                '지도',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

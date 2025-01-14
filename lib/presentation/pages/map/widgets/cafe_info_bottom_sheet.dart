import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CafeInfoBottomSheet extends ConsumerWidget {
  const CafeInfoBottomSheet({
    super.key,
    required this.cafe,
  });

  final CafeDetail? cafe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CustomColors.black,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cafe?.name ?? '',
                style: TextStyle(
                  fontSize: 20,
                  color: CustomColors.brown,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cafe?.address ?? '',
                      style: TextStyle(color: CustomColors.brown),
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.brown,
                      foregroundColor: CustomColors.white,
                    ),
                    onPressed: () {
                      final viewModel =
                          ref.read(cafeDetailViewModelProvider.notifier);
                      viewModel.setCafeName(cafe!.id);
                      Navigator.pushNamed(
                        context,
                        '/cafe_detail_page',
                      );
                    },
                    child: Text('상세보기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

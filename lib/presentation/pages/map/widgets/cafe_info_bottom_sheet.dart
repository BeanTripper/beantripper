import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/domain/entity/cafe_detail.dart';
import 'package:flutter/material.dart';

class CafeInfoBottomSheet extends StatelessWidget {
  const CafeInfoBottomSheet({
    super.key,
    required this.cafe,
  });

  final CafeDetail? cafe;

  @override
  Widget build(BuildContext context) {
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
                      Navigator.pushNamed(
                        context,
                        '/cafe_detail_page',
                        arguments: cafe!.id,
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

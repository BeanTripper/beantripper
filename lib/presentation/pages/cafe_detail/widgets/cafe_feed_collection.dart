import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/core/feed_detail_page.dart';
import 'package:flutter/material.dart';

class CafeFeedCollection extends StatelessWidget {
  final List<int> items;

  const CafeFeedCollection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print('아이템 ${items[index]}');
            Navigator.pushNamed(context, '/feed_detail_page');
          },
          child: Container(
            decoration: BoxDecoration(
              color: CustomColors.darkGray,
            ),
            child: Center(
              child: Text('Item ${items[index]}'),
            ),
          ),
        );
      },
    );
  }
}

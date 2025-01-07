import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';

class FeedInfo extends StatelessWidget {
  const FeedInfo({
    super.key,
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
                '카페상속자',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('1분전'),
            ],
          ),
          Spacer(),
          Icon(Icons.arrow_forward),
        ],
      ),
    );
  }
}

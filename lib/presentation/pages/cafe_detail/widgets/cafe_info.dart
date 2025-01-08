import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';

class CafeInfo extends StatelessWidget {
  const CafeInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  '충북 청주시 흥덕구 가경동',
                  style: TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    Text(
                      '영업중 ',
                      style: TextStyle(color: CustomColors.blue),
                    ),
                    Text('· 오후 10:00에 영업 종료'),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(Icons.local_phone),
                    SizedBox(width: 6),
                    Text('043-123-1234'),
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

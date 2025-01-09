import 'package:flutter/material.dart';

class LookingAroundButton extends StatelessWidget {
  const LookingAroundButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/feeds_page'),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text('둘러보기'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

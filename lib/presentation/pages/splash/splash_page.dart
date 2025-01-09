import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '커피를 따라 떠나는 여행자',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: CustomColors.brown,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              "assets/images/login_logo.png",
              width: 234,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/login/login_page_view_model.dart';
import 'package:bean_tripper/presentation/pages/login/widget/custom_social_button.dart';
import 'package:bean_tripper/presentation/pages/login/widget/looking_around_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

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

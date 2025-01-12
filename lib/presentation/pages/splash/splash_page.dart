import 'package:bean_tripper/constant/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    //widget에서 화면을 실시 후 처음으로 하는 액션
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        //2초 딜레이
        await Future.delayed(Duration(seconds: 2));
        //비동기 처리하고 해당 화면에 있는지 확인 후
        if (!context.mounted) {
          return;
        }
        //firebaseauth 현재 유저 여부
        FirebaseAuth.instance.currentUser == null
            ? Navigator.pushReplacementNamed(context, '/login_page')
            : Navigator.pushReplacementNamed(context, '/feeds_page');
      },
    );
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

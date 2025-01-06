import 'package:bean_tripper/presentation/pages/login/login_page_view_model.dart';
import 'package:bean_tripper/presentation/pages/login/widget/custom_social_button.dart';
import 'package:bean_tripper/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    width: 210,
                  ),
                ],
              ),
            ),
            Consumer(builder: (context, ref, child) {
              // final userState=ref.watch( loginPageViewModel );
              // final userViewModel=ref.read(loginPageViewModel.notifier
              // )
//TODO 뷰모델 갖고오기.

              return Column(
                children: [
                  Spacer(),
                  CustomSocialButton(
                    text: "카카오로 시작하기",
                    backgroundColor: const Color(0xFFFAE100),
                    textColor: CustomColors.black,
                    iconPath: "assets/images/kakao_icon.png",
                    onPressed: () async {},
                    iconSize: 20,
                  ),
                  const SizedBox(height: 20),
                  CustomSocialButton(
                    text: "구글로 시작하기",
                    backgroundColor: Colors.white,
                    textColor: CustomColors.black,
                    iconPath: "assets/images/google_icon.png",
                    onPressed: () async {
                      // TODO signInWithGoogle();
                    },
                    iconSize: 20,
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: CustomColors.lightGrey,
                    thickness: 1,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '둘러보기',
                  ),
                  const SizedBox(height: 20),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}

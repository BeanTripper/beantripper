import 'package:bean_tripper/presentation/pages/login/widget/custom_social_button.dart';
import 'package:bean_tripper/theme.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  Image.asset(
                    "assets/images/login_logo.png",
                    width: 210,
                  ),
                ],
              ),
            ),
            Column(
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
                  onPressed: () async {},
                  iconSize: 20,
                ),
                const SizedBox(height: 20)
              ],
            )
          ],
        ),
      ),
    );
  }
}

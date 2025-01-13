import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page.dart';
import 'package:bean_tripper/presentation/view_model/auth_view_model.dart';
import 'package:bean_tripper/presentation/pages/login/widget/custom_social_button.dart';
import 'package:bean_tripper/presentation/pages/login/widget/looking_around_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Consumer(
          builder: (context, ref, child) {
            final userState = ref.watch(authViewModelProvider);
            final userViewModel = ref.read(authViewModelProvider.notifier);
            return Column(
              children: [
                SizedBox(height: 150),
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
                Spacer(),
                CustomSocialButton(
                  text: "카카오로 시작하기",
                  backgroundColor: const Color(0xFFFAE100),
                  textColor: CustomColors.black,
                  iconPath: "assets/images/kakao_icon.png",
                  onPressed: () async {
                    await userViewModel.signInWithKakao();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pushReplacementNamed(context, '/register_page');
                  },
                  iconSize: 20,
                ),
                const SizedBox(height: 20),
                CustomSocialButton(
                  text: "구글로 시작하기",
                  backgroundColor: Colors.white,
                  textColor: CustomColors.black,
                  iconPath: "assets/images/google_icon.png",
                  onPressed: () async {
                    await userViewModel.signInWithGoogle();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.pushNamed(context, '/register_page');
                  },
                  iconSize: 20,
                ),
                const SizedBox(height: 20),
                Divider(
                  color: CustomColors.lightGray,
                  thickness: 1,
                ),
                const LookingAroundButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}

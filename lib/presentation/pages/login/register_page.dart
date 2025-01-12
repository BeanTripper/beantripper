import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  TextEditingController nicknameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName);
  // 초기값 sns이름
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(authViewModelProvider);
    final userViewModel = ref.read(authViewModelProvider.notifier);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          "회원가입",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                widthFactor: double.infinity,
                heightFactor: 2,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CustomColors.lightGray,
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: CustomColors.white,
                    child: userState.appUser?.profile != null
                        ? ClipOval(
                            child: Image.network(
                              userState.appUser?.profile ?? '',
                            ),
                          )
                        : Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: nicknameController,
                  onChanged: (value) {
                    value.isNotEmpty
                        ? userViewModel.updateUserNickname(value)
                        : userViewModel
                            .updateUserNickname(nicknameController.text);
                  },
                  decoration: InputDecoration(
                    hintText: nicknameController.text,
                    hintStyle: TextStyle(color: CustomColors.white),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: CustomColors.lightGray,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: CustomColors.lightGray,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  onPressed: () async {
                    await userViewModel.submitUserToFirestore();
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/feeds_page');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "회원가입 하기",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState {
  final AppUser? appUser;
  LoginState({required this.appUser});
}

class LoginPageViewModel extends Notifier<LoginState> {
  @override
  LoginState build() {
    return LoginState(appUser: null);
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      //google 로그인

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // 구글에서 받은 accessToken과 idToken을 firebase가 이해할수 있는 걸로 변환
        // .credential이라는 메서드는 google_auth 패키지의 것
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        // Firebase에 로그인(앱에 로그인하는 것과는 별개임)
        // 새 사용자라면 Firebase Authentication에서 사용자 생성
        final user = userCredential.user;
        // TODO 뷰모델 완성
        if (user != null) {
          final fetchUser = await fetchUserUseCaseProvider;
          if (fetchUser != null) {
            // TODO state=LoginState(appUser: fetchUser);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  final loginPageViewModelProvider =
      NotifierProvider<LoginPageViewModel, LoginState>(() {
    return LoginPageViewModel();
  });
}

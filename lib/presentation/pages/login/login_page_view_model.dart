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

  ///Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // await googleSignIn.signOut(); //로그아웃 기능
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
        if (user != null) {
          final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);
          final fetchedUser = await fetchUserUseCase.fetchUser(user.uid);
          print('fetchedUser $fetchedUser');
          //TODO 매개변수 user.uid가 맞는지?
          if (fetchedUser != null) {
            state = LoginState(appUser: fetchedUser);
          } else {
            //user 가 firestore에 없으면 firestore에 등록. registerpage
            //updateUserToFirestore
            //submitUserToFirestore
            state = LoginState(
              appUser: AppUser(
                id: user.uid,
                name: user.displayName ?? "",
                profile: user.photoURL ?? "",
              ),
            );
          }
        }
      }
    } catch (e) {
      state = LoginState(appUser: null);
      print(e);
    }
  }

  Future<void> submitUserToFirestore() async {
    final user = state.appUser;
    if (user != null) {
      try {
        final updateUserUseCase = ref.read(updateUserUseCaseProvider);
        final updateUser = await updateUserUseCase.updateUser(user);
      } catch (e) {
        print(e);
      }
    }
  }
}

final loginPageViewModelProvider =
    NotifierProvider<LoginPageViewModel, LoginState>(() {
  return LoginPageViewModel();
});

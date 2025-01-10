import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

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
      final signInWithGoogleUseCase = ref.read(signInWithGoogleUseCaseProvider);
      final user = await signInWithGoogleUseCase.signInWithGoogle();
      if (user != null) {
        final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);
        final fetchedUser = await fetchUserUseCase.fetchUser(user.id);
        if (fetchedUser != null) {
          state = LoginState(appUser: fetchedUser);
        } else {
          //user 가 firestore에 없으면 firestore에 등록. registerPage
          //updateUserToFirestore
          //submitUserToFirestore
          state = LoginState(
            appUser: AppUser(
              id: user.id,
              name: user.name ?? "",
              profile: user.profile ?? "",
            ),
          );
          submitUserToFirestore();
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  ///kakao 로그인
  Future<void> signInWithKakao() async {
    try {
      print(1);
      // await UserApi.instance.logout(); 카카오 로그아웃기능
      final isInstalled = await isKakaoTalkInstalled();
      print(2);
      final OAuthToken oAuthToken = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();
      //카카오로그인
      print(3);
print(oAuthToken);
      final OAuthProvider oAuthProvider = OAuthProvider('oidc.kakao');
      final OAuthCredential oAuthCred = oAuthProvider.credential(
        accessToken: oAuthToken.accessToken,
        idToken: oAuthToken.idToken,
      );
print(oAuthCred);
      //firebase 에 저장
      // 구글에서 받은 accessToken과 idToken을 firebase가 이해할수 있는 걸로 변환
      // .credential이라는 메서드는 kakao_flutter_sdk_user 패키지의 것
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oAuthCred);
          print(userCredential);
      // Firebase에 로그인(앱에 로그인하는 것과는 별개임)
      // 새 사용자라면 Firebase Authentication에서 사용자 생성
      final user = userCredential.user;
      print(user);
      if (user != null) {
        final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);
        final fetchedUser = await fetchUserUseCase.fetchUser(user.uid);

        if (fetchedUser != null) {
          state = LoginState(appUser: fetchedUser);
        } else {
          //user 가 firestore에 없으면 firestore에 등록. registerPage
          //updateUserToFirestore
          //submitUserToFirestore
          state = LoginState(
            appUser: AppUser(
              id: user.uid,
              name:
                  userCredential.additionalUserInfo?.profile?['nickname'] ?? "",
              profile:
                  userCredential.additionalUserInfo?.profile?['picture'] ?? "",
            ),
          );
          submitUserToFirestore();
        }
      }
    } catch (e,s) {
      state = LoginState(appUser: null);
      print(3333);
      print(e);
      print(s);
    }
  }

  Future<void> submitUserToFirestore() async {
    final user = state.appUser;
    if (user != null) {
      try {
        final updateUserUseCase = ref.read(updateUserUseCaseProvider);
        final updateUser = await updateUserUseCase.updateUser(user);

        /// TODO UPDATE -> SAVE로 변경.
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateUserNickname(String newNickname) async {
    final user = state.appUser;
    if (user != null) {
      state = LoginState(
        appUser: AppUser(
          id: state.appUser?.id ?? '',
          name: newNickname,
          profile: state.appUser?.profile ?? '',
        ),
      );
    }
  }
}

final loginPageViewModelProvider =
    NotifierProvider<LoginPageViewModel, LoginState>(() {
  return LoginPageViewModel();
});

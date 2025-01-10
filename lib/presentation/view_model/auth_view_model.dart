import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthState {
  /// 파이어베이스 로그인 정보
  final AppUser? appUser;

  /// 구글로그인 정보 user에서 할당
  final AppUser? originInfo;
  AuthState({
    required this.appUser,
    required this.originInfo,
  });
}

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return AuthState(
      appUser: null,
      originInfo: null,
    );
  }

  ///구글로그인
  Future<void> signInWithGoogle() async {
    try {
      final signInWithGoogleUseCase = ref.read(signInWithGoogleUseCaseProvider);
      final user = await signInWithGoogleUseCase.signInWithGoogle();
      //user 구글로그인정보
      if (user != null) {
        final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);
        final fetchedUser = await fetchUserUseCase.fetchUser(user.id);
        print(3);
        print('^^^^^^^^^^^^^^^^^^^^^^${user.id}');
        print('%%%%%%%%%%%%%%%${fetchedUser?.id}');
        state = AuthState(
          appUser: fetchedUser,
          originInfo: user,
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  ///kakao 로그인
  Future<void> signInWithKakao() async {
    // try {
    //   // final isInstalled = await isKakaoTalkInstalled();
    //   // final OAuthToken oAuthToken = isInstalled
    //   //     ? await UserApi.instance.loginWithKakaoTalk()
    //   //     : await UserApi.instance.loginWithKakaoAccount();
    //   // //카카오로그인

    //   // final OAuthProvider oAuthProvider = OAuthProvider('oidc.kakao');
    //   // final OAuthCredential oAuthCred = oAuthProvider.credential(
    //   //   accessToken: oAuthToken.accessToken,
    //   //   idToken: oAuthToken.idToken,
    //   // );

    //   // //firebase 에 저장
    //   // // 구글에서 받은 accessToken과 idToken을 firebase가 이해할수 있는 걸로 변환
    //   // // .credential이라는 메서드는 kakao_flutter_sdk_user 패키지의 것
    //   // final UserCredential userCredential =
    //   //     await FirebaseAuth.instance.signInWithCredential(oAuthCred);
    //   // // Firebase에 로그인(앱에 로그인하는 것과는 별개임)
    //   // // 새 사용자라면 Firebase Authentication에서 사용자 생성
    //   // final user = userCredential.user;
    //   // if (user != null) {
    //   //   final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);
    //   //   final fetchedUser = await fetchUserUseCase.fetchUser(user.uid);

    //   //   if (fetchedUser != null) {
    //   //     state = AuthState(appUser: fetchedUser);
    //   //   } else {
    //   //     //user 가 firestore에 없으면 firestore에 등록. registerPage
    //   //     //updateUserToFirestore
    //   //     //submitUserToFirestore
    //   //     state = AuthState(
    //   //       appUser: AppUser(
    //   //         id: user.uid,
    //   //         name:
    //   //             userCredential.additionalUserInfo?.profile?['nickname'] ?? "",
    //   //         profile:
    //   //             userCredential.additionalUserInfo?.profile?['picture'] ?? "",
    //   //       ),
    //   //     );
    //   //     // submitUserToFirestore();
    //   //   }
    //   // }
    // } catch (e) {
    //   // state = AuthState(appUser: null);
    // }
  }

  ///회원정보 조회
  Future<void> fetchUser() async {
    final user = state.appUser;
    if (user != null) {
      try {
        final fetchUserUseCase = ref.read(fetchUserUseCaseProvider);
        final fetchUser = await fetchUserUseCase.fetchUser(user.id);
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  ///firebase 정보 업데이트
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
      state = AuthState(
        appUser: AppUser(
          id: state.appUser?.id ?? '',
          name: newNickname,
          profile: state.appUser?.profile ?? '',
        ),
        originInfo: state.originInfo,
      );
    }
  }
}

final loginPageViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(() {
  return AuthViewModel();
});
import 'package:bean_tripper/data/data_source/app_user_data_source.dart';
import 'package:bean_tripper/data/dto/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUserDataSourceImpl implements AppUserDataSource {
  final FirebaseFirestore _firestore;
  AppUserDataSourceImpl(this._firestore);

  @override
  Future<UserDto?> fetchUser(String id) async {
    final doc = await _firestore.collection('user').doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final newMap = {
        'id': id,
        ...data,
      };
      return UserDto.fromJson(newMap);
    }
    return null;
  }

  @override
  Future<void> saveUser(UserDto user) async {
    final map = user.toJson();
    map.remove('id');
    //문서 id가 user id가 되기때문에,
    await _firestore.collection('user').doc(user.id).set(map);

    /// user로 데이터 바꿔서 에러 뜸
  }

  @override
  Future<void> updateUser(UserDto user) async {
    try {
      final map = user.toJson();
      print(map);
      map.remove('id');
      print(map);
      // await _firestore.collection('user').doc(user.id).set(map);
      await _firestore.collection('user').doc(user.id).set(map);
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Future<UserDto?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      // await googleSignIn.signOut(); // 구글로그인 로그아웃 기능
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      //google 로그인
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // print(credential);
        // 구글에서 받은 accessToken과 idToken을 firebase가 이해할수 있는 걸로 변환
        // .credential이라는 메서드는 google_auth 패키지의 것
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;
        if (user != null) {
          return UserDto(
            id: user.uid,
            name: user.displayName ?? "",
            profile: user.photoURL ?? "",
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Future<UserDto?> signInWithKakao() {
    // TODO: implement signInWithKakao
    throw UnimplementedError();
  }
}

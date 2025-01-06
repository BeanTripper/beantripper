import 'package:bean_tripper/data/data_source/app_user_data_source.dart';
import 'package:bean_tripper/data/dto/user_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserDataSourceImpl implements AppUserDataSource {
  final FirebaseFirestore _firestore;
  AppUserDataSourceImpl(this._firestore);

  @override
  Future<UserDto?> fetchUser(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
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
    await _firestore.collection('users').doc(user.id).set(map);
  }

  @override
  Future<void> updateUser(UserDto user) async {
    final map = user.toJson();
    map.remove('id');
    await _firestore.collection('users').doc(user.id).set(map);
  }
}

import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/domain/repository/app_user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserRepositoryImpl implements AppUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> fetchUser(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return AppUser(id: data['id'], name: data['name']);
    }
    return null;
  }

  @override
  Future<void> saveUser(AppUser user) async {
    await _firestore.collection('users').doc('${user.id}').set(user.toJson());
  }

  @override
  Future<void> updateUSer(AppUser user) {
    // TODO: implement updateUSer
    throw UnimplementedError();
  }
}

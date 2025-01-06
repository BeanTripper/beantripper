import 'package:bean_tripper/domain/entity/app_user.dart';

abstract interface class AppUserRepository {
  Future<AppUser?> fetchUser(String uid) async {}

  Future<void> saveUser(AppUser user) async {}

  Future<void> updateUSer(AppUser user) async {}
}

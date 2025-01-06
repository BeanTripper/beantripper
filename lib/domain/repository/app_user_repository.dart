import 'package:bean_tripper/domain/entity/app_user.dart';

abstract interface class AppUserRepository {
  Future<AppUser?> fetchUser(String id);

  Future<void> saveUser(AppUser user);

  Future<void> updateUser(AppUser user);
}

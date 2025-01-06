import 'package:bean_tripper/data/dto/user_dto.dart';

abstract interface class AppUserDataSource {
  Future<UserDto?> fetchUser(String id);
  Future<void> saveUser(UserDto user);
  Future<void> updateUser(UserDto user);
}

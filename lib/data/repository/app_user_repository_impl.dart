import 'package:bean_tripper/data/data_source/app_user_data_source.dart';
import 'package:bean_tripper/data/dto/user_dto.dart';
import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/domain/repository/app_user_repository.dart';

class AppUserRepositoryImpl implements AppUserRepository {
  final AppUserDataSource _appUserDataSource;
  AppUserRepositoryImpl(this._appUserDataSource);

  @override
  Future<AppUser?> fetchUser(String id) async {
    final user = await _appUserDataSource.fetchUser(id);
    if (user != null) {
      return AppUser(
        id: user.id,
        name: user.name,
        profile: user.profile,
      );
    }
    return null;
  }

  @override
  Future<void> saveUser(AppUser user) async {
    await _appUserDataSource.saveUser(UserDto(
      id: user.id,
      name: user.name,
      profile: user.profile,
    ));
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await _appUserDataSource.updateUser(UserDto(
      id: user.id,
      name: user.name,
      profile: user.profile,
    ));
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    final user = await _appUserDataSource.signInWithGoogle();
    if (user != null) {
      return AppUser(
        id: user.id,
        name: user.name,
        profile: user.profile,
      );
    }
  }

  @override
  Future<AppUser?> signInWithKakao() {
    // TODO: implement signInWithKakao
    throw UnimplementedError();
  }
}

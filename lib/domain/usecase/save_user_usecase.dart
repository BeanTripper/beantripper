import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/domain/repository/app_user_repository.dart';

class SaveUserUseCase {
  SaveUserUseCase(this._appUserRepository);
  final AppUserRepository _appUserRepository;

  Future<void> saveUser(AppUser user) async {
    return await _appUserRepository.saveUser(user);
  }
}

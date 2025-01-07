import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/domain/repository/app_user_repository.dart';

class UpdateUserUseCase {
  UpdateUserUseCase(this._appUserRepository);
  final AppUserRepository _appUserRepository;

  Future<void> updateUser(AppUser user) async {
    return await _appUserRepository.updateUser(user);
  }
}

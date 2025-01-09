import 'package:bean_tripper/domain/entity/app_user.dart';
import 'package:bean_tripper/domain/repository/app_user_repository.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase(this._appUserRepository);
  final AppUserRepository _appUserRepository;

  Future<AppUser?> signInWithGoogle() async {
    final user = await _appUserRepository.signInWithGoogle();
    if (user != null) {
      return AppUser(
        id: user.id,
        name: user.name,
        profile: user.profile,
      );
    }
  }
}

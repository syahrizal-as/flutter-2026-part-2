import 'package:absensi_2026/app/module/repository/auth_repository.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class AuthLogoutUseCase extends AppUseCase<Future<void>, void> {
  final AuthRepository _authRepository;

  AuthLogoutUseCase(this._authRepository);

  @override
  Future<void> call({void param}) async {
    return await _authRepository.logout();
  }
}

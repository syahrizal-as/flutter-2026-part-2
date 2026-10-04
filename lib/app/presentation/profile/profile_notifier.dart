import 'dart:developer' as dev;
import 'package:absensi_2026/app/module/use_case/auth_logout.dart';
import 'package:absensi_2026/app/module/use_case/photo_get.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:app_settings/app_settings.dart';

import 'package:absensi_2026/core/service/biometric_service.dart';

class ProfileNotifier extends AppProvider {
  final AuthLogoutUseCase _authLogoutUseCase;
  final PhotoGetUseCase _photoGetUseCase;
  final BiometricService _biometricService;

  ProfileNotifier(
    this._authLogoutUseCase,
    this._photoGetUseCase,
    this._biometricService,
  ) {
    init();
  }

  String _name = '';
  String _email = '';
  String? _photoUrl;
  bool _isLoggedOut = false;
  bool _isBiometricEnabled = false;

  String get name => _name;
  String get email => _email;
  String? get photoUrl => _photoUrl;
  bool get isLoggedOut => _isLoggedOut;
  bool get isBiometricEnabled => _isBiometricEnabled;

  @override
  void init() async {
    _name = await SharedPreferencesHelper.getString(PREF_NAME) ?? '';
    _email = await SharedPreferencesHelper.getString(PREF_EMAIL) ?? '';
    _isBiometricEnabled = await _biometricService.isBiometricEnabled();
    notifyListeners();
    await _getPhoto();
  }

  Future<String> getBiometricStatus() async {
    final status = await _biometricService.checkAvailabilityStatus();
    dev.log('[BIOMETRIC] Status: $status');
    return status;
  }

  Future<bool> checkBiometricAvailability() async {
    return await _biometricService.isAvailable();
  }

  Future<void> setBiometricEnabled(bool value) async {
    if (value) {
      // 1. Cek status detail
      final status = await _biometricService.checkAvailabilityStatus();
      dev.log('[BIOMETRIC] setBiometricEnabled status: $status');

      if (status == 'HARDWARE_NOT_SUPPORTED') {
        snackbarMessage = 'Perangkat ini tidak mendukung biometrik ❌';
        notifyListeners();
        return;
      }

      if (status == 'NO_BIOMETRICS_ENROLLED') {
        snackbarMessage = 'Sidik jari belum terdaftar di perangkat ❌. Buka Pengaturan > Keamanan untuk mendaftarkannya.';
        notifyListeners();
        return;
      }

      // 2. Status READY — lakukan scan biometrik
      final authenticated = await _biometricService.authenticate();
      dev.log('[BIOMETRIC] authenticate result: $authenticated');
      if (authenticated) {
        await _biometricService.setBiometricStatus(true);
        _isBiometricEnabled = true;
        snackbarMessage = 'Login Biometrik diaktifkan ✅';
      } else {
        snackbarMessage = 'Scan sidik jari dibatalkan atau gagal ❌';
      }
    } else {
      await _biometricService.setBiometricStatus(false);
      _isBiometricEnabled = false;
      snackbarMessage = 'Login Biometrik dimatikan';
    }
    notifyListeners();
  }

  Future<void> openSecuritySettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.security);
  }

  Future<void> _getPhoto() async {
    final response = await _photoGetUseCase();
    if (response.success && !isDispose) {
      _photoUrl = response.data;
      notifyListeners();
    }
  }

  /// Refresh photo without showing loading screen (prevents blank black screen)
  Future<void> refreshPhotoSilently() async {
    if (isDispose) return;
    await _getPhoto();
  }

  Future<void> logout() async {
    showLoading();
    await _authLogoutUseCase();
    _isLoggedOut = true;
    hideLoading();
    notifyListeners();
  }
}

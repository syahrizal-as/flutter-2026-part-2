import 'package:absensi_2026/app/module/entity/auth.dart';
import 'package:absensi_2026/app/module/use_case/auth_login.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:absensi_2026/core/helper/device_helper.dart';

import 'package:absensi_2026/core/service/biometric_service.dart';

class LoginNotifier extends AppProvider {
  final AuthLoginUseCase _authLoginUseCase;
  final BiometricService _biometricService;

  LoginNotifier(this._authLoginUseCase, this._biometricService) {
    init();
  }

  bool _isLoged = false;
  bool _isShowPassword = false;
  bool _showManualLogin = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool get isLoged => _isLoged;
  bool get isShowPassword => _isShowPassword;
  bool get showManualLogin => _showManualLogin;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  set isShowPassword(bool param) {
    _isShowPassword = param;
    notifyListeners();
  }

  void toggleManualLogin() {
    _showManualLogin = !_showManualLogin;
    notifyListeners();
  }

  @override
  void init() {
    _checkAuth();
  }

  _checkAuth() async {
    showLoading();
    final String? auth = await SharedPreferencesHelper.getString(PREF_AUTH);
    if (auth?.isNotEmpty ?? false) _isLoged = true;
    hideLoading();
  }

  login() async {
    if (_emailController.text.isEmpty) {
      snackbarMessage = 'Email tidak boleh kosong';
      return;
    }
    if (_passwordController.text.isEmpty) {
      snackbarMessage = 'Password tidak boleh kosong';
      return;
    }

    showLoading();
    try {
      final deviceId = await DeviceHelper.getDeviceId();
      final param = AuthEntity(
          email: _emailController.text,
          password: _passwordController.text,
          deviceId: deviceId);
      final response = await _authLoginUseCase(param: param);
      if (response.success) {
        // Save for biometrics
        await _biometricService.saveCredentials(_emailController.text, _passwordController.text);
        _isLoged = true;
      } else {
        snackbarMessage = response.message;
      }
    } catch (e) {
      snackbarMessage = 'Terjadi kesalahan sistem: $e';
    } finally {
      hideLoading();
    }
  }

  Future<bool> canUseBiometric() async {
    return await _biometricService.isAvailable() && await _biometricService.isBiometricEnabled();
  }

  Future<void> loginWithBiometric() async {
    final credentials = await _biometricService.getCredentials();
    if (credentials == null) return;

    final authenticated = await _biometricService.authenticate();
    if (authenticated) {
      _emailController.text = credentials['email']!;
      _passwordController.text = credentials['password']!;
      await login();
    }
  }
}

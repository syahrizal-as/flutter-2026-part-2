import 'dart:developer' as dev;
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyEmail = 'biometric_email';
  static const String _keyPassword = 'biometric_password';
  static const String _keyEnabled = 'biometric_enabled';

  Future<String> checkAvailabilityStatus() async {
    final bool isSupported = await _auth.isDeviceSupported();
    if (!isSupported) return 'HARDWARE_NOT_SUPPORTED';

    final bool canCheck = await _auth.canCheckBiometrics;
    final List<BiometricType> available = await _auth.getAvailableBiometrics();
    
    if (!canCheck && available.isEmpty) return 'NO_BIOMETRICS_ENROLLED';
    if (available.isEmpty) return 'NO_BIOMETRICS_ENROLLED';
    
    return 'READY';
  }

  Future<bool> isAvailable() async {
    final status = await checkAvailabilityStatus();
    return status == 'READY';
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  Future<bool> authenticate() async {
    try {
      dev.log('[BIOMETRIC] Starting authenticate()...');
      final result = await _auth.authenticate(
        localizedReason: 'Silakan autentikasi untuk masuk ke aplikasi',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      dev.log('[BIOMETRIC] authenticate() raw result: $result');
      return result;
    } on LocalAuthException catch (e) {
      dev.log('[BIOMETRIC] LocalAuthException: ${e.code}');
      return false;
    } catch (e, st) {
      dev.log('[BIOMETRIC] authenticate() exception: $e', stackTrace: st);
      return false;
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
    await _storage.write(key: _keyEnabled, value: 'true');
  }

  Future<Map<String, String>?> getCredentials() async {
    final String? email = await _storage.read(key: _keyEmail);
    final String? password = await _storage.read(key: _keyPassword);
    final String? enabled = await _storage.read(key: _keyEnabled);

    if (enabled == 'true' && email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> clearCredentials() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyPassword);
    await _storage.write(key: _keyEnabled, value: 'false');
  }

  Future<void> setBiometricStatus(bool enabled) async {
    await _storage.write(key: _keyEnabled, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final String? enabled = await _storage.read(key: _keyEnabled);
    return enabled == 'true';
  }
}

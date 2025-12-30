import 'package:absensi_2026/app/module/entity/auth.dart';
import 'package:absensi_2026/core/network/data_state.dart';

abstract class AuthRepository {
  Future<DataState> login(AuthEntity param);
}

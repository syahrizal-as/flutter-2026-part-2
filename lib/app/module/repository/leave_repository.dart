import 'package:absensi_2026/app/module/entity/leave.dart';
import 'package:absensi_2026/core/network/data_state.dart';

abstract class LeaveRepository {
  Future<DataState> send(LeaveParamEntity param);
}

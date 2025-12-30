import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/core/network/data_state.dart';

abstract class ScheduleRepository {
  Future<DataState<ScheduleEntity?>> get();
  Future<DataState> banned();
}

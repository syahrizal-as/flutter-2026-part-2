import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/repository/attendance_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class AttendanceGetTodayUseCase
    extends AppUseCase<Future<DataState<AttendanceEntity?>>, void> {
  final AttendanceRepository _attendanceRepository;

  AttendanceGetTodayUseCase(this._attendanceRepository);

  @override
  Future<DataState<AttendanceEntity?>> call({void param}) {
    return _attendanceRepository.getToday();
  }
}

import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/holiday.dart';
import 'package:absensi_2026/app/module/repository/attendance_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class HolidayGetUseCase extends AppUseCase<
    Future<DataState<List<HolidayEntity>>>, AttendanceParamGetEntity> {
  final AttendanceRepository _attendanceRepository;

  HolidayGetUseCase(this._attendanceRepository);

  @override
  Future<DataState<List<HolidayEntity>>> call(
      {AttendanceParamGetEntity? param}) {
    return _attendanceRepository.getHolidays(param!);
  }
}

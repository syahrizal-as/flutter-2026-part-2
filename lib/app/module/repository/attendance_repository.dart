import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/holiday.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/entity/employee.dart';
import 'package:absensi_2026/core/network/data_state.dart';

abstract class AttendanceRepository {
  Future<DataState<AttendanceEntity?>> getToday();
  Future<DataState<List<AttendanceEntity>>> getThisMonth();
  Future<DataState> sendAttendance(AttendanceParamEntity param);
  Future<DataState<List<AttendanceEntity>>> getByMonthYear(
    AttendanceParamGetEntity param,
  );
  Future<DataState<List<HolidayEntity>>> getHolidays(
    AttendanceParamGetEntity param,
  );
  Future<DataState<List<OfficeEntity>>> getOffices();
  Future<DataState<List<EmployeeEntity>>> getEmployeesByOffice(int officeId);
  Future<DataState> sendAttendanceSecurity(Map<String, dynamic> body);
  Future<DataState> updateEmployeePhoto(Map<String, dynamic> body);
}

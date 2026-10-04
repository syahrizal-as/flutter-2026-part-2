import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/holiday.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/entity/employee.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/app/data/source/attendance_api_service.dart';
import 'package:absensi_2026/app/module/repository/attendance_repository.dart';
import 'package:absensi_2026/app/data/model/attendance.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceApiService _attendanceApiService;

  AttendanceRepositoryImpl(this._attendanceApiService);

  /// Sanitizes JSON by replacing null start_time/end_time with '-'
  Map<String, dynamic> _sanitizeAttendanceJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    // Fix 'today' object
    if (map['today'] != null) {
      final today = Map<String, dynamic>.from(map['today'] as Map);
      today['start_time'] ??= '-';
      today['end_time'] ??= '-';
      today['runtimeType'] = 'entity';
      map['today'] = today;
    }

    // Fix 'this_month' list
    if (map['this_month'] != null) {
      map['this_month'] = (map['this_month'] as List).map((e) {
        final item = Map<String, dynamic>.from(e as Map);
        item['start_time'] ??= '-';
        item['end_time'] ??= '-';
        item['runtimeType'] = 'entity';
        return item;
      }).toList();
    }

    return map;
  }

  /// Sanitizes a single attendance item JSON
  Map<String, dynamic> _sanitizeItem(Map<String, dynamic> json) {
    final item = Map<String, dynamic>.from(json);
    item['start_time'] ??= '-';
    item['end_time'] ??= '-';
    item['runtimeType'] = 'entity';
    return item;
  }

  @override
  Future<DataState<List<AttendanceEntity>>> getThisMonth() {
    return handleResponse(() => _attendanceApiService.getAttendanceToday(), (
      json,
    ) {
      final sanitized = _sanitizeAttendanceJson(json as Map<String, dynamic>);
      final response = AttendanceResponse.fromJson(sanitized);
      return response.thisMonth ?? [];
    });
  }

  @override
  Future<DataState<AttendanceEntity?>> getToday() {
    return handleResponse(() => _attendanceApiService.getAttendanceToday(), (
      json,
    ) {
      final sanitized = _sanitizeAttendanceJson(json as Map<String, dynamic>);
      final response = AttendanceResponse.fromJson(sanitized);
      return response.today;
    });
  }

  @override
  Future<DataState> sendAttendance(AttendanceParamEntity param) {
    return handleResponse(
      () => _attendanceApiService.sendAttendance({
        'latitude': param.latitude,
        'longitude': param.longitude,
      }),
      (json) => null,
    );
  }

  @override
  Future<DataState<List<AttendanceEntity>>> getByMonthYear(
    AttendanceParamGetEntity param,
  ) {
    return handleResponse(
      () => _attendanceApiService.getAttendanceByMonthYear(
        param.month,
        param.year,
      ),
      (json) {
        return (json as List).map((e) {
          final sanitized = _sanitizeItem(e as Map<String, dynamic>);
          return Attendance.fromJson(sanitized.cast<String, Object>())
              as AttendanceEntity;
        }).toList();
      },
    );
  }
  @override
  Future<DataState<List<HolidayEntity>>> getHolidays(
    AttendanceParamGetEntity param,
  ) {
    return handleResponse(
      () => _attendanceApiService.getHolidays(
        param.month,
        param.year,
      ),
      (json) {
        return (json as List).map((e) {
          return Holiday.fromJson((e as Map).cast<String, dynamic>()) as HolidayEntity;
        }).toList();
      },
    );
  }

  @override
  Future<DataState<List<OfficeEntity>>> getOffices() {
    return handleResponse(
      () => _attendanceApiService.getOffices(),
      (json) {
        return (json as List).map((e) {
          return Office.fromJson((e as Map).cast<String, Object>()) as OfficeEntity;
        }).toList();
      },
    );
  }

  @override
  Future<DataState<List<EmployeeEntity>>> getEmployeesByOffice(int officeId) {
    return handleResponse(
      () => _attendanceApiService.getEmployeesByOffice(officeId),
      (json) {
        return (json as List).map((e) {
          return EmployeeEntity.fromJson((e as Map).cast<String, dynamic>());
        }).toList();
      },
    );
  }

  @override
  Future<DataState> sendAttendanceSecurity(Map<String, dynamic> body) {
    return handleResponse(
      () => _attendanceApiService.sendAttendanceSecurity(body),
      (json) => null,
    );
  }

  @override
  Future<DataState> updateEmployeePhoto(Map<String, dynamic> body) {
    return handleResponse(
      () => _attendanceApiService.updateEmployeePhoto(body),
      (json) => null,
    );
  }
}

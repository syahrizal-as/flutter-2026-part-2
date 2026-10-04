import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee.freezed.dart';
part 'employee.g.dart';

@freezed
class EmployeeEntity with _$EmployeeEntity {
  const factory EmployeeEntity({
    required int id,
    required String name,
    String? email,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'attendance_status') String? attendanceStatus,
    @JsonKey(name: 'last_attendance_time') String? lastAttendanceTime,
  }) = _EmployeeEntity;

  factory EmployeeEntity.fromJson(Map<String, dynamic> json) =>
      _$EmployeeEntityFromJson(json);
}

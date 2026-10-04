// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EmployeeEntityImpl _$$EmployeeEntityImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeEntityImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String?,
      imageUrl: json['image_url'] as String?,
      attendanceStatus: json['attendance_status'] as String?,
      lastAttendanceTime: json['last_attendance_time'] as String?,
    );

Map<String, dynamic> _$$EmployeeEntityImplToJson(
  _$EmployeeEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'image_url': instance.imageUrl,
  'attendance_status': instance.attendanceStatus,
  'last_attendance_time': instance.lastAttendanceTime,
};

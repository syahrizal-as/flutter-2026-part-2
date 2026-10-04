// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceResponseModelImpl _$$AttendanceResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$AttendanceResponseModelImpl(
  today: json['today'] == null
      ? null
      : AttendanceEntity.fromJson(json['today'] as Map<String, dynamic>),
  thisMonth: (json['this_month'] as List<dynamic>?)
      ?.map((e) => AttendanceEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$AttendanceResponseModelImplToJson(
  _$AttendanceResponseModelImpl instance,
) => <String, dynamic>{
  'today': instance.today,
  'this_month': instance.thisMonth,
};

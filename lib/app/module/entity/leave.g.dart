// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveEntityImpl _$$LeaveEntityImplFromJson(Map<String, dynamic> json) =>
    _$LeaveEntityImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      reason: json['reason'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$LeaveEntityImplToJson(_$LeaveEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'reason': instance.reason,
      'status': instance.status,
      'note': instance.note,
      'runtimeType': instance.$type,
    };

_$LeaveParamEntityImpl _$$LeaveParamEntityImplFromJson(
  Map<String, dynamic> json,
) => _$LeaveParamEntityImpl(
  startDate: json['start_date'] as String,
  endDate: json['end_date'] as String,
  reason: json['reason'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$LeaveParamEntityImplToJson(
  _$LeaveParamEntityImpl instance,
) => <String, dynamic>{
  'start_date': instance.startDate,
  'end_date': instance.endDate,
  'reason': instance.reason,
  'runtimeType': instance.$type,
};

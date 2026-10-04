// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HolidayEntityImpl _$$HolidayEntityImplFromJson(Map<String, dynamic> json) =>
    _$HolidayEntityImpl(
      date: json['date'] as String,
      name: json['name'] as String,
      isNational: json['isNational'] as bool? ?? true,
    );

Map<String, dynamic> _$$HolidayEntityImplToJson(_$HolidayEntityImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'name': instance.name,
      'isNational': instance.isNational,
    };

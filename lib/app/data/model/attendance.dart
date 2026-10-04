import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.g.dart';
part 'attendance.freezed.dart';

@freezed
sealed class AttendanceResponse with _$AttendanceResponse {
  factory AttendanceResponse.model({
    AttendanceEntity? today,
    @JsonKey(name: 'this_month') required List<AttendanceEntity>? thisMonth,
  }) = AttendanceResponseModel;

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      _$AttendanceResponseFromJson(json);
}

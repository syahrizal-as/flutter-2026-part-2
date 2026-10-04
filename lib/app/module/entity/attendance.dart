import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.g.dart';
part 'attendance.freezed.dart';

@freezed
sealed class Attendance with _$Attendance {
  factory Attendance.entity(
      {@JsonKey(name: 'start_time') required String startTime,
      @JsonKey(name: 'end_time') required String endTime,
      String? date,
      String? note}) = AttendanceEntity;

  factory Attendance.paramEntity(
      {required double latitude,
      required double longitude}) = AttendanceParamEntity;

  factory Attendance.paramGetEntity({required int month, required int year}) =
      AttendanceParamGetEntity;

  factory Attendance.fromJson(Map<String, Object> json) =>
      _$AttendanceFromJson(json);
}

extension AttendanceStatusExtension on AttendanceEntity {
  bool get isLate {
    if (startTime == "-" || startTime.isEmpty) return false;
    // Note: this is a simplified version since scheduleStartTime isn't in the entity
    return false; 
  }

  String get statusLabel => isLate ? "Terlambat" : "Tepat Waktu";
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'holiday.g.dart';
part 'holiday.freezed.dart';

@freezed
sealed class Holiday with _$Holiday {
  const factory Holiday.entity({
    required String date,
    required String name,
    @Default(true) bool isNational,
  }) = HolidayEntity;

  factory Holiday.fromJson(Map<String, dynamic> json) => _$HolidayFromJson(json);
}

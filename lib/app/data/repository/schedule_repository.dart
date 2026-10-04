import 'package:absensi_2026/app/data/source/schedule_api_service.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/repository/schedule_repository.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/network/data_state.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final ScheduleApiService _scheduleApiService;

  ScheduleRepositoryImpl(this._scheduleApiService);

  Map<String, dynamic> _sanitizeSchedule(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    map['runtimeType'] = 'entity';

    // Cast is_wfa to int
    if (map['is_wfa'] is bool) {
      map['is_wfa'] = map['is_wfa'] ? 1 : 0;
    } else if (map['is_wfa'] is String) {
      map['is_wfa'] = int.tryParse(map['is_wfa']) ?? 0;
    } else if (map['is_wfa'] == null) {
      map['is_wfa'] = 0;
    }

    if (map['office'] != null) {
      final office = Map<String, dynamic>.from(map['office'] as Map);
      office['runtimeType'] = 'entity';
      // Cast num fields
      office['latitude'] = num.tryParse(office['latitude'].toString()) ?? 0;
      office['longitude'] = num.tryParse(office['longitude'].toString()) ?? 0;
      office['radius'] = num.tryParse(office['radius'].toString()) ?? 0;
      map['office'] = office;
    } else {
      print("WARNING: 'office' field is missing in schedule JSON");
    }

    if (map['shift'] != null) {
      final shift = Map<String, dynamic>.from(map['shift'] as Map);
      shift['runtimeType'] = 'entity';
      map['shift'] = shift;
    } else {
      print("WARNING: 'shift' field is missing in schedule JSON");
    }

    print("DEBUG SANITIZED SCHEDULE MAP: $map");
    return map;
  }

  @override
  Future<DataState<ScheduleEntity?>> get() {
    return handleResponse(() => _scheduleApiService.get(), (json) {
      if (json != null) {
        final sanitized = _sanitizeSchedule(json as Map<String, dynamic>);
        final data =
            Schedule.fromJson(sanitized.cast<String, Object>())
                as ScheduleEntity;
        SharedPreferencesHelper.setString(
          PREF_START_SHIFT,
          data.shift.startTime,
        );
        SharedPreferencesHelper.setString(PREF_END_SHIFT, data.shift.endTime);
        return data;
      } else {
        print("DEBUG: json received in ScheduleRepository is NULL");
        return null;
      }
    });
  }

  @override
  Future<DataState> banned() {
    return handleResponse(() => _scheduleApiService.banned(), (json) => null);
  }
}

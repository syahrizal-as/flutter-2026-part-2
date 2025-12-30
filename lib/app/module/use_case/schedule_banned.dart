import 'package:absensi_2026/app/module/repository/schedule_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class ScheduleBannedUseCase extends AppUseCase<Future<DataState>, void> {
  final ScheduleRepository _scheduleRepository;

  ScheduleBannedUseCase(this._scheduleRepository);

  @override
  Future<DataState> call({void param}) {
    return _scheduleRepository.banned();
  }
}

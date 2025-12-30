import 'package:absensi_2026/app/module/entity/leave.dart';
import 'package:absensi_2026/app/module/repository/leave_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class LeaveSendUseCase extends AppUseCase<Future<DataState>, LeaveParamEntity> {
  final LeaveRepository _leaveRepository;

  LeaveSendUseCase(this._leaveRepository);

  @override
  Future<DataState> call({LeaveParamEntity? param}) {
    return _leaveRepository.send(param!);
  }
}

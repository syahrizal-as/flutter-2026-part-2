import 'package:absensi_2026/app/module/entity/leave.dart';
import 'package:absensi_2026/app/module/repository/leave_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class LeaveGetUseCase extends AppUseCase<Future<DataState<List<LeaveEntity>>>, void> {
  final LeaveRepository _leaveRepository;

  LeaveGetUseCase(this._leaveRepository);

  @override
  Future<DataState<List<LeaveEntity>>> call({void param}) {
    return _leaveRepository.getHistory();
  }
}

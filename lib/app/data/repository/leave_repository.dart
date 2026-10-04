import 'package:absensi_2026/app/data/source/leave_api_service.dart';
import 'package:absensi_2026/app/module/entity/leave.dart';
import 'package:absensi_2026/app/module/repository/leave_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';

class LeaveRepositoryImpl extends LeaveRepository {
  final LeaveApiService _leaveApiService;

  LeaveRepositoryImpl(this._leaveApiService);

  @override
  Future<DataState> send(LeaveParamEntity param) {
    return handleResponse(
      () => _leaveApiService.send(body: param.toJson()),
      (json) => null,
    );
  }

  @override
  Future<DataState<List<LeaveEntity>>> getHistory() {
    return handleResponse(
      () => _leaveApiService.getLeaves(),
      (json) {
        return (json as List)
            .map((e) => LeaveEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }
}

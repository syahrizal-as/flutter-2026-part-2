import 'package:absensi_2026/app/module/entity/leave.dart';
import 'package:absensi_2026/app/module/use_case/leave_send.dart';
import 'package:absensi_2026/app/module/use_case/leave_get.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:flutter/material.dart';

class LeaveNotifier extends AppProvider {
  final LeaveSendUseCase _leaveSendUseCase;
  final LeaveGetUseCase _leaveGetUseCase;

  LeaveNotifier(this._leaveSendUseCase, this._leaveGetUseCase) {
    init();
  }

  bool _isSuccess = false;
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  List<LeaveEntity> _leaves = [];

  bool get isSuccess => _isSuccess;
  TextEditingController get startDateController => _startDateController;
  TextEditingController get endDateController => _endDateController;
  TextEditingController get reasonController => _reasonController;
  List<LeaveEntity> get leaves => _leaves;

  @override
  void init() {
    getHistory();
  }

  getHistory() async {
    showLoading();
    final response = await _leaveGetUseCase();
    if (response.success) {
      _leaves = response.data!;
      notifyListeners();
    }
    hideLoading();
  }

  send() async {
    if (_startDateController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _reasonController.text.isEmpty) {
      snackbarMessage = "Harap isi semua kolom";
      return;
    }

    showLoading();
    final param = LeaveParamEntity(
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      reason: _reasonController.text,
    );
    final response = await _leaveSendUseCase(param: param);
    if (response.success) {
      _isSuccess = true;
      _startDateController.clear();
      _endDateController.clear();
      _reasonController.clear();
      getHistory(); // Refresh history
    } else {
      snackbarMessage = response.message;
    }
    hideLoading();
  }
}

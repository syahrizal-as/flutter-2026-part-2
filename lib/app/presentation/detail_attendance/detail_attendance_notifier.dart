import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_by_month_year.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:flutter/material.dart';

class DetailAttendanceNotifier extends AppProvider {
  final AttendanceGetByMonthYearUseCase _attendanceGetByMonthYear;

  DetailAttendanceNotifier(this._attendanceGetByMonthYear) {
    init();
  }

  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final List<DropdownMenuEntry<int>> _monthListDropdown = const [
    DropdownMenuEntry<int>(value: 1, label: 'Januari'),
    DropdownMenuEntry<int>(value: 2, label: 'Februari'),
    DropdownMenuEntry<int>(value: 3, label: 'Maret'),
    DropdownMenuEntry<int>(value: 4, label: 'April'),
    DropdownMenuEntry<int>(value: 5, label: 'Mei'),
    DropdownMenuEntry<int>(value: 6, label: 'Juni'),
    DropdownMenuEntry<int>(value: 7, label: 'Juli'),
    DropdownMenuEntry<int>(value: 8, label: 'Agustus'),
    DropdownMenuEntry<int>(value: 9, label: 'September'),
    DropdownMenuEntry<int>(value: 10, label: 'Oktober'),
    DropdownMenuEntry<int>(value: 11, label: 'November'),
    DropdownMenuEntry<int>(value: 12, label: 'Desember'),
  ];

  final List<DropdownMenuEntry<int>> _yearListDropdown = [
    DropdownMenuEntry<int>(
      value: DateTime.now().year,
      label: DateTime.now().year.toString(),
    ),
    DropdownMenuEntry<int>(
      value: DateTime.now().year - 1,
      label: (DateTime.now().year - 1).toString(),
    ),
  ];

  List<AttendanceEntity> _listAttendance = [];

  TextEditingController get monthController => _monthController;
  TextEditingController get yearController => _yearController;

  List<DropdownMenuEntry<int>> get monthListDropdown => _monthListDropdown;
  List<DropdownMenuEntry<int>> get yearListDropdown => _yearListDropdown;

  List<AttendanceEntity> get listAttendance => _listAttendance;

  @override
  void init() {
    _monthController.text = _monthListDropdown[DateTime.now().month - 1].label;
    _yearController.text = DateTime.now().year.toString();
    search();
  }

  search() async {
    showLoading();
    try {
      final month = _monthListDropdown
          .firstWhere((element) => element.label == _monthController.text)
          .value;
      final year = int.parse(_yearController.text);

      final response = await _attendanceGetByMonthYear(
        param: AttendanceParamGetEntity(month: month, year: year),
      );
      if (response.success) {
        _listAttendance = response.data!;
      } else {
        errorMeesage = response.message;
      }
    } catch (e) {
      errorMeesage = "Terjadi kesalahan saat memproses data";
    }
    hideLoading();
  }
}

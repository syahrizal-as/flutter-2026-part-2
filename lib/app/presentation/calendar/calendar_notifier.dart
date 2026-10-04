import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/holiday.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_by_month_year.dart';
import 'package:absensi_2026/app/module/use_case/holiday_get.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';

class CalendarNotifier extends AppProvider {
  final AttendanceGetByMonthYearUseCase _attendanceGetByMonthYearUseCase;
  final HolidayGetUseCase _holidayGetUseCase;

  CalendarNotifier(this._attendanceGetByMonthYearUseCase, this._holidayGetUseCase) {
    init();
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<AttendanceEntity>> _events = {};
  List<AttendanceEntity> _selectedEvents = [];
  Map<DateTime, String> _holidays = {};

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;
  Map<DateTime, List<AttendanceEntity>> get events => _events;
  List<AttendanceEntity> get selectedEvents => _selectedEvents;
  Map<DateTime, String> get holidays => _holidays;

  @override
  void init() {
    _selectedDay = _focusedDay;
    _getAttendanceData(_focusedDay);
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    _selectedDay = selectedDay;
    _focusedDay = focusedDay;
    _selectedEvents = _getEventsForDay(selectedDay);
    notifyListeners();
  }

  void onPageChanged(DateTime focusedDay) {
    _focusedDay = focusedDay;
    // Update selected day to first of month to keep it in sync with view
    _selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
    _getAttendanceData(focusedDay);
  }

  List<AttendanceEntity> _getEventsForDay(DateTime day) {
    // Standardize the date to remove time for comparison
    final dateKey = DateTime(day.year, day.month, day.day);
    return _events[dateKey] ?? [];
  }

  Future<void> _getAttendanceData(DateTime date) async {
    showLoading();
    
    // Fetch Attendance and Holidays in parallel
    final results = await Future.wait([
      _attendanceGetByMonthYearUseCase(
        param: AttendanceParamGetEntity(month: date.month, year: date.year),
      ),
      _holidayGetUseCase(
        param: AttendanceParamGetEntity(month: date.month, year: date.year),
      ),
    ]);

    final attendanceResponse = results[0];
    final holidayResponse = results[1];

    if (attendanceResponse.success) {
      _events = {};
      for (var attendance in attendanceResponse.data as List<AttendanceEntity>) {
        if (attendance.date != null) {
          final datePart = DateTime.parse(attendance.date!);
          final dateKey = DateTime(datePart.year, datePart.month, datePart.day);
          
          if (_events[dateKey] == null) {
            _events[dateKey] = [];
          }
          _events[dateKey]!.add(attendance);
        }
      }
    }

    if (holidayResponse.success) {
      _holidays = {};
      for (var holiday in holidayResponse.data as List<HolidayEntity>) {
        final datePart = DateTime.parse(holiday.date);
        final dateKey = DateTime(datePart.year, datePart.month, datePart.day);
        _holidays[dateKey] = holiday.name;
      }
    }

    _selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);
    
    hideLoading();
  }
}

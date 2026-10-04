import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_this_month.dart';
import 'package:absensi_2026/app/module/use_case/attendance_get_today.dart';
import 'package:absensi_2026/app/module/use_case/photo_get.dart';
import 'package:absensi_2026/app/module/use_case/schedule_get.dart';
import 'package:absensi_2026/app/module/use_case/leave_get.dart';
import 'package:absensi_2026/app/module/entity/leave.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:absensi_2026/core/service/biometric_service.dart';
import 'package:absensi_2026/app/module/use_case/attendance_send.dart';
import 'package:geolocator/geolocator.dart';
import 'package:absensi_2026/core/helper/location_helper.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:async';


class HomeNotifier extends AppProvider {
  final AttendanceGetTodayUseCase _attendanceGetTodayUseCase;
  final AttendanceGetMonthUseCase _attendanceGetMonthUseCase;
  final ScheduleGetUseCase _scheduleGetUseCase;
  final PhotoGetUseCase _photoGetUseCase;
  final LeaveGetUseCase _leaveGetUseCase;
  final AttendanceSendUseCase _attendanceSendUseCase;
  final BiometricService _biometricService;

  HomeNotifier(
    this._attendanceGetTodayUseCase,
    this._attendanceGetMonthUseCase,
    this._scheduleGetUseCase,
    this._photoGetUseCase,
    this. _leaveGetUseCase,
    this._attendanceSendUseCase,
    this._biometricService,
  ) {
    init();
  }

  String _name = '';
  String? _photoUrl;
  ScheduleEntity? _schedule;
  AttendanceEntity? _attendanceToday;
  List<AttendanceEntity> _listAttendanceThisMonth = [];
  List<LeaveEntity> _listLeavesThisMonth = [];
  bool _isBiometricEnabled = false;
  bool _isOutsideArea = false;
  bool _isLocationChecking = false;
  bool _isPermissionDenied = false;
  bool _isServiceDisabled = false;
  StreamSubscription<Position>? _positionStream;

  String get name => _name;
  String? get photoUrl => _photoUrl;
  ScheduleEntity? get schedule => _schedule;
  AttendanceEntity? get attendanceToday => _attendanceToday;
  List<AttendanceEntity> get listAttendanceThisMonth => _listAttendanceThisMonth;
  bool get isBiometricEnabled => _isBiometricEnabled;
  bool get isOutsideArea => _isOutsideArea;
  bool get isLocationChecking => _isLocationChecking;
  bool get isPermissionDenied => _isPermissionDenied;
  bool get isServiceDisabled => _isServiceDisabled;

  /// Statistics for Dashboard
  int get totalHadir => _listAttendanceThisMonth.length;
  
  int get totalTerlambat {
    if (_schedule == null) return 0;
    int count = 0;
    for (var item in _listAttendanceThisMonth) {
      if (_isLate(item.startTime, _schedule?.shift.startTime)) {
        count++;
      }
    }
    return count;
  }

  int get totalIzin => _listLeavesThisMonth.where((e) => e.status.toLowerCase() == 'approved').length;

  bool _isLate(String startTime, String? scheduleStartTime) {
    if (startTime == "-" || scheduleStartTime == null) return false;
    try {
      final actual = DateTime.parse("2026-01-01 $startTime");
      final scheduled = DateTime.parse("2026-01-01 $scheduleStartTime");
      return actual.isAfter(scheduled);
    } catch (_) {
      return false;
    }
  }

  /// Attendance status helpers
  bool get hasCheckedIn =>
      _attendanceToday != null &&
      _attendanceToday!.startTime != "-" &&
      _attendanceToday!.startTime.isNotEmpty;

  bool get hasCheckedOut =>
      hasCheckedIn &&
      _attendanceToday!.endTime != "-" &&
      _attendanceToday!.endTime.isNotEmpty;

  /// True if user can still create attendance today
  bool get canCreateAttendance => !hasCheckedOut;

  String get attendanceButtonLabel {
    if (!hasCheckedIn) return "ABSEN MASUK";
    if (!hasCheckedOut) return "ABSEN PULANG";
    return "KEHADIRAN SELESAI";
  }

  /// Real-time Clock
  String _currentTime = "";
  String get currentTime => _currentTime;
  late Stream<String> _clockStream;

  _startClock() {
    _clockStream = Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    });
    
    _clockStream.listen((event) {
      _currentTime = event;
      notifyListeners();
    });
  }

  @override
  void init() {
    _currentTime = "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}";
    _startClock();
    _getData(); // _getData sekarang akan memanggil _checkLocationSilently di dalamnya
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  _getData() async {
    showLoading();
    _name = await SharedPreferencesHelper.getString(PREF_NAME) ?? '';

    final results = await Future.wait([
      _scheduleGetUseCase(),
      _attendanceGetTodayUseCase(),
      _attendanceGetMonthUseCase(),
      _photoGetUseCase(),
      _leaveGetUseCase(),
    ]);

    if (results[0].success) {
      _schedule = results[0].data as ScheduleEntity?;
    } else {
      print("DEBUG SCHEDULE ERROR: ${results[0].message}");
    }
    if (results[1].success) _attendanceToday = results[1].data as AttendanceEntity?;
    if (results[2].success) {
      _listAttendanceThisMonth = results[2].data as List<AttendanceEntity>;
    }
    if (results[3].success) _photoUrl = results[3].data as String?;
    if (results[4].success) {
      _listLeavesThisMonth = results[4].data as List<LeaveEntity>;
    }

    _isBiometricEnabled = await _biometricService.isBiometricEnabled();

    // Mulai streaming lokasi
    _startLocationStream();

    hideLoading();
    notifyListeners();
  }

  Future<bool> checkLocationBeforeAttendance() async {
    // 1. Cek Izin Lokasi
    bool isGranted = await LocationHelper.isGrantedLocationPermission();
    if (!isGranted) {
      snackbarMessage = "Izin lokasi diperlukan ❌";
      notifyListeners();
      return false;
    }

    // 2. Cek GPS Aktif
    bool isServiceEnabled = await LocationHelper.isEnabledLocationService();
    if (!isServiceEnabled) {
      snackbarMessage = "GPS mati ❌";
      notifyListeners();
      return false;
    }

    // Karena kita pakai Stream, status _isOutsideArea sudah yang terbaru
    if (_isOutsideArea) {
      snackbarMessage = "Anda masih di luar area kantor ❌";
      notifyListeners();
    }
    
    return !_isOutsideArea;
  }

  Future<void> _startLocationStream() async {
    _isLocationChecking = true;
    _isPermissionDenied = false;
    _isServiceDisabled = false;
    notifyListeners();

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      _isPermissionDenied = (permission == LocationPermission.denied || 
                            permission == LocationPermission.deniedForever);
      _isServiceDisabled = !serviceEnabled;

      if (!_isPermissionDenied && !_isServiceDisabled) {
        // Batalkan stream lama jika ada
        await _positionStream?.cancel();

        // Mulai listen stream baru
        _positionStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, // Update setiap bergerak 5 meter
          ),
        ).listen((Position position) {
          if (_schedule != null && _schedule!.isWfa != 1) {
            final double distance = Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              _schedule!.office.latitude.toDouble(),
              _schedule!.office.longitude.toDouble(),
            );
            _isOutsideArea = distance > _schedule!.office.radius.toDouble();
          }
          _isLocationChecking = false;
          _isPermissionDenied = false;
          _isServiceDisabled = false;
          notifyListeners();
        }, onError: (e) {
          _isLocationChecking = false;
          notifyListeners();
        });
      } else {
        _isLocationChecking = false;
        notifyListeners();
      }
    } catch (_) {
      _isLocationChecking = false;
      notifyListeners();
    }
  }

  Future<void> _checkLocationSilently() async {
    // Digantikan oleh _startLocationStream
  }

  Future<void> processBiometricAttendance() async {
    // 1. Cek Izin Lokasi & GPS
    bool isGranted = await LocationHelper.isGrantedLocationPermission();
    if (!isGranted) {
      snackbarMessage = "Izin lokasi diperlukan untuk absensi ❌";
      notifyListeners();
      return;
    }

    bool isServiceEnabled = await LocationHelper.isEnabledLocationService();
    if (!isServiceEnabled) {
      snackbarMessage = "Silakan aktifkan GPS Anda ❌";
      notifyListeners();
      return;
    }

    // 2. Cek Biometrik
    final authenticated = await _biometricService.authenticate();
    if (!authenticated) {
      snackbarMessage = "Autentikasi Biometrik Gagal/Dibatalkan ❌";
      notifyListeners();
      return;
    }

    showLoading();
    try {
      // 3. Ambil Lokasi Terkini
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      if (position.isMocked) {
        hideLoading();
        snackbarMessage = "Fake GPS terdeteksi! ❌";
        notifyListeners();
        return;
      }

      // 3. Validasi Geofencing (Jika bukan WFA)
      if (_schedule != null && _schedule!.isWfa != 1) {
        final double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _schedule!.office.latitude.toDouble(),
          _schedule!.office.longitude.toDouble(),
        );

        if (distance > _schedule!.office.radius.toDouble()) {
          hideLoading();
          snackbarMessage = "Anda berada di luar radius kantor (${distance.toInt()}m) ❌";
          notifyListeners();
          return;
        }
      }

      // 4. Kirim Absen
      final response = await _attendanceSendUseCase(
        param: AttendanceParamEntity(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
      
      hideLoading();
      if (response.success) {
        snackbarMessage = "Absensi berhasil via Sidik Jari ✅";
        _getData(); // Refresh dashboard
      } else {
        snackbarMessage = "Gagal absen: ${response.message} ❌";
      }
    } catch (e) {
      hideLoading();
      snackbarMessage = "Gagal mengambil lokasi: $e ❌";
    }
    notifyListeners();
  }
}

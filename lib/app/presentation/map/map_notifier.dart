import 'dart:async';
import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/use_case/attendance_send.dart';
import 'package:absensi_2026/app/module/use_case/schedule_banned.dart';
import 'package:absensi_2026/app/module/use_case/schedule_get.dart';
import 'package:absensi_2026/core/helper/date_time_helper.dart';
import 'package:absensi_2026/core/helper/location_helper.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/constant/constant.dart';

class MapNotifier extends AppProvider {
  final ScheduleGetUseCase _scheduleGetUseCase;
  final AttendanceSendUseCase _attendanceSendUseCase;
  final ScheduleBannedUseCase _scheduleBannedUseCase;

  MapNotifier(
    this._scheduleGetUseCase,
    this._attendanceSendUseCase,
    this._scheduleBannedUseCase,
  ) {
    init();
  }

  bool _isSuccess = false;
  bool _isEnableSubmitButton = false;
  MapController _mapController = MapController(
    initPosition: GeoPoint(latitude: -6.175392, longitude: 106.827153),
  );
  ScheduleEntity? _schedule;
  CircleOSM? _circle;
  double _distanceFromOffice = 0;
  bool _isGrantedLocation = false;
  bool _isEnabledLocation = false;
  StreamSubscription<Position>? _streamCurrentLocation;
  GeoPoint? _currentLocation;
  GeoPoint? _officeLocation;
  bool _isMapReady = false;
  String _name = '';

  bool get isSuccess => _isSuccess;
  bool get isEnableSubmitButton => _isEnableSubmitButton;
  MapController get mapController => _mapController;
  ScheduleEntity? get schedule => _schedule;
  double get distanceFromOffice => _distanceFromOffice;
  bool get isGrantedLocation => _isGrantedLocation;
  bool get isEnabledLocation => _isEnabledLocation;
  GeoPoint? get currentLocation => _currentLocation;
  GeoPoint? get officeLocation => _officeLocation;
  String get name => _name;

  @override
  void init() async {
    _name = await SharedPreferencesHelper.getString(PREF_NAME) ?? '';
    await _getEnableAndPermission();
    await _getSchedule();
    if (errorMessage.isEmpty && _schedule != null) _checkShift();
  }

  _getEnableAndPermission() async {
    showLoading();
    _isGrantedLocation = await LocationHelper.isGrantedLocationPermission();
    if (_isGrantedLocation) {
      _isEnabledLocation = await LocationHelper.isEnabledLocationService();
      if (!_isEnabledLocation) {
        errorMeesage = 'Harap mengaktifkan GPS';
      }
    } else {
      errorMeesage = 'Harap menyetujui permission';
    }
    hideLoading();
  }

  _getSchedule() async {
    showLoading();
    final response = await _scheduleGetUseCase();
    if (response.success) {
      _schedule = response.data;
      if (_schedule != null) {
        _officeLocation = GeoPoint(
          latitude: _schedule!.office.latitude.toDouble(),
          longitude: _schedule!.office.longitude.toDouble(),
        );
        _circle = CircleOSM(
          key: 'Center-Point',
          centerPoint: _officeLocation!,
          radius: _schedule!.office.radius.toDouble(),
          color: Colors.indigo.withOpacity(0.3),
          strokeWidth: 2,
          borderColor: Colors.indigo,
        );

        // If map is already ready, draw it now
        if (_isMapReady) {
          _drawOfficeAndRadius();
        }
      }
    } else {
      errorMeesage = response.message;
    }
    _validationSubmitButton();
    hideLoading();
  }

  _checkShift() {
    final now = DateTime.now();
    final startTimeShift = _schedule!.shift.startTime.split(':');
    final dateTimeShift = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startTimeShift[0]),
      int.parse(startTimeShift[1]),
      int.parse(startTimeShift[2]),
    );
    if (DateTimeHelper.getDifference(a: now, b: dateTimeShift).inMinutes > 60) {
      errorMeesage =
          'Kehadiran dapat dibuat paling cepat 60 menit sebelum shift dimulai';
    }
  }

  checkLocationPermission() async {
    _isGrantedLocation = await LocationHelper.isGrantedLocationPermission();
    if (_isGrantedLocation) {
      errorMeesage = '';
      init();
    }
  }

  checkLocationService() async {
    _isEnabledLocation = await LocationHelper.isEnabledLocationService();
    if (_isEnabledLocation) {
      errorMeesage = '';
      init();
    }
  }

  mapIsReady() async {
    _isMapReady = true;
    _openStreamCurrentLocation();
    // Tunggu sebentar agar engine OSM benar-benar siap merender
    Future.delayed(const Duration(seconds: 1), () {
      _drawOfficeAndRadius();
    });
  }

  _drawOfficeAndRadius() async {
    if (_officeLocation != null && _isMapReady) {
      try {
        // Hapus marker lama jika ada untuk menghindari duplikasi
        await mapController.removeMarker(_officeLocation!);
        
        // Add Office Marker
        await mapController.addMarker(
          _officeLocation!,
          markerIcon: const MarkerIcon(
            icon: Icon(Icons.business_rounded, color: Colors.indigo, size: 48),
          ),
        );

        // Draw Radius Circle
        if (_circle != null) {
          await mapController.drawCircle(_circle!);
        }
        
        // Zoom ke arah kantor agar terlihat
        await mapController.zoomToBoundingBox(
          BoundingBox.fromGeoPoints([_officeLocation!]),
        );
      } catch (e) {
        debugPrint("Error drawing on map: $e");
      }
    }
  }

  recenterMap() async {
    if (_currentLocation != null) {
      await mapController.moveTo(_currentLocation!, animate: true);
    }
  }

  _openStreamCurrentLocation() async {
    // Cek ulang sebelum buka stream
    if (!_isGrantedLocation || !_isEnabledLocation) return;

    // Gunakan built-in tracking dari OSM agar lebih smooth
    try {
      await mapController.enableTracking();
    } catch (e) {
      print("Error enable tracking: $e");
    }

    // Ambil lokasi awal segera
    try {
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _currentLocation = GeoPoint(
        latitude: initialPosition.latitude,
        longitude: initialPosition.longitude,
      );
      _validationSubmitButton();
      notifyListeners();
    } catch (e) {
      debugPrint("Error getting initial position: $e");
    }

    _streamCurrentLocation = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((position) async {
      if (position.isMocked) {
        _closeStreamCurrentLocation();
        _sendBanned();
      } else {
        if (!isDispose) {
          _currentLocation = GeoPoint(
            latitude: position.latitude,
            longitude: position.longitude,
          );
          if (!isLoading) {
            _validationSubmitButton();
            notifyListeners();
          }
        } else {
          _closeStreamCurrentLocation();
        }
      }
    });
  }

  _closeStreamCurrentLocation() {
    _streamCurrentLocation?.cancel();
  }

  _validationSubmitButton() {
    if (_schedule == null) return;

    // Update distance (Remaining distance to enter radius)
    if (_officeLocation != null && _currentLocation != null) {
      double totalDistance = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _officeLocation!.latitude,
        _officeLocation!.longitude,
      );
      
      double radius = _schedule!.office.radius.toDouble();
      
      // Hitung sisa jarak (jika < 0 berarti sudah di dalam, set ke 0)
      double remaining = totalDistance - radius;
      _distanceFromOffice = remaining > 0 ? remaining : 0;

      // Debugging Logs
      print("=== DEBUG LOKASI ===");
      print("User: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}");
      print("Office: ${_officeLocation!.latitude}, ${_officeLocation!.longitude}");
      print("Radius: $radius m");
      print("Jarak Total: ${totalDistance.toStringAsFixed(2)} m");
      print("Jarak Sisa: ${_distanceFromOffice.toStringAsFixed(2)} m");
      print("====================");
      
      // Status tombol aktif jika sudah di dalam radius (jarak sisa = 0)
      _isEnableSubmitButton = _distanceFromOffice <= 0;
      
      if (_schedule!.isWfa == 1) {
        _isEnableSubmitButton = true;
      }
      
      notifyListeners();
    }
  }

  send() async {
    if (_currentLocation == null) return;
    showLoading();
    final response = await _attendanceSendUseCase(
      param: AttendanceParamEntity(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
      ),
    );
    if (response.success) {
      _isSuccess = true;
    } else {
      snackbarMessage = response.message;
    }
    hideLoading();
  }

  _sendBanned() async {
    showLoading();
    final response = await _scheduleBannedUseCase();
    if (response.success) {
      _getSchedule();
    } else {
      errorMeesage = response.message;
    }
    hideLoading();
  }

  @override
  void dispose() {
    _closeStreamCurrentLocation();
    super.dispose();
  }
}

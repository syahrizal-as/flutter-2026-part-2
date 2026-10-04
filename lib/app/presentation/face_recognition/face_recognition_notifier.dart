import 'dart:typed_data';
import 'package:absensi_2026/app/module/entity/attendance.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/use_case/attendance_send.dart';
import 'package:absensi_2026/app/module/use_case/photo_get_bytes.dart';
import 'package:absensi_2026/app/module/use_case/schedule_get.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:absensi_2026/app/module/use_case/schedule_banned.dart';
import 'package:absensi_2026/core/helper/location_helper.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/constant/constant.dart';

class FaceRecognitionNotifier extends AppProvider {
  final PhotoGetBytesUseCase _photoGetBytesUseCase;
  final ScheduleGetUseCase _scheduleGetUseCase;
  final AttendanceSendUseCase _attendanceSendUseCase;
  final ScheduleBannedUseCase _scheduleBannedUseCase;

  FaceRecognitionNotifier(
    this._photoGetBytesUseCase,
    this._scheduleGetUseCase,
    this._attendanceSendUseCase,
    this._scheduleBannedUseCase,
  ) {
    init();
  }

  final FaceSDK _faceSDK = FaceSDK.instance;
  MatchFacesImage? mfImage1;
  MatchFacesImage? mfImage2;
  Image? _currentImage;
  double _percentMatch = 0.0;
  bool _isMissingPhoto = false;
  bool _isSuccess = false;
  ScheduleEntity? _schedule;

  // Map related variables
  bool _isEnableSubmitButton = false;
  MapController _mapController = MapController(
    initPosition: GeoPoint(latitude: -6.175392, longitude: 106.827153),
  );
  CircleOSM? _circle;
  double _distanceFromOffice = 0;
  bool _isMapReady = false;
  bool _isGrantedLocation = false;
  bool _isEnabledLocation = false;
  StreamSubscription<Position>? _streamCurrentLocation;
  GeoPoint? _currentLocation;
  GeoPoint? _officeLocation;
  String _name = '';

  Image? get currentImage => _currentImage;
  double get percentMatch => _percentMatch;
  bool get isMissingPhoto => _isMissingPhoto;
  set isMissingPhoto(bool value) => _isMissingPhoto = value;
  Uint8List? get refPhotoBytes => mfImage1?.image;
  bool get isSuccess => _isSuccess;
  bool get isWfa => _schedule?.isWfa == 1;

  // Map getters
  bool get isEnableSubmitButton => _isEnableSubmitButton;
  MapController get mapController => _mapController;
  double get distanceFromOffice => _distanceFromOffice;
  bool get isGrantedLocation => _isGrantedLocation;
  bool get isEnabledLocation => _isEnabledLocation;
  GeoPoint? get currentLocation => _currentLocation;
  GeoPoint? get officeLocation => _officeLocation;
  String get name => _name;

  @override
  void init() async {
    errorMeesage = '';
    _isSuccess = false;
    _isEnableSubmitButton = false;
    _name = await SharedPreferencesHelper.getString(PREF_NAME) ?? '';

    // Only initialize SDK if not already initialized
    bool isInitialized = await _faceSDK.isInitialized();
    if (!isInitialized) {
      await _faceSDK.initialize(config: null);
    }

    await _getEnableAndPermission();
    await Future.wait<void>([
      _getBasePhoto(),
      _getSchedule(),
    ]);
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

        if (_isMapReady) {
          _drawOfficeAndRadius();
        }
      }
    }
  }

  _getBasePhoto() async {
    showLoading();
    final response = await _photoGetBytesUseCase();
    if (response.success && response.data != null) {
      _setImage(response.data!, ImageType.LIVE, 1);
    } else {
      _isMissingPhoto = true;
      errorMeesage = response.message ?? 'Gagal mengambil foto referensi';
    }
    _validationSubmitButton();
    hideLoading();
  }

  _setImage(Uint8List bytes, ImageType type, int flag) {
    final mdImage = MatchFacesImage(bytes, type);
    if (flag == 1) {
      mfImage1 = mdImage;
    } else {
      mfImage2 = mdImage;
      _currentImage = Image.memory(bytes);
    }
  }

  getCurrentPhoto() async {
    try {
      _currentImage = null;
      final response = await _faceSDK.startFaceCapture();
      final image = response.image;
      if (image != null) _setImage(image.image, image.imageType, 2);
      if (_currentImage != null) {
        _matchFaces();
      } else {
        notifyListeners();
      }
    } catch (e) {
      errorMeesage = "Gagal membuka kamera: $e";
    }
  }

  _matchFaces() async {
    showLoading();
    _percentMatch = 0.0;
    if (mfImage1 == null || mfImage2 == null) {
      hideLoading();
      return;
    }
    final request = MatchFacesRequest([mfImage1!, mfImage2!]);
    final response = await _faceSDK.matchFaces(request);
    final split = await _faceSDK.splitComparedFaces(response.results, 0.75);
    final match = split.matchedFaces;
    if (match.isNotEmpty) {
      _percentMatch = match[0].similarity * 100;
    } else {
      _percentMatch = -1;
    }
    _validationSubmitButton();
    hideLoading();
  }

  // --- Map Methods ---

  mapIsReady() async {
    _isMapReady = true;
    _openStreamCurrentLocation();
    _drawOfficeAndRadius();
  }

  _drawOfficeAndRadius() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_officeLocation != null && _isMapReady) {
      await mapController.addMarker(
        _officeLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(Icons.business_rounded, color: Colors.indigo, size: 48),
        ),
      );

      if (_circle != null) {
        await mapController.drawCircle(_circle!);
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

    try {
      await _mapController.enableTracking();
    } catch (e) {
      debugPrint("Error enable tracking: $e");
    }

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

    if (_officeLocation != null && _currentLocation != null) {
      _distanceFromOffice = Geolocator.distanceBetween(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
        _officeLocation!.latitude,
        _officeLocation!.longitude,
      );
    }

    final bool isFaceMatched = _percentMatch >= 70;

    if (_schedule!.isWfa == 1) {
      _isEnableSubmitButton = isFaceMatched;
    } else {
      if (_circle == null || _currentLocation == null) {
        _isEnableSubmitButton = false;
      } else {
        final inCircle = LocationHelper.isLocationInCircle(
          _circle!,
          _currentLocation!,
        );
        _isEnableSubmitButton = isFaceMatched && inCircle;
      }
    }
    notifyListeners();
  }

  submitAttendance() async {
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

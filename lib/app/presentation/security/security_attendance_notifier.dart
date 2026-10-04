import 'dart:convert';
import 'dart:typed_data';
import 'package:absensi_2026/app/module/entity/employee.dart';
import 'package:absensi_2026/app/module/entity/schedule.dart';
import 'package:absensi_2026/app/module/repository/attendance_repository.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/helper/shared_preferences_helper.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SecurityAttendanceNotifier extends AppProvider {
  final AttendanceRepository _attendanceRepository;
  final FaceSDK _faceSDK = FaceSDK.instance;
  final FlutterTts _flutterTts = FlutterTts();
  
  SecurityAttendanceNotifier(this._attendanceRepository) {
    init();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  MatchFacesImage? mfImage1;
  MatchFacesImage? mfImage2;
  Image? _currentImage;
  double _percentMatch = 0.0;
  bool _isSuccess = false;
  bool _isInArea = false;
  double _distance = 0.0;
  bool _isRegisterMode = false;
  
  Image? get currentImage => _currentImage;
  double get percentMatch => _percentMatch;
  bool get isSuccess => _isSuccess;
  bool get isInArea => _isInArea;
  double get distance => _distance;
  bool get isRegisterMode => _isRegisterMode;
  Uint8List? get refPhotoBytes => mfImage1?.image;

  List<Map<String, dynamic>> _recentLogs = [];
  List<Map<String, dynamic>> get recentLogs => _recentLogs;

  Map<String, dynamic>? _lastSuccessData;
  Map<String, dynamic>? get lastSuccessData => _lastSuccessData;

  OfficeEntity? _selectedBranch;
  OfficeEntity? get selectedBranch => _selectedBranch;

  List<OfficeEntity> _offices = [];
  List<OfficeEntity> get offices => _offices;

  List<EmployeeEntity> _allEmployees = [];
  List<EmployeeEntity> _filteredEmployees = [];
  List<EmployeeEntity> get filteredEmployees => _filteredEmployees;

  EmployeeEntity? _selectedEmployee;
  EmployeeEntity? get selectedEmployee => _selectedEmployee;

  String get attendanceType {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "ABSEN MASUK";
    } else {
      return "ABSEN PULANG";
    }
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void init() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    _offices = [];
    errorMeesage = null;
    showLoading();

    // 1. Check Location Permission
    bool isGranted = await Geolocator.checkPermission() == LocationPermission.always || 
                     await Geolocator.checkPermission() == LocationPermission.whileInUse;
    if (!isGranted) {
      await Geolocator.requestPermission();
    }

    // 2. Initialize FaceSDK
    bool isInitialized = await _faceSDK.isInitialized();
    if (!isInitialized) {
      await _faceSDK.initialize(config: null);
    }
    
    // 3. Load offices
    final officeState = await _attendanceRepository.getOffices();
    if (officeState is SuccessState<List<OfficeEntity>>) {
      _offices = officeState.data ?? [];
      
      // 4. Auto-lock to saved branch
      final savedBranchName = await SharedPreferencesHelper.getString(PREF_BRANCH);
      if (savedBranchName != null && _offices.isNotEmpty) {
        try {
          _selectedBranch = _offices.firstWhere((o) => o.name == savedBranchName);
          // Load employees immediately for the locked branch
          final employeeState = await _attendanceRepository.getEmployeesByOffice(_selectedBranch!.id);
          if (employeeState is SuccessState<List<EmployeeEntity>>) {
            _allEmployees = employeeState.data ?? [];
            _filteredEmployees = _allEmployees;
          }
        } catch (_) {}
      }

      if (_offices.isEmpty && _selectedBranch == null) {
        errorMeesage = "Belum ada data Cabang di sistem.";
      }
    } else {
      errorMeesage = officeState.message;
    }
    
    hideLoading();
  }

  Future<void> _loadEmployees() async {
    if (_selectedBranch == null) return;
    
    final employeeState = await _attendanceRepository.getEmployeesByOffice(_selectedBranch!.id);
    if (employeeState is SuccessState<List<EmployeeEntity>>) {
      _allEmployees = employeeState.data ?? [];
      _filteredEmployees = _allEmployees;
      notifyListeners();
    }
  }

  void selectBranch(OfficeEntity branch) async {
    showLoading();
    _selectedBranch = branch;
    await SharedPreferencesHelper.setString(PREF_BRANCH, branch.name);
    
    await _loadEmployees();
    
    hideLoading();
    notifyListeners();
  }

  void resetBranch() {
    _selectedBranch = null;
    SharedPreferencesHelper.remove(PREF_BRANCH);
    notifyListeners();
  }

  void searchEmployee(String query) {
    if (query.isEmpty) {
      _filteredEmployees = _allEmployees;
    } else {
      _filteredEmployees = _allEmployees
          .where((e) => e.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void selectEmployee(EmployeeEntity employee) async {
    // PROTEKSI 1 JAM di FE
    if (employee.attendanceStatus == 'Sudah Masuk' && employee.lastAttendanceTime != null) {
      try {
        final now = DateTime.now();
        final timeParts = employee.lastAttendanceTime!.split(':');
        final lastTime = DateTime(now.year, now.month, now.day, int.parse(timeParts[0]), int.parse(timeParts[1]));
        
        final diffInMinutes = now.difference(lastTime).inMinutes;
        if (diffInMinutes < 60) {
          snackbarMessage = "Karyawan baru saja absen pada jam ${employee.lastAttendanceTime}. Silakan tunggu ${60 - diffInMinutes} menit lagi untuk absen pulang.";
          return;
        }
      } catch (e) {
        // Jika format waktu salah, abaikan proteksi FE dan biarkan BE yang handle
      }
    }

    _selectedEmployee = employee;
    // Jika tidak sedang dalam mode daftar dari menu setting, baru kita set ke false
    // Tapi biasanya pendaftaran selalu dimulai dari pilihan karyawan.
    // Kita biarkan saja logic pendaftaran dikontrol oleh setRegisterMode.
    _percentMatch = 0.0;
    _currentImage = null;
    mfImage1 = null;
    mfImage2 = null;
    notifyListeners();

    if (employee.imageUrl != null) {
      // Use the correct internal method name
      await _fetchReferencePhoto(employee.imageUrl!.startsWith('http') 
        ? employee.imageUrl! 
        : "$BASE_URL/storage/${employee.imageUrl}");
    }

    _startLocationTracking();
  }

  void setRegisterMode(bool value) {
    _isRegisterMode = value;
    notifyListeners();
  }

  StreamSubscription<Position>? _locationSubscription;

  void _startLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 1),
    ).listen((position) {
      if (_selectedBranch != null) {
        _distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          _selectedBranch!.latitude.toDouble(),
          _selectedBranch!.longitude.toDouble(),
        );
        _isInArea = _distance <= _selectedBranch!.radius;
        notifyListeners();
      }
    });
  }

  void _stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<void> _fetchReferencePhoto(String url) async {
    showLoading();
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        mfImage1 = MatchFacesImage(bytes, ImageType.LIVE);
      }
    } catch (e) {
      debugPrint("Error fetching reference photo: $e");
    }
    hideLoading();
    notifyListeners();
  }

  void unselectEmployee() {
    _stopLocationTracking();
    _selectedEmployee = null;
    _percentMatch = 0.0;
    _currentImage = null;
    mfImage1 = null;
    mfImage2 = null;
    notifyListeners();
  }

  Future<void> startFaceCapture() async {
    try {
      _currentImage = null;
      final response = await _faceSDK.startFaceCapture();
      final image = response.image;
      if (image != null) {
        final bytes = image.image;
        mfImage2 = MatchFacesImage(bytes, image.imageType);
        _currentImage = Image.memory(bytes);
        notifyListeners();
        
        if (_isRegisterMode) {
          // Hanya ambil foto, tidak perlu matching
        } else {
          await _matchFaces();
        }
      }
    } catch (e) {
      errorMeesage = "Gagal membuka kamera: $e";
    }
  }

  Future<void> _matchFaces() async {
    if (mfImage1 == null || mfImage2 == null) return;

    showLoading();
    final request = MatchFacesRequest([mfImage1!, mfImage2!]);
    final response = await _faceSDK.matchFaces(request);
    final split = await _faceSDK.splitComparedFaces(response.results, 0.75);
    final match = split.matchedFaces;
    
    if (match.isNotEmpty) {
      _percentMatch = match[0].similarity * 100;
    } else {
      _percentMatch = -1;
    }

    hideLoading();
    notifyListeners();

    // Auto submit if matched
    if (_percentMatch >= 70) {
      await autoSubmitAttendance();
    }
  }

  Future<void> autoSubmitAttendance() async {
    if (_selectedEmployee == null || _selectedBranch == null) return;
    
    showLoading();

    try {
      // 1. Get Current Position
      final position = await Geolocator.getCurrentPosition();
      
      // 2. Calculate Distance to Branch
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _selectedBranch!.latitude.toDouble(),
        _selectedBranch!.longitude.toDouble(),
      );

      // 3. Validate Radius
      if (distance > _selectedBranch!.radius) {
        hideLoading();
        errorMeesage = "Anda berada di luar area ${_selectedBranch!.name} (Jarak: ${distance.toInt()}m)";
        return;
      }

      // 4. Submit to Repository
      final result = await _attendanceRepository.sendAttendanceSecurity({
        'user_id': _selectedEmployee!.id,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
      
      if (result is SuccessState) {
        final now = DateTime.now();
        final timeString = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

        _lastSuccessData = {
          'name': _selectedEmployee!.name,
          'type': attendanceType,
          'time': timeString,
          'image': _currentImage,
        };

        // Tambah ke riwayat (maksimal 5)
        _recentLogs.insert(0, _lastSuccessData!);
        if (_recentLogs.length > 5) _recentLogs.removeLast();

        // Bersuara
        final greeting = DateTime.now().hour < 12 ? "Selamat Pagi" : (DateTime.now().hour < 15 ? "Selamat Siang" : (DateTime.now().hour < 18 ? "Selamat Sore" : "Selamat Malam"));
        _speak("Absen Berhasil. $greeting, ${_selectedEmployee!.name}");

        snackbarMessage = result.message;
        
        // Reset after success but keep success data for UI overlay
        final tempSuccess = _lastSuccessData;
        _selectedEmployee = null;
        _currentImage = null;
        mfImage1 = null;
        mfImage2 = null;
        _percentMatch = 0.0;
        searchController.clear();
        _filteredEmployees = _allEmployees;
        
        notifyListeners();

        // Auto close success overlay after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          _lastSuccessData = null;
          notifyListeners();
        });
      } else {
        errorMeesage = result.message;
      }
    } catch (e) {
      errorMeesage = "Gagal mendapatkan lokasi: $e";
    }
    
    hideLoading();
    notifyListeners();
  }

  Future<void> registerEmployeeFace(String password) async {
    if (mfImage2 == null) {
      errorMeesage = "Ambil foto terlebih dahulu!";
      return;
    }

    showLoading();
    try {
      final bytes = mfImage2!.image;
      final base64Image = base64Encode(bytes);

      final result = await _attendanceRepository.updateEmployeePhoto({
        'user_id': _selectedEmployee!.id,
        'image': base64Image,
        'password': password,
      });

      if (result is SuccessState) {
        snackbarMessage = "Pendaftaran wajah berhasil!";
        _isRegisterMode = false;
        _selectedEmployee = null;
        _loadEmployees(); // Refresh list
      } else {
        errorMeesage = result.message;
      }
    } catch (e) {
      errorMeesage = "Gagal mendaftarkan wajah: $e";
    }
    
    hideLoading();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopLocationTracking();
    super.dispose();
  }
}

import 'dart:io';
import 'package:absensi_2026/app/module/use_case/photo_update.dart';
import 'package:absensi_2026/core/provider/app_provider.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoNotifier extends AppProvider {
  final PhotoUpdateUseCase _photoUpdateUseCase;

  UploadPhotoNotifier(this._photoUpdateUseCase);

  File? _image;
  bool _isSuccess = false;

  File? get image => _image;
  bool get isSuccess => _isSuccess;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> upload() async {
    if (_image == null) {
      snackbarMessage = "Pilih foto terlebih dahulu";
      return;
    }

    showLoading();
    final response = await _photoUpdateUseCase(param: _image);
    hideLoading();
    
    if (response.success) {
      _isSuccess = true;
      snackbarMessage = "Foto berhasil diupload";
      notifyListeners();
    } else {
      snackbarMessage = response.message;
    }
  }

  @override
  void init() {}
}

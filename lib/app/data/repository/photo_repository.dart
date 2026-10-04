import 'dart:io';
import 'package:absensi_2026/app/data/source/photo_api_service.dart';
import 'package:absensi_2026/app/module/repository/photo_repository.dart';
import 'package:absensi_2026/core/constant/constant.dart';
import 'package:absensi_2026/core/network/data_state.dart';

class PhotoRepositoryImpl extends PhotoRepository {
  final PhotoApiService _photoApiService;

  PhotoRepositoryImpl(this._photoApiService);

  @override
  Future<DataState<String>> get() {
    return handleResponse(() => _photoApiService.get(), (json) => json);
  }

  @override
  Future<DataState> getBytes(String url) async {
    final response = await _photoApiService.getBytes(
      path: url.replaceAll(BASE_URL, ''),
    );
    if (response.response.statusCode == HttpStatus.ok) {
      return SuccessState(data: response.response.data);
    } else {
      return ErrorState(
        message:
            '${response.response.statusCode} : ${response.response.statusMessage}',
      );
    }
  }

  @override
  Future<DataState> updatePhoto(File photo) {
    return handleResponse(
      () => _photoApiService.updatePhoto(photo: photo),
      (json) => json,
    );
  }
}

import 'dart:io';
import 'package:absensi_2026/app/module/repository/photo_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class PhotoUpdateUseCase extends AppUseCase<Future<DataState<dynamic>>, File> {
  final PhotoRepository _photoRepository;

  PhotoUpdateUseCase(this._photoRepository);

  @override
  Future<DataState> call({File? param}) async {
    return await _photoRepository.updatePhoto(param!);
  }
}

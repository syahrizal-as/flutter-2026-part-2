import 'package:absensi_2026/app/module/repository/photo_repository.dart';
import 'package:absensi_2026/core/network/data_state.dart';
import 'package:absensi_2026/core/use_case/app_use_case.dart';

class PhotoGetUseCase extends AppUseCase<Future<DataState<String>>, void> {
  final PhotoRepository _photoRepository;

  PhotoGetUseCase(this._photoRepository);

  @override
  Future<DataState<String>> call({void param}) {
    return _photoRepository.get();
  }
}

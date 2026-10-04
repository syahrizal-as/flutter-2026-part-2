import 'package:absensi_2026/core/provider/app_provider.dart';

class MainNotifier extends AppProvider {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  @override
  void init() {}
}

import 'package:flutter/cupertino.dart';

abstract class AppProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isDispose = false;
  String _errorMessage = '';
  String _snackbarMessage = '';

  bool get isLoading => _isLoading;
  bool get isDispose => _isDispose;
  String get errorMessage => _errorMessage;
  String get snackbarMessage => _snackbarMessage;

  set errorMeesage(String? param) {
    _errorMessage = param ?? '';
    if (!_isDispose) notifyListeners();
  }

  set snackbarMessage(String? param) {
    _snackbarMessage = param ?? '';
    if (!_isDispose) notifyListeners();
  }

  void showLoading() {
    _isLoading = true;
    if (!_isDispose) notifyListeners();
  }

  void hideLoading() {
    _isLoading = false;
    if (!_isDispose) notifyListeners();
  }

  @override
  @protected
  void notifyListeners() {
    if (!_isDispose) {
      super.notifyListeners();
    }
  }

  void init();

  @override
  void dispose() {
    _isDispose = true;
    super.dispose();
  }
}

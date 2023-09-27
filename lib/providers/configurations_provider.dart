import 'package:flutter/material.dart';

class ConfigurationsProvider with ChangeNotifier {
  bool _useAutoScan = false;
  bool _useLegacyCode = false;

  bool get useAutoScan => _useAutoScan;
  bool get useLegacyCode => _useLegacyCode;

  void changeUseAutoScan() {
    _useAutoScan = !_useAutoScan;
    notifyListeners();
  }

  void changeUseLegacyCode() {
    _useLegacyCode = !_useLegacyCode;
    notifyListeners();
  }
}

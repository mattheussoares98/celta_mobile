import 'package:celta_inventario/Models/configurations_model.dart';
import 'package:flutter/material.dart';

class ConfigurationsProvider with ChangeNotifier {
  bool _useAutoScan = false;
  bool _useLegacyCode = false;

  bool get useAutoScan => _useAutoScan;
  bool get useLegacyCode => _useLegacyCode;

  List<ConfigurationsModel> _configurations = [];

  // Instância única da classe
  static final ConfigurationsProvider _instance = ConfigurationsProvider._();

  factory ConfigurationsProvider() {
    return _instance;
  }

  ConfigurationsProvider._() {
    _configurations = [
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Auto Scan",
        value: _useAutoScan,
        changeValue: changeUseAutoScan,
        subtitle:
            "Ao confirmar a alteração de uma quantidade, a câmera será aberta automaticamente para ler o código de barras e consultar o próximo produto",
      ),
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Código legado",
        value: _useLegacyCode,
        changeValue: changeUseLegacyCode,
        subtitle: "Consultar os produtos somente pelo código legado",
      ),
    ];
  }

  List<ConfigurationsModel> get configurations => _configurations;

  void changeUseAutoScan() {
    _configurations[0].value = !_configurations[0].value;
    _useAutoScan = !_useAutoScan;
    notifyListeners();
  }

  void changeUseLegacyCode() {
    _configurations[1].value = !_configurations[1].value;
    _useLegacyCode = !_useLegacyCode;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/configurations/configurations.dart';

class ConfigurationsProvider with ChangeNotifier {
  bool _useAutoScan = false;
  bool _useLegacyCode = false;
  bool _searchCustomerByPersonalizedCode = false;

  bool get useAutoScan => _useAutoScan;
  bool get useLegacyCode => _useLegacyCode;
  bool get searchCustomerByPersonalizedCode =>
      _searchCustomerByPersonalizedCode;

  List<ConfigurationsModel> _configurations = [];

  // Instância única da classe
  static final ConfigurationsProvider _instance = ConfigurationsProvider._();

  factory ConfigurationsProvider() {
    return _instance;
  }

  ConfigurationsProvider._() {
    _configurations = [
      ConfigurationsModel(
        isConfigurationOfSearch: false,
        title: "Auto Scan",
        value: _useAutoScan,
        changeValue: changeUseAutoScan,
        subtitle:
            "Ao confirmar a alteração de uma quantidade, a câmera será aberta automaticamente para ler o código de barras e consultar o próximo produto",
      ),
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Código legado (produto)",
        value: _useLegacyCode,
        changeValue: changeUseLegacyCode,
        subtitle: "Consultar os produtos somente pelo código legado",
      ),
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Código personalizado (cliente)",
        value: _searchCustomerByPersonalizedCode,
        changeValue: changeSearchCustomerByPersonalizedCode,
        subtitle: "Consultar clientes somente pelo código personalizado",
      ),
    ];
  }

  List<ConfigurationsModel> get configurations => _configurations;

  Future<void> restoreConfigurations() async {
    _useAutoScan = await PrefsInstance.getUseAutoScan();
    _useLegacyCode = await PrefsInstance.getUseLegacyCode();
    _searchCustomerByPersonalizedCode =
        await PrefsInstance.getSearchCustomerByPersonalizedCode();
    _configurations[0].value = _useAutoScan;
    _configurations[1].value = _useLegacyCode;
    _configurations[2].value = _searchCustomerByPersonalizedCode;

    notifyListeners();
  }

  void changeUseAutoScan() async {
    _configurations[0].value = !_configurations[0].value;
    _useAutoScan = !_useAutoScan;
    notifyListeners();
    await PrefsInstance.setUseAutoScanValue(_useAutoScan);
  }

  void changeUseLegacyCode() async {
    _configurations[1].value = !_configurations[1].value;
    _useLegacyCode = !_useLegacyCode;
    notifyListeners();
    await PrefsInstance.setUseLegacyCodeValue(_useLegacyCode);
  }

  void changeSearchCustomerByPersonalizedCode() async {
    _configurations[2].value = !_configurations[2].value;
    _searchCustomerByPersonalizedCode = !_searchCustomerByPersonalizedCode;
    notifyListeners();
    await PrefsInstance.setSearchCustomerByPersonalizedCode(
      _searchCustomerByPersonalizedCode,
    );
  }
}

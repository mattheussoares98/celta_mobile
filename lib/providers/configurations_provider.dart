import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/configurations/configurations.dart';

class ConfigurationsProvider with ChangeNotifier {
  bool _useLegacyCode = false;
  bool _searchCustomerByPersonalizedCode = false;
  bool _searchProductByPersonalizedCode = false;

  bool get useLegacyCode => _useLegacyCode;
  bool get searchCustomerByPersonalizedCode =>
      _searchCustomerByPersonalizedCode;
  bool get searchProductByPersonalizedCode => _searchProductByPersonalizedCode;

  List<ConfigurationsModel> _configurations = [];

  // Instância única da classe
  static final ConfigurationsProvider _instance = ConfigurationsProvider._();

  factory ConfigurationsProvider() {
    return _instance;
  }
  ConfigurationsModel? get autoScan => _autoScan;
  ConfigurationsModel? _autoScan;

  ConfigurationsProvider._() {
    _autoScan = ConfigurationsModel(
      isConfigurationOfSearch: false,
      title: "Auto Scan",
      value: false,
      updateValue: changeUseAutoScan,
      subtitle:
          "Ao confirmar a alteração de uma quantidade, a câmera será aberta automaticamente para ler o código de barras e consultar o próximo produto",
    );

    _configurations = [
      _autoScan!,
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Código legado (produto)",
        value: _useLegacyCode,
        updateValue: changeUseLegacyCode,
        subtitle: "Consultar os produtos somente pelo código legado",
      ),
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Código personalizado (produto)",
        value: _useLegacyCode,
        updateValue: changeSearchProductByPersonalizedCode,
        subtitle: "Consultar os produtos somente pelo código personalizado",
      ),
      ConfigurationsModel(
        isConfigurationOfSearch: true,
        title: "Código personalizado (cliente)",
        value: _searchCustomerByPersonalizedCode,
        updateValue: changeSearchCustomerByPersonalizedCode,
        subtitle: "Consultar clientes somente pelo código personalizado",
      ),
    ];
  }

  List<ConfigurationsModel> get configurations => _configurations;

  Future<void> restoreConfigurations() async {
    _autoScan?.value = await PrefsInstance.getUseAutoScan();
    _useLegacyCode = await PrefsInstance.getUseLegacyCode();
    _searchCustomerByPersonalizedCode =
        await PrefsInstance.getSearchCustomerByPersonalizedCode();
    _searchProductByPersonalizedCode =
        await PrefsInstance.getSearchProductByPersonalizedCode();

    _configurations[1].value = _useLegacyCode;
    _configurations[2].value = _searchCustomerByPersonalizedCode;
    _configurations[3].value = _searchProductByPersonalizedCode;

    notifyListeners();
  }

  void changeUseAutoScan() async {
    bool newValue = !_autoScan!.value;

    _autoScan!.value = newValue;

    await PrefsInstance.setUseAutoScanValue(newValue);
    notifyListeners();
  }

  void changeUseLegacyCode() async {
    _configurations[1].value = !_configurations[1].value;
    _useLegacyCode = !_useLegacyCode;
    notifyListeners();
    await PrefsInstance.setUseLegacyCodeValue(_useLegacyCode);
  }

  void changeSearchProductByPersonalizedCode() async {
    _configurations[2].value = !_configurations[2].value;
    _searchProductByPersonalizedCode = !_searchProductByPersonalizedCode;
    notifyListeners();
    await PrefsInstance.setSearchProductByPersonalizedCode(
      _searchProductByPersonalizedCode,
    );
  }

  void changeSearchCustomerByPersonalizedCode() async {
    _configurations[3].value = !_configurations[3].value;
    _searchCustomerByPersonalizedCode = !_searchCustomerByPersonalizedCode;
    notifyListeners();
    await PrefsInstance.setSearchCustomerByPersonalizedCode(
      _searchCustomerByPersonalizedCode,
    );
  }
}

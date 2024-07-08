import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/configurations/configurations.dart';

class ConfigurationsProvider with ChangeNotifier {
  bool _searchCustomerByPersonalizedCode = false;

  bool get searchCustomerByPersonalizedCode =>
      _searchCustomerByPersonalizedCode;

  List<ConfigurationsModel> _configurations = [];

  // Instância única da classe
  static final ConfigurationsProvider _instance = ConfigurationsProvider._();

  factory ConfigurationsProvider() {
    return _instance;
  }
  ConfigurationsModel? get autoScan => _autoScan;
  ConfigurationsModel? _autoScan;

  ConfigurationsModel? get legacyCode => _legacyCode;
  ConfigurationsModel? _legacyCode;

  ConfigurationsModel? get productPersonalizedCode => _productPersonalizedCode;
  ConfigurationsModel? _productPersonalizedCode;

  ConfigurationsProvider._() {
    _autoScan = ConfigurationsModel(
      isConfigurationOfSearch: false,
      title: "Auto Scan",
      value: false,
      updateValue: changeUseAutoScan,
      subtitle:
          "Ao confirmar a alteração de uma quantidade, a câmera será aberta automaticamente para ler o código de barras e consultar o próximo produto",
    );

    _legacyCode = ConfigurationsModel(
      isConfigurationOfSearch: true,
      title: "Código legado (produto)",
      value: false,
      updateValue: changeUseLegacyCode,
      subtitle: "Consultar os produtos somente pelo código legado",
    );

    _productPersonalizedCode = ConfigurationsModel(
      isConfigurationOfSearch: true,
      title: "Código personalizado (produto)",
      value: false,
      updateValue: changeSearchProductByPersonalizedCode,
      subtitle: "Consultar os produtos somente pelo código personalizado",
    );

    _configurations = [
      _autoScan!,
      _legacyCode!,
      _productPersonalizedCode!,
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
    _legacyCode?.value = await PrefsInstance.getUseLegacyCode();
    _productPersonalizedCode?.value =
        await PrefsInstance.getSearchProductByPersonalizedCode();

    _searchCustomerByPersonalizedCode =
        await PrefsInstance.getSearchCustomerByPersonalizedCode();

    _configurations[2].value = _searchCustomerByPersonalizedCode;

    notifyListeners();
  }

  void changeUseAutoScan() async {
    bool newValue = !_autoScan!.value;

    _autoScan!.value = newValue;

    await PrefsInstance.setUseAutoScanValue(newValue);
    notifyListeners();
  }

  void changeUseLegacyCode() async {
    bool newValue = !_legacyCode!.value;

    _legacyCode!.value = newValue;

    notifyListeners();
    await PrefsInstance.setUseLegacyCodeValue(newValue);
  }

  void changeSearchProductByPersonalizedCode() async {
    bool newValue = !_productPersonalizedCode!.value;

    _productPersonalizedCode!.value = newValue;

    notifyListeners();
    await PrefsInstance.setSearchProductByPersonalizedCode(newValue);
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

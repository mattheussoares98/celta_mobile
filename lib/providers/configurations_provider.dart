import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/configurations/configurations.dart';

class ConfigurationsProvider with ChangeNotifier {
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

  ConfigurationsModel? get customerPersonalizedCode =>
      _customerPersonalizedCode;
  ConfigurationsModel? _customerPersonalizedCode;

  ConfigurationsProvider._() {
    _autoScan = ConfigurationsModel(
      configurationType: ConfigurationType.autoScan,
      title: "Auto Scan",
      value: false,
      updateValue: changeUseAutoScan,
      subtitle:
          "Ao confirmar a alteração de uma quantidade, a câmera será aberta automaticamente para ler o código de barras e consultar o próximo produto",
    );

    _legacyCode = ConfigurationsModel(
      configurationType: ConfigurationType.legacyCode,
      title: "Código legado (produto)",
      value: false,
      updateValue: changeUseLegacyCode,
      subtitle: "Consultar os produtos somente pelo código legado",
    );

    _productPersonalizedCode = ConfigurationsModel(
      configurationType: ConfigurationType.personalizedCode,
      title: "Código personalizado (produto)",
      value: false,
      updateValue: changeSearchProductByPersonalizedCode,
      subtitle: "Consultar os produtos somente pelo código personalizado",
    );

    _customerPersonalizedCode = ConfigurationsModel(
      configurationType: ConfigurationType.personalizedCodeCustomer,
      title: "Código personalizado (cliente)",
      value: false,
      updateValue: changeSearchCustomerByPersonalizedCode,
      subtitle: "Consultar clientes somente pelo código personalizado",
    );

    _configurations = [
      _autoScan!,
      _legacyCode!,
      _productPersonalizedCode!,
      _customerPersonalizedCode!,
    ];
  }

  List<ConfigurationsModel> get configurations => _configurations;

  Future<void> restoreConfigurations() async {
    _autoScan?.value =
        await PrefsInstance.getBool(prefsKeys: PrefsKeys.useAutoScan);
    _legacyCode?.value =
        await PrefsInstance.getBool(prefsKeys: PrefsKeys.useLegacyCode);
    _productPersonalizedCode?.value = await PrefsInstance.getBool(
      prefsKeys: PrefsKeys.searchProductByPersonalizedCode,
    );
    _customerPersonalizedCode?.value = await PrefsInstance.getBool(
      prefsKeys: PrefsKeys.searchCustomerByPersonalizedCode,
    );

    notifyListeners();
  }

  void changeUseAutoScan() async {
    bool newValue = !_autoScan!.value;

    _autoScan!.value = newValue;

    await PrefsInstance.setBool(
      prefsKeys: PrefsKeys.useAutoScan,
      value: newValue,
    );
    notifyListeners();
  }

  void changeUseLegacyCode() async {
    bool newValue = !_legacyCode!.value;

    _legacyCode!.value = newValue;

    await PrefsInstance.setBool(
      prefsKeys: PrefsKeys.useLegacyCode,
      value: newValue,
    );

    if (_productPersonalizedCode?.value == true) {
      _productPersonalizedCode?.value = false;
      await PrefsInstance.setBool(
        prefsKeys: PrefsKeys.searchCustomerByPersonalizedCode,
        value: newValue,
      );
    }

    notifyListeners();
  }

  void changeSearchProductByPersonalizedCode() async {
    bool newValue = !_productPersonalizedCode!.value;

    _productPersonalizedCode!.value = newValue;

    await PrefsInstance.setBool(
      prefsKeys: PrefsKeys.searchProductByPersonalizedCode,
      value: newValue,
    );

    if (_legacyCode?.value == true) {
      _legacyCode?.value = false;
      await PrefsInstance.setBool(
        prefsKeys: PrefsKeys.useLegacyCode,
        value: false,
      );
    }
    notifyListeners();
  }

  void changeSearchCustomerByPersonalizedCode() async {
    bool newValue = !_customerPersonalizedCode!.value;

    _customerPersonalizedCode!.value = newValue;

    notifyListeners();
    await PrefsInstance.setBool(
      prefsKeys: PrefsKeys.searchCustomerByPersonalizedCode,
      value: newValue,
    );
  }
}

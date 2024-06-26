import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

enum _PrefsKeys {
  userIdentity,
  user,
  urlCCS,
  enterpriseName,
  customers,
  cart,
  hasUnreadNotifications,
  mySoaps,
  useAutoScan,
  useLegacyCode,
  showMessageToUseCameraInWebVersion,
  searchCustomerByPersonalizedCode,
  searchProductByPersonalizedCode,
  buyRequest,
  notifications,
  usersInformations,
}

class PrefsInstance {
  static late SharedPreferences _prefs;
  static Future<void> removeNotUsedPrefsKeys() async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.remove(_PrefsKeys.notifications.name);
  }

  static Future<bool> _prefsContainsKey(String key) async {
    _prefs = await SharedPreferences.getInstance();

    return _prefs.containsKey(key);
  }

  static Future<void> _setString({
    required _PrefsKeys prefsKeys,
    required String value,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(prefsKeys.name, value);
  }

  static Future<bool> _setBool({
    required _PrefsKeys prefsKeys,
    required bool value,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    bool successToSetBool = await _prefs.setBool(prefsKeys.name, value);
    return successToSetBool;
  }

  static Future<String> _getString({
    required _PrefsKeys prefsKeys,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    if (await _prefsContainsKey(prefsKeys.name)) {
      return await _prefs.getString(prefsKeys.name)!;
    } else {
      return "";
    }
  }

  static Future<bool> _getBool({
    required _PrefsKeys prefsKeys,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    if (await _prefsContainsKey(prefsKeys.name)) {
      return await _prefs.getBool(prefsKeys.name)!;
    } else {
      return false;
    }
  }

  static Future<bool> isLogged() async {
    _prefs = await SharedPreferences.getInstance();
    ;
    return await _prefs.containsKey(_PrefsKeys.userIdentity.name) &&
        await _getString(prefsKeys: _PrefsKeys.userIdentity) != "";
  }

  static Future<String> getUserIdentity() async {
    if (await isLogged()) {
      return await _getString(prefsKeys: _PrefsKeys.userIdentity);
    } else {
      return "";
    }
  }

  static Future<String> getUserName() async {
    return await _getString(prefsKeys: _PrefsKeys.user);
  }

  static Future<String> getUrlCcs() async {
    return await _getString(prefsKeys: _PrefsKeys.urlCCS);
  }

  static Future<void> setUrlCcsAndEnterpriseName() async {
    await _setString(
      prefsKeys: _PrefsKeys.urlCCS,
      value: UserData.urlCCS,
    );
    await _setString(
      prefsKeys: _PrefsKeys.enterpriseName,
      value: UserData.enterpriseName,
    );
  }

  static Future<String> getEnterpriseName() async {
    return await _getString(prefsKeys: _PrefsKeys.enterpriseName);
  }

  static Future<void> setUserIdentity() async {
    await _setString(
        prefsKeys: _PrefsKeys.userIdentity, value: UserData.crossIdentity);
  }

  static Future<void> setUserName() async {
    await _setString(prefsKeys: _PrefsKeys.user, value: UserData.userName);
  }

  static Future<void> setCustomerSaleRequest(String newCustomers) async {
    await _setString(prefsKeys: _PrefsKeys.customers, value: newCustomers);
  }

  static Future<void> clearCustomerSaleRequest() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_PrefsKeys.customers.name, "");
  }

  static Future<String> getCustomerSaleRequest() async {
    return await _getString(prefsKeys: _PrefsKeys.customers);
  }

  static Future<String> getCartSaleRequest() async {
    return await _getString(prefsKeys: _PrefsKeys.cart);
  }

  static Future<void> setCartSaleRequest(String newCart) async {
    await _setString(prefsKeys: _PrefsKeys.cart, value: newCart);
  }

  static Future<void> clearCartSaleRequest() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_PrefsKeys.cart.name, "");
  }

  static Future<void> setSoaps(List<dynamic> mySoaps) async {
    _prefs = await SharedPreferences.getInstance();
    List<String> encodedMySoaps =
        mySoaps.map((item) => json.encode(item)).toList();
    await _prefs.setStringList(_PrefsKeys.mySoaps.name, encodedMySoaps);
  }

  static Future<void> clearSoaps() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.remove(_PrefsKeys.mySoaps.name);
  }

  static Future<List<dynamic>> getSoaps() async {
    List<dynamic> mySoaps = [];
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getStringList(_PrefsKeys.mySoaps.name) != null) {
      List<String> encodedMySoaps =
          await _prefs.getStringList(_PrefsKeys.mySoaps.name)!;

      mySoaps = encodedMySoaps.map((item) => json.decode(item)).toList();
    }

    return mySoaps;
  }

  static Future<void> setUseAutoScanValue(bool newValue) async {
    await _setBool(prefsKeys: _PrefsKeys.useAutoScan, value: newValue);
  }

  static Future<void> setUseLegacyCodeValue(bool newValue) async {
    await _setBool(prefsKeys: _PrefsKeys.useLegacyCode, value: newValue);
  }

  static Future<void> setSearchCustomerByPersonalizedCode(bool newValue) async {
    await _setBool(
      prefsKeys: _PrefsKeys.searchCustomerByPersonalizedCode,
      value: newValue,
    );
  }

  static Future<void> setSearchProductByPersonalizedCode(bool newValue) async {
    await _setBool(
      prefsKeys: _PrefsKeys.searchProductByPersonalizedCode,
      value: newValue,
    );
  }

  static Future<void> restoreUserAndEnterpriseNameOrUrlCCS({
    required TextEditingController enterpriseNameOrUrlCCSController,
    required TextEditingController userController,
  }) async {
    userController.text = await PrefsInstance.getUserName();
    UserData.userName = userController.text;
    UserData.urlCCS = await PrefsInstance.getUrlCcs();
    UserData.enterpriseName = await PrefsInstance.getEnterpriseName();

    if (UserData.enterpriseName != "") {
      enterpriseNameOrUrlCCSController.text = UserData.enterpriseName;
    } else {
      enterpriseNameOrUrlCCSController.text = UserData.urlCCS;
    }
  }

  static Future<bool> getUseAutoScan() async {
    return await _getBool(prefsKeys: _PrefsKeys.useAutoScan);
  }

  static Future<bool> getUseLegacyCode() async {
    return await _getBool(prefsKeys: _PrefsKeys.useLegacyCode);
  }

  static Future<bool> getSearchCustomerByPersonalizedCode() async {
    return await _getBool(
      prefsKeys: _PrefsKeys.searchCustomerByPersonalizedCode,
    );
  }

  static Future<bool> getSearchProductByPersonalizedCode() async {
    return await _getBool(
      prefsKeys: _PrefsKeys.searchProductByPersonalizedCode,
    );
  }

  static Future<void> setToNoShowAgainMessageToUseCameraInWebVersion() async {
    await _setBool(
        prefsKeys: _PrefsKeys.showMessageToUseCameraInWebVersion, value: false);
  }

  static Future<bool> getShowMessageToUseCameraInWebVersion() async {
    if (!await _prefsContainsKey(
        _PrefsKeys.showMessageToUseCameraInWebVersion.name)) {
      await _setBool(
        prefsKeys: _PrefsKeys.showMessageToUseCameraInWebVersion,
        value: true,
      );
    }

    return await _getBool(
        prefsKeys: _PrefsKeys.showMessageToUseCameraInWebVersion);
  }

  static Future<void> setBuyRequest(String newBuyRequest) async {
    await _setString(prefsKeys: _PrefsKeys.buyRequest, value: newBuyRequest);
  }

  static Future<String> getBuyRequest() async {
    return await _getString(prefsKeys: _PrefsKeys.buyRequest);
  }

  static Future<void> setHasUnreadNotifications(bool newValue) async {
    await _setBool(
        prefsKeys: _PrefsKeys.hasUnreadNotifications, value: newValue);
  }

  static Future<bool> getHasUnreadNotifications() async {
    return await _getBool(prefsKeys: _PrefsKeys.hasUnreadNotifications);
  }

  static Future<void> setUsersInformations(String newValue) async {
    await _setString(
      prefsKeys: _PrefsKeys.usersInformations,
      value: newValue,
    );
  }

  static Future<String> getUsersInformations() async {
    return await _getString(
      prefsKeys: _PrefsKeys.usersInformations,
    );
  }
}

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

enum PrefsKeys {
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

    await _prefs.remove(PrefsKeys.notifications.name);
  }

  static Future<bool> _prefsContainsKey(String key) async {
    _prefs = await SharedPreferences.getInstance();

    return _prefs.containsKey(key);
  }

  static Future<void> setString({
    required PrefsKeys prefsKeys,
    required String value,
  }) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString(prefsKeys.name, value);
  }

  static Future<void> removeKey(PrefsKeys prefsKeys) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.remove(prefsKeys.name);
  }

  static Future<void> setObject({
    required PrefsKeys prefsKeys,
    required dynamic object,
  }) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.setString(prefsKeys.name, json.encode(object));
  }

  static Future<String> getString(PrefsKeys prefsKeys) async {
    _prefs = await SharedPreferences.getInstance();
    if (await _prefsContainsKey(prefsKeys.name)) {
      return await _prefs.getString(prefsKeys.name)!;
    } else {
      return "";
    }
  }

  static Future<bool> _setBool({
    required PrefsKeys prefsKeys,
    required bool value,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    bool successToSetBool = await _prefs.setBool(prefsKeys.name, value);
    return successToSetBool;
  }

  static Future<String> _getString({
    required PrefsKeys prefsKeys,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    if (await _prefsContainsKey(prefsKeys.name)) {
      return await _prefs.getString(prefsKeys.name)!;
    } else {
      return "";
    }
  }

  static Future<bool> _getBool({
    required PrefsKeys prefsKeys,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    if (await _prefsContainsKey(prefsKeys.name)) {
      return await _prefs.getBool(prefsKeys.name)!;
    } else {
      return false;
    }
  }

  static Future<void> setSoaps(List<dynamic> mySoaps) async {
    _prefs = await SharedPreferences.getInstance();
    List<String> encodedMySoaps =
        mySoaps.map((item) => json.encode(item)).toList();
    await _prefs.setStringList(PrefsKeys.mySoaps.name, encodedMySoaps);
  }

  static Future<List<dynamic>> getSoaps() async {
    List<dynamic> mySoaps = [];
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getStringList(PrefsKeys.mySoaps.name) != null) {
      List<String> encodedMySoaps =
          await _prefs.getStringList(PrefsKeys.mySoaps.name)!;

      mySoaps = encodedMySoaps.map((item) => json.decode(item)).toList();
    }

    return mySoaps;
  }

  static Future<void> setUseAutoScanValue(bool newValue) async {
    await _setBool(prefsKeys: PrefsKeys.useAutoScan, value: newValue);
  }

  static Future<void> setUseLegacyCodeValue(bool newValue) async {
    await _setBool(prefsKeys: PrefsKeys.useLegacyCode, value: newValue);
  }

  static Future<void> setSearchCustomerByPersonalizedCode(bool newValue) async {
    await _setBool(
      prefsKeys: PrefsKeys.searchCustomerByPersonalizedCode,
      value: newValue,
    );
  }

  static Future<void> setSearchProductByPersonalizedCode(bool newValue) async {
    await _setBool(
      prefsKeys: PrefsKeys.searchProductByPersonalizedCode,
      value: newValue,
    );
  }

  static Future<void> restoreUserAndEnterpriseNameOrUrlCCS({
    required TextEditingController enterpriseNameOrUrlCCSController,
    required TextEditingController userController,
  }) async {
    userController.text = await PrefsInstance.getString(PrefsKeys.user);
    UserData.userName = userController.text;
    UserData.urlCCS = await PrefsInstance.getString(PrefsKeys.urlCCS);
    UserData.enterpriseName = await PrefsInstance.getString(
      PrefsKeys.enterpriseName,
    );

    if (UserData.enterpriseName != "") {
      enterpriseNameOrUrlCCSController.text = UserData.enterpriseName;
    } else {
      enterpriseNameOrUrlCCSController.text = UserData.urlCCS;
    }
  }

  static Future<bool> getUseAutoScan() async {
    return await _getBool(prefsKeys: PrefsKeys.useAutoScan);
  }

  static Future<bool> getUseLegacyCode() async {
    return await _getBool(prefsKeys: PrefsKeys.useLegacyCode);
  }

  static Future<bool> getSearchCustomerByPersonalizedCode() async {
    return await _getBool(
      prefsKeys: PrefsKeys.searchCustomerByPersonalizedCode,
    );
  }

  static Future<bool> getSearchProductByPersonalizedCode() async {
    return await _getBool(
      prefsKeys: PrefsKeys.searchProductByPersonalizedCode,
    );
  }

  static Future<void> setToNoShowAgainMessageToUseCameraInWebVersion() async {
    await _setBool(
        prefsKeys: PrefsKeys.showMessageToUseCameraInWebVersion, value: false);
  }

  static Future<bool> getShowMessageToUseCameraInWebVersion() async {
    if (!await _prefsContainsKey(
        PrefsKeys.showMessageToUseCameraInWebVersion.name)) {
      await _setBool(
        prefsKeys: PrefsKeys.showMessageToUseCameraInWebVersion,
        value: true,
      );
    }

    return await _getBool(
        prefsKeys: PrefsKeys.showMessageToUseCameraInWebVersion);
  }

  static Future<void> setHasUnreadNotifications(bool newValue) async {
    await _setBool(
        prefsKeys: PrefsKeys.hasUnreadNotifications, value: newValue);
  }

  static Future<bool> getHasUnreadNotifications() async {
    return await _getBool(prefsKeys: PrefsKeys.hasUnreadNotifications);
  }

  static Future<String> getUsersInformations() async {
    return await _getString(
      prefsKeys: PrefsKeys.usersInformations,
    );
  }
}

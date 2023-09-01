import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsInstance {
  static Future<void> removeNotUsedKeys() async {}

  static Future<bool> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('userIdentity') != "" &&
        await prefs.getString('userIdentity') != null;
  }

  static Future<String> getUserIdentity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await isLogged()) {
      return await prefs.getString('userIdentity')!;
    } else {
      return "";
    }
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await prefs.getString('user') != null) {
      return await prefs.getString('user')!;
    } else {
      return "";
    }
  }

  static Future<bool> hasUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getString('user') != null &&
        await prefs.getString('user') != "";
  }

  static Future<bool> hasUrlCcs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getString('urlCCS') != null &&
        await prefs.getString('urlCCS') != "";
  }

  static Future<String> getUrlCcs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await hasUrlCcs()) {
      return await prefs.getString('urlCCS')!;
    } else {
      return "";
    }
  }

  static Future<void> setUrlCcs(String newUrlCcs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('urlCCS', newUrlCcs);
  }

  static Future<bool> hasEnterpriseName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.getString('enterpriseName') != null &&
        await prefs.getString('enterpriseName') != "";
  }

  static Future<String> getEnterpriseName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await hasEnterpriseName()) {
      return await prefs.getString('enterpriseName')!;
    } else {
      return "";
    }
  }

  static Future<void> setEnterpriseName(String newEnterpriseName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('enterpriseName', newEnterpriseName);
  }

  static Future<void> setUserIdentity(String newIdentity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdentity', newIdentity);
  }

  static Future<void> setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', userName);
  }

  static Future<void> setCustomerSaleRequest(String newCustomers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("customers", newCustomers);
  }

  static Future<void> clearCustomerSaleRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("customers", "");
  }

  static Future<bool> hasCustomerSaleRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('customers') != "" &&
        prefs.getString('customers') != null;
  }

  static Future<String> getCustomerSaleRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await hasCustomerSaleRequest()) {
      return await prefs.getString("customers")!;
    } else {
      return "";
    }
  }

  static Future<bool> hasCartSaleRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cart') != "" && prefs.getString('cart') != null;
  }

  static Future<String> getCartSaleRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await hasCustomerSaleRequest()) {
      return await prefs.getString("cart")!;
    } else {
      return "";
    }
  }

  static Future<void> setCartSaleRequest(String newCart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cart", newCart);
  }

  static Future<void> clearCartSaleRequest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cart", "");
  }

  static Future<void> setSoaps(List<dynamic> mySoaps) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedMySoaps =
        mySoaps.map((item) => json.encode(item)).toList();
    await prefs.setStringList('mySoaps', encodedMySoaps);
  }

  static Future<void> clearSoaps() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("mySoaps");
  }

  static Future<List<dynamic>> getSoaps() async {
    List<dynamic> mySoaps = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('mySoaps') != null) {
      List<String> encodedMySoaps = await prefs.getStringList('mySoaps')!;

      mySoaps = encodedMySoaps.map((item) => json.decode(item)).toList();
    }

    return mySoaps;
  }
}

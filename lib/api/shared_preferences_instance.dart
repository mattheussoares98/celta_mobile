import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLogged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString('userIdentity') != "" &&
      await prefs.getString('userIdentity') != null;
}

Future<String> getUserIdentity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (await isLogged()) {
    return await prefs.getString('userIdentity')!;
  } else {
    return "";
  }
}

Future<String> getUserName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (await prefs.getString('user') != null) {
    return await prefs.getString('user')!;
  } else {
    return "";
  }
}

Future<bool> hasUrlCcs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return await prefs.getString('urlCCS') != null &&
      await prefs.getString('urlCCS') != "";
}

Future<String> getUrlCcs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (await hasUrlCcs()) {
    return await prefs.getString('urlCCS')!;
  } else {
    return "";
  }
}

Future<void> setUrlCcs(String newUrlCcs) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('urlCCS', newUrlCcs);
}

Future<bool> hasEnterpriseName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return await prefs.getString('enterpriseName') != null &&
      await prefs.getString('enterpriseName') != "";
}

Future<String> getEnterpriseName() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (await hasEnterpriseName()) {
    return await prefs.getString('enterpriseName')!;
  } else {
    return "";
  }
}

Future<void> setEnterpriseName(String newEnterpriseName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('enterpriseName', newEnterpriseName);
}

Future<void> setUserIdentity(String newIdentity) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userIdentity', newIdentity);
}

Future<void> setUserName(String userName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user', userName);
}

Future<void> setCustomerSaleRequest(String newCustomers) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("customers");
  await prefs.setString("customers", newCustomers);
}

Future<bool> hasCustomerSaleRequest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('customers') != "" &&
      prefs.getString('customers') != null;
}

Future<String> getCustomerSaleRequest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (await hasCustomerSaleRequest()) {
    return await prefs.getString("customers")!;
  } else {
    return "";
  }
}

Future<bool> hasCartSaleRequest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('cart') != "" && prefs.getString('cart') != null;
}

Future<String> getCartSaleRequest() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (await hasCustomerSaleRequest()) {
    return await prefs.getString("cart")!;
  } else {
    return "";
  }
}

Future<void> setCartSaleRequest(String newCart) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("cart");
  await prefs.setString("cart", newCart);
}

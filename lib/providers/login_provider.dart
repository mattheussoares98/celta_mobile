import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../utils/utils.dart';

class LoginProvider with ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _changedEnterpriseNameOrUrlCcs = false;
  bool get changedEnterpriseNameOrUrlCcs => _changedEnterpriseNameOrUrlCcs;
  set changedEnterpriseNameOrUrlCcs(bool? newValue) {
    _changedEnterpriseNameOrUrlCcs = true;
  }

  Future<bool> verifyIsLogged() async {
    UserData.crossIdentity =
        await PrefsInstance.getString(PrefsKeys.userIdentity);
    UserData.enterpriseName =
        await PrefsInstance.getString(PrefsKeys.enterpriseName);
    UserData.userName = await PrefsInstance.getString(PrefsKeys.user);
    UserData.urlCCS = await PrefsInstance.getString(PrefsKeys.urlCCS);

    if (UserData.crossIdentity.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> login({
    required String user,
    required String password,
    required TextEditingController enterpriseName,
    required BuildContext context,
  }) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      UserData.userName = user;
      await PrefsInstance.setString(
        prefsKeys: PrefsKeys.user,
        value: UserData.userName,
      );

      if (_changedEnterpriseNameOrUrlCcs) {
        _errorMessage =
            await FirebaseHelper.getUrlFromFirebaseAndReturnErrorIfHas(
          enterpriseName.text,
        );

        if (_errorMessage != "") {
          ShowSnackbarMessage.show(
            message: _errorMessage,
            context: context,
          );
          return;
        }

        await PrefsInstance.setString(
          prefsKeys: PrefsKeys.urlCCS,
          value: UserData.urlCCS,
        );
        await PrefsInstance.setString(
          prefsKeys: PrefsKeys.enterpriseName,
          value: UserData.enterpriseName,
        );
      }

      await SoapRequest.soapPost(
        parameters: {
          "user": user,
          "password": password,
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorMessage = SoapRequestResponse.errorMessage;
      if (_errorMessage != "") {
        ShowSnackbarMessage.show(
          message: _errorMessage,
          context: context,
        );
      } else {
        Map resultAsMap = json.decode(SoapRequestResponse.responseAsString);

        final myTransformer = Xml2Json();
        myTransformer
            .parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
        String toParker = myTransformer.toParker();
        Map toParker2 = json.decode(toParker);
        UserData.crossIdentity = toParker2['string'];

        await PrefsInstance.setString(
          prefsKeys: PrefsKeys.userIdentity,
          value: UserData.crossIdentity,
        );

        Navigator.of(context).pushNamedAndRemoveUntil(
          APPROUTES.HOME_PAGE,
          (route) => false,
        );
        _changedEnterpriseNameOrUrlCcs = false;
      }
    } catch (e) {
      ShowSnackbarMessage.show(
        message: e.toString(),
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    UserData.crossIdentity = "";

    await PrefsInstance.setString(
      prefsKeys: PrefsKeys.userIdentity,
      value: UserData.crossIdentity,
    );

    await PrefsInstance.removeKeysOnLogout();
    Navigator.of(NavigatorKey.navigatorKey.currentState!.context)
        .pushNamedAndRemoveUntil(
      APPROUTES.LOGIN_PAGE,
      (route) => false,
    );
  }
}

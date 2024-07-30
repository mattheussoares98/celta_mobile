import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../utils/utils.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController enterpriseNameOrUrlCCSController =
      TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _changedEnterpriseNameOrUrlCcs = false;
  bool get changedEnterpriseNameOrUrlCcs => _changedEnterpriseNameOrUrlCcs;
  set changedEnterpriseNameOrUrlCcs(bool? newValue) {
    _changedEnterpriseNameOrUrlCcs = true;
  }

  static MultiStreamController<bool>? _loginController;
  //esse stream está sendo usado no AuthOrHomePage
  //quando da certo o login, ele adiciona o _isAuth no controller
  static final _isAuthStream = Stream<bool>.multi((controller) {
    _loginController = controller;
  });
  Stream<bool> get authStream => _isAuthStream;

  Future<void> verifyIsLogged() async {
    final crossIdentity = await PrefsInstance.getString(PrefsKeys.userIdentity);

    if (crossIdentity.isNotEmpty) {
      UserData.crossIdentity = await PrefsInstance.getString(
        PrefsKeys.userIdentity,
      );
      _loginController!.add(true);
    }
  }

  Future<void> login({
    required String user,
    required String password,
    required TextEditingController enterpriseNameOrUrlCCSController,
    required BuildContext context,
  }) async {
    _errorMessage = '';
    _isLoading = true;
    UserData.userName = user;
    await PrefsInstance.setString(
      prefsKeys: PrefsKeys.user,
      value: UserData.userName,
    );
    notifyListeners();

    if (_changedEnterpriseNameOrUrlCcs) {
      if (ConvertString.isUrl(enterpriseNameOrUrlCCSController.text)) {
        if (enterpriseNameOrUrlCCSController.text.endsWith('/')) {
          enterpriseNameOrUrlCCSController.text =
              enterpriseNameOrUrlCCSController.text.substring(
                  0, enterpriseNameOrUrlCCSController.text.length - 1);
        }
        UserData.urlCCS = enterpriseNameOrUrlCCSController.text;
        UserData.enterpriseName = "";
      }
      _errorMessage =
          await FirebaseHelper.getUrlFromFirebaseAndReturnErrorIfHas(
        enterpriseNameOrUrlCCSController.text,
      );

      await PrefsInstance.setString(
        prefsKeys: PrefsKeys.urlCCS,
        value: UserData.urlCCS,
      );
      await PrefsInstance.setString(
        prefsKeys: PrefsKeys.enterpriseName,
        value: UserData.enterpriseName,
      );
    }

    if (_errorMessage != "" &&
        !ConvertString.isUrl(
          enterpriseNameOrUrlCCSController.text,
        )) {
      ShowSnackbarMessage.showMessage(
        message: _errorMessage,
        context: context,
      );
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
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
        ShowSnackbarMessage.showMessage(
          message: _errorMessage,
          context: context,
        );
      } else {
        Map resultAsMap = json.decode(SoapRequestResponse.responseAsString);
        // Map resultAsMap = resultAsList.asMap();

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
        await FirebaseHelper.addCcsClientInFirebase();

        _loginController?.add(true);
        _changedEnterpriseNameOrUrlCcs = false;
      }
    } catch (e) {
      // _updateErrorMessage(e.toString());
      //print('deu erro no login: $e');
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessage,
        context: context,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  logout() async {
    UserData.crossIdentity = "";

    await PrefsInstance.setString(
      prefsKeys: PrefsKeys.userIdentity,
      value: UserData.crossIdentity,
    );

    await PrefsInstance.removeKeysOnLogout();
    _loginController?.add(false);
  }
}

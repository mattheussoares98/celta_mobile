import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xml2json/xml2json.dart';

import '../api/api.dart';
import '../components/global_widgets/global_widgets.dart';
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
    bool isLogged = await PrefsInstance.isLogged();

    if (isLogged) {
      UserData.crossIdentity = await PrefsInstance.getUserIdentity();
      _loginController!.add(true);
    }
  }

  login({
    required String user,
    required String password,
    required TextEditingController enterpriseNameOrUrlCCSController,
    required BuildContext context,
  }) async {
    _errorMessage = '';
    _isLoading = true;
    UserData.userName = user;
    await PrefsInstance.setUserName();
    notifyListeners();

    if (_changedEnterpriseNameOrUrlCcs) {
      if (ConvertString.isUrl(enterpriseNameOrUrlCCSController.text)) {
        UserData.urlCCS = enterpriseNameOrUrlCCSController.text;
        UserData.enterpriseName = "";
      }
      _errorMessage =
          await FirebaseHelper.getUrlFromFirebaseAndReturnErrorIfHas(
        enterpriseNameOrUrlCCSController.text,
      );

      await PrefsInstance.setUrlCcsAndEnterpriseName();
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
      await SoapHelper.soapPost(
        parameters: {
          "user": user,
          "password": password,
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorMessage = SoapHelperResponseParameters.errorMessage;
      if (_errorMessage != "") {
        ShowSnackbarMessage.showMessage(
          message: _errorMessage,
          context: context,
        );
      } else {
        Map resultAsMap =
            json.decode(SoapHelperResponseParameters.responseAsString);
        // Map resultAsMap = resultAsList.asMap();

        final myTransformer = Xml2Json();
        myTransformer
            .parse(resultAsMap["Usuarios"][0]['CrossIdentity_Usuario']);
        String toParker = myTransformer.toParker();
        Map toParker2 = json.decode(toParker);
        UserData.crossIdentity = toParker2['string'];

        await PrefsInstance.setUserIdentity();
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

    await PrefsInstance.setUserIdentity();

    _loginController?.add(false);
  }
}

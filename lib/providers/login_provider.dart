import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/api/prefs_instance.dart';
import 'package:celta_inventario/api/firebase_helper.dart';
import 'package:celta_inventario/api/soap_helper.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:xml2json/xml2json.dart';
import '../utils/default_error_message_to_find_server.dart';

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

    if (_changedEnterpriseNameOrUrlCcs || UserData.urlCCS == "") {
      _errorMessage =
          await FirebaseHelper.getUrlFromFirebaseAndReturnErrorIfHas(
        enterpriseNameOrUrlCCSController.text,
      );
    }

    if (_errorMessage != "" &&
        !ConvertString.isUrl(
          enterpriseNameOrUrlCCSController.text,
        )) {
      ShowSnackbarMessage.showMessage(
        message:
            "A empresa não foi encontrada no banco de dados. Entre em contato com o suporte e solicite a URL do CCS para fazer o login",
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

        _loginController?.add(true);

        await PrefsInstance.setUserIdentity();
        await PrefsInstance.setUrlCcsAndEnterpriseName();
        await FirebaseHelper.addCcsClientInFirebase();
      }
    } catch (e) {
      // _updateErrorMessage(e.toString());
      print('deu erro no login: $e');
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
    UserData.urlCCS = "";

    await PrefsInstance.setUserIdentity();
    await PrefsInstance.setUrlCcsAndEnterpriseName();

    _loginController?.add(false);
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/firebase_helper.dart';
import 'package:celta_inventario/utils/soap_helper.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';
import '../utils/default_error_message_to_find_server.dart';
import '../Components/Global_widgets/show_error_message.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController enterpriseNameOrCCSUrlController =
      TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  static MultiStreamController<bool>? _loginController;
  //esse stream está sendo usado no AuthOrHomePage
  //quando da certo o login, ele adiciona o _isAuth no controller
  static final _isAuthStream = Stream<bool>.multi((controller) {
    _loginController = controller;
  });

  Stream<bool> get authStream {
    return _isAuthStream;
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.getString('user') != "" ||
        await prefs.getString('user') != null) {
      return await prefs.getString('user')!;
    } else {
      return "";
    }
  }

  Future<void> logoutIfIsNecessary() async {
    //como está mudando as URLs para utilizar via CCS, TODOS usuários precisam
    //fazer o login novamente. Então, se já estiver logado após atualizar o
    //aplicativo, precisa deslogar pra obrigar que ele logue novamente
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.getString('needLogout') == "" ||
        await prefs.getString('needLogout') == null) {
      await prefs.setString('needLogout', "false");
      await prefs.setString('userIdentity', "");
      await prefs.remove("url"); //não utiliza mais
      _loginController!.add(false);
      enterpriseNameOrCCSUrlController.clear();
    }
  }

  Future<void> verifyIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await prefs.getString('userIdentity') != "" &&
        await prefs.getString('userIdentity') != null &&
        (await prefs.getString('needLogout') == "" ||
            await prefs.getString('needLogout') == null)) {
      UserIdentity.identity = await prefs.getString('userIdentity')!;
      _loginController!.add(true);
    }
  }

  // Future<void> restoreBaseUrl() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (await prefs.getString('ccsUrl') != null &&
  //       await prefs.getString('ccsUrl') != "") {
  //     BaseUrl.ccsUrl = await prefs.getString('ccsUrl')!;
  //   }
  // }

  restoreUserAndEnterpriseNameOrCCSUrl({
    required TextEditingController enterpriseNameOrCCSUrlController,
    required TextEditingController userController,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (await prefs.getString('user') != null) {
      userController.text = await prefs.getString('user')!;
    }

    if (await prefs.getString('enterpriseName') != null &&
        await prefs.getString('enterpriseName') != "") {
      enterpriseNameOrCCSUrlController.text =
          await prefs.getString('enterpriseName')!;
    } else if (await prefs.getString('ccsUrl') != null &&
        await prefs.getString('ccsUrl') != "") {
      BaseUrl.ccsUrl = await prefs.getString('ccsUrl')!;
      enterpriseNameOrCCSUrlController.text = await prefs.getString('ccsUrl')!;
    }
  }

  login({
    required String user,
    required String password,
    required TextEditingController enterpriseNameOrCCSUrlController,
    required BuildContext context,
  }) async {
    _errorMessage = '';
    _isLoading = true;

    notifyListeners();

    _errorMessage = await FirebaseHelper.getUrlFromFirebaseAndReturnErrorIfHas(
      enterpriseNameOrCCSUrlController.text,
    );

    if (_errorMessage != "" &&
        !_isUrl(
          enterpriseNameOrCCSUrlController.text,
        )) {
      ShowErrorMessage.showErrorMessage(
        error:
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
        ShowErrorMessage.showErrorMessage(
          error: _errorMessage,
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
        UserIdentity.identity = toParker2['string'];

        _loginController?.add(true);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userIdentity', UserIdentity.identity);
        await prefs.setString('user', user);

        await FirebaseHelper.addCcsClientInFirebase();
      }
    } catch (e) {
      // _updateErrorMessage(e.toString());
      print('deu erro no login: $e');
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  bool _isUrl(String text) {
    return text.toLowerCase().contains('http') &&
        text.toLowerCase().contains('//') &&
        text.toLowerCase().contains(':') &&
        text.toLowerCase().contains('ccs');
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdentity', "");
    _loginController?.add(false);
  }
}

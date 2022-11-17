import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml2json/xml2json.dart';

import '../utils/base_url.dart';
import '../utils/default_error_message_to_find_server.dart';
import '../utils/show_error_message.dart';

class LoginProvider with ChangeNotifier {
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

  _saveUrlAndUser({
    required String url,
    required String user,
  }) async {
    BaseUrl.url = url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', url);
    await prefs.setString('user', user);
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('user')!;
  }

  Future<void> verifyIsLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userIdentity') != "") {
      UserIdentity.identity = await prefs.getString('userIdentity')!;
      _loginController!.add(true);
    }
  }

  restoreUserAndUrl({
    required TextEditingController urlController,
    required TextEditingController userController,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //logo que instala o app, logicamente ainda não tem nada salvo nas URLs se
    //não fizer essa verificação, vai dar erro no debug console
    if (prefs.getString('url') == null || prefs.getString('user') == null) {
      return;
    }
    BaseUrl.url = prefs.getString('url')!;
    urlController.text = prefs.getString('url')!;
    userController.text = prefs.getString('user')!;
  }

  login({
    required String user,
    required String password,
    required String url,
    required BuildContext context,
  }) async {
    await _saveUrlAndUser(url: url, user: user);
    print(url);
    print(user);
    print(BaseUrl.url);

    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/Security/UserCanLoginPlain?user=$user&password=$password'));

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do login: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];

        ShowErrorMessage.showErrorMessage(
          error: _errorMessage,
          context: context,
        );
        _isLoading = false;

        notifyListeners();
        return;
      }
      List resultAsList = json.decode(resultAsString);
      Map resultAsMap = resultAsList.asMap();

      final myTransformer = Xml2Json();
      myTransformer.parse(resultAsMap[0]['CrossIdentity_Usuario']);
      String toParker = myTransformer.toParker();
      Map toParker2 = json.decode(toParker);
      UserIdentity.identity = toParker2['string'];
      //transformando o XML em String pra pegar a identidade do usuário

      _loginController?.add(
          true); //como deu certo o login, adiciona o valor "true" pra na tela AuthOrHome identificar que está como true e ir para a homePage

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userIdentity', UserIdentity.identity);
    } catch (e) {
      // _updateErrorMessage(e.toString());
      print('deu erro no login: $e');
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
      // notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdentity', "");
    _loginController?.add(false);
  }
}

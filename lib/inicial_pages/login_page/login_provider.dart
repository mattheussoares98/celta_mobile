import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

class LoginProvider with ChangeNotifier {
  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  _updateErrorMessage(String error) {
    if (error.contains('O usuário não foi encontrado')) {
      _errorMessage = 'Usuário não encontrado!';
    } else if (error.contains('senha está incorreta')) {
      _errorMessage = 'O usuário ou a senha está inválido!';
    } else if (error.contains('Connection timed out')) {
      _errorMessage = 'Time out! Tente novamente!';
    } else if (error.contains('Connection')) {
      _errorMessage = 'O servidor não foi encontrado. Verifique a sua internet';
    } else if (error.contains('Software caused connection abort')) {
      _errorMessage = 'Conexão abortada. Tente novamente';
    } else if (error.contains('No host specifie')) {
      _errorMessage = 'URL inválida!';
    } else if (error.contains('Failed host lookup')) {
      _errorMessage = 'URL inválida!';
    } else if (error.contains('FormatException')) {
      _errorMessage = 'URL inválida!';
    } else if (error.contains('Invalid port')) {
      _errorMessage = 'Url inválida!';
    } else if (error.contains('No route')) {
      _errorMessage = 'Servidor não encontrado!';
    } else {
      _errorMessage = 'Servidor indisponível';
    }
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

  login({
    required String? user,
    required String? password,
    required String baseUrl,
  }) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/Security/UserCanLoginPlain?user=$user&password=$password',
        ),
      );

      var responseOfUser = json.decode(response.body);

      //transformando o XML em String pra pegar a identidade do usuário
      final myTransformer = Xml2Json();

      //se não colocar essa condição, a validação do login fica errada porque tenta converter algo nulo
      if (responseOfUser[0] != null) {
        myTransformer.parse(responseOfUser[0]['CrossIdentity_Usuario']);
        String toParker = myTransformer.toParker();
        Map toParker2 = json.decode(toParker);
        UserIdentity.identity = toParker2['string'];
      }

      if (response.statusCode == 200) {
        _loginController?.add(
            true); //como deu certo o login, adiciona o valor "true" pra na tela AuthOrHome identificar que está como true e ir para a homePage
      } else {
        print('Erro no login === ' + response.body);

        _updateErrorMessage(response.body);
      }
    } catch (e) {
      _updateErrorMessage(e.toString());
      print('deu erro no login: $e');
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  logout() {
    _loginController?.add(false);
  }
}

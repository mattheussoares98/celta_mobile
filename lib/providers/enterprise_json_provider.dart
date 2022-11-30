import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/enterprise_models/enterprise_json_model.dart';
import '../utils/base_url.dart';
import '../utils/default_error_message_to_find_server.dart';
import '../utils/user_identity.dart';

//retorna parâmetros diferentes do que é retornado no EnterpriseProvider, por
//isso criei outro provider. Essas informações diferentes são utilizadas para o
//pedido de vendas

class EnterpriseJsonProvider with ChangeNotifier {
  List<EnterpriseJsonModel> _enterprises = [];
  List<EnterpriseJsonModel> get enterprises => [..._enterprises];

  int get enterpriseCount => _enterprises.length;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  static bool _isLoadingEnterprises = false;
  bool get isLoadingEnterprises => _isLoadingEnterprises;

  Future getEnterprises({
    required BuildContext context,
  }) async {
    if (_isLoadingEnterprises) {
      return;
    }
    _enterprises.clear();
    _errorMessage = '';
    _isLoadingEnterprises = true;
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '${BaseUrl.url}/Enterprise/GetEnterprisesJson',
        ),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];
        _isLoadingEnterprises = false;

        notifyListeners();
        return;
      }

      EnterpriseJsonModel.resultAsStringToEnterpriseJsonModel(
        resultAsString: resultAsString,
        listToAdd: _enterprises,
      );
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingEnterprises = false;
    }

    notifyListeners();
  }
}

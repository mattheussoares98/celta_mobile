import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../Models/enterprise_model.dart';

class EnterpriseProvider with ChangeNotifier {
  List<EnterpriseModel> _enterprises = [];

  List<EnterpriseModel> get enterprises {
    return [..._enterprises];
  }

  int get enterpriseCount {
    return _enterprises.length;
  }

  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  static bool _isLoadingEnterprises = false;

  bool get isLoadingEnterprises {
    return _isLoadingEnterprises;
  }

  Future getEnterprises({
    required BuildContext context,
  }) async {
    _enterprises.clear();
    _errorMessage = '';
    _isLoadingEnterprises = true;
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${BaseUrl.url}/Enterprise/GetEnterprises'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];
        _isLoadingEnterprises = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorMessage,
          context: context,
        );
        notifyListeners();
        return;
      }

      EnterpriseModel.resultAsStringToEnterpriseModel(
        resultAsString: resultAsString,
        listToAdd: _enterprises,
      );
    } catch (e) {
      print('erro na empresa: $e');
      _errorMessage =
          "Ocorreu um erro não esperado durante a operação. Verifique a sua internet e caso ela esteja funcionando, entre em contato com o suporte";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
    } finally {
      _isLoadingEnterprises = false;
    }

    notifyListeners();
  }
}

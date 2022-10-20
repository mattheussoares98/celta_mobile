import 'package:celta_inventario/procedures/receipt_prodecure/models/enterprise_receipt_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EnterpriseReceiptProvider with ChangeNotifier {
  List<EnterpriseReceiptModel> _enterprises = [];

  List<EnterpriseReceiptModel> get enterprises {
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

  Future<void> getEnterprises({
    String? userIdentity,
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
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      if (_hasError(resultAsString)) {
        return;
      }

      print("resultAsString: ${resultAsString}");
      List resultAsList = json.decode(resultAsString);
      Map resultAsMap = resultAsList.asMap();

      resultAsMap.forEach((id, data) {
        _enterprises.add(
          EnterpriseReceiptModel(
            codigoInternoEmpresa: data['CodigoInterno_Empresa'],
            codigoEmpresa: data['Codigo_Empresa'],
            nomeEmpresa: data['Nome_Empresa'],
            isMarked: false,
          ),
        );
      });
    } catch (e) {
      print('erro na empresa: $e');
      if (e.toString().contains('No route')) {
        _errorMessage =
            'O servidor não foi encontrado. Verifique a sua internet!';
      } else if (e.toString().contains('Connection timed')) {
        _errorMessage = 'Time out. Tente novamente';
      } else {
        _errorMessage =
            'O servidor não foi encontrado. Verifique a sua internet!';
      }
    } finally {
      _isLoadingEnterprises = false;
    }

    notifyListeners();
  }

  bool _hasError(String resultAsString) {
    if (resultAsString.contains("erro não esperado")) {
      _errorMessage =
          "Ocorreu um erro não esperado durante o acesso ao banco de dados do Celta Business Solutions. Este tipo de problema normalmente está ligado à questões de configuração ou à equivocos de desenvolvimento. Fale com seu administrador de sistema ou com nosso suporte técnico para maiores detalhes.";
      return true;
    } else if (resultAsString.contains(
        "A identidade para o 'Celta BS Cross Services' não é válida")) {
      _errorMessage =
          "A identidade para o 'Celta BS Cross Services' não é válida. Fale com o administrador do seu sistema para resolver o problema.";
      return true;
    } else {
      return false;
    }
  }
}

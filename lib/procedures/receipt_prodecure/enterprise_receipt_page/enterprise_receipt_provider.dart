import 'package:celta_inventario/procedures/receipt_prodecure/models/enterprise_receipt_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
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

  Future<void> getEnterprises() async {
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
        notifyListeners();
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
            cnpj: data['Cnpj_Empresa'],
            isMarked: false,
          ),
        );
      });
    } catch (e) {
      _errorMessage =
          "Ocorreu um erro não esperado durante a operação. Verifique a sua internet e caso ela esteja funcionando, entre em contato com o suporte técnico";
    } finally {
      _isLoadingEnterprises = false;
    }

    notifyListeners();
  }
}

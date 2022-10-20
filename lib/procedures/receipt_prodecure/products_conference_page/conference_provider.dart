import 'dart:convert';

import 'package:celta_inventario/procedures/receipt_prodecure/models/conference_product_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConferenceProvider with ChangeNotifier {
  List<ConferenceProductModel> _products = [];

  get products {
    return _products;
  }

  get productsCount {
    return _products.length;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  String _errorMessage = "";

  get errorMessage {
    return _errorMessage;
  }

  getProducts({
    required int docCode,
  }) async {
    _products.clear();
    _errorMessage = "";
    _isLoading = true;
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProduct?docCode=${docCode}&searchTypeInt=19&searchValue=undefined'),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();

      if (_hasError(resultAsString)) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      List resultAsList = json.decode(resultAsString);
      Map resultAsMap = resultAsList.asMap();

      resultAsMap.forEach((id, data) {
        _products.add(
          ConferenceProductModel(
            Nome_Produto: data["Nome_Produto"],
            FormatedProduct: data["FormatedProduct"],
            CodigoInterno_Produto: data["CodigoInterno_Produto"],
            CodigoInterno_ProEmb: data["CodigoInterno_ProEmb"],
            CodigoPlu_ProEmb: data["CodigoPlu_ProEmb"],
            Codigo_ProEmb: data["Codigo_ProEmb"],
            PackingQuantity: data["PackingQuantity"],
            Quantidade_ProcRecebDocProEmb:
                data["Quantidade_ProcRecebDocProEmb"],
            ReferenciaXml_ProcRecebDocProEmb:
                data["ReferenciaXml_ProcRecebDocProEmb"],
            AllEans: data["AllEans"],
          ),
        );
      });
    } catch (e) {
      _errorMessage = "Erro para consultar os produtos do recebimento";
      print('Erro para consultar os produtos do recebimento: ${e.toString()}');
    }

    _isLoading = false;
    notifyListeners();
  }

  bool _hasError(String responseAsString) {
    if (responseAsString.contains("timeout")) {
      _errorMessage =
          "O Celta Business Solutions enviou uma solicitação ao banco de dados que não respondeu no tempo esperado (timeout). Caso este problema persista, entre em contato com o nosso suporte técnico para que possamos resolvê-lo o mais rápido possível.";
      return true;
    } else if (responseAsString.contains("Nenhum produto foi encontrado")) {
      _errorMessage =
          "Nenhum produto foi encontrado no Celta Business Solutions. Caso você sinta que isto está incorreto, entre em contato com o administrador do seu sistema.";
      return true;
    } else {
      return false;
    }
  }
}

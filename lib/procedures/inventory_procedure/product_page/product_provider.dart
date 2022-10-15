import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];

  List<ProductModel> get products {
    return [..._products];
  }

  bool _isLodingEanOrPlu = false;

  bool get isLodingEanOrPlu {
    return _isLodingEanOrPlu;
  }

  int? codigoInternoEmpresa;
  int? codigoInternoInventario;

  String productErrorMessage = '';

  Future<void> getProductByEan({
    String? ean,
    int? enterpriseCode,
    int? inventoryProcessCode,
    int? inventoryCountingCode,
    String? userIdentity,
  }) async {
    _products.clear();
    productErrorMessage = '';
    _isLodingEanOrPlu = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}//Inventory/GetProductByEan?ean=$ean&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para consulta do EAN = $responseInString');

      //tratando a mensagem de retorno aqui mesmo
      if (responseInString.contains('O produto não foi encontrado')) {
        productErrorMessage =
            'O produto não foi encontrado na contagem do processo de inventário.';
        notifyListeners();
        return;
      } else if (responseInString.contains(
          "Ocorreu um erro durante a tentativa de atender um serviço de integração 'cross'")) {
        productErrorMessage =
            'Ocorreu um erro durante a tentativa de atender um serviço de integração "cross". Fale com seu administrador de sistemas, para resolver o problema.';
        notifyListeners();
        return;
      } else if (responseInString.contains('O EAN informado não é válido')) {
        productErrorMessage = 'O EAN informado não é válido';

        notifyListeners();
        return;
      }

      List responseInList = json.decode(responseInString);
      Map responseInMap = responseInList.asMap();

      responseInMap.forEach((key, value) {
        _products.add(
          ProductModel(
            productName: value['Nome_Produto'],
            codigoInternoProEmb: value['CodigoInterno_ProEmb'],
            plu: value['CodigoPlu_ProEmb'],
            codigoProEmb: value['Codigo_ProEmb'],
            quantidadeInvContProEmb: value['Quantidade_InvContProEmb'] == null
                ? -1
                : value['Quantidade_InvContProEmb'],
            //quando o valor está igual a "null", deixo igual a -1 e trato dessa forma pra não ocorrer erro na soma/subtração
          ),
        );
      });
    } catch (e) {
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
      _isLodingEanOrPlu = false;
      notifyListeners();
    }

    if (products.isNotEmpty) {
      _isLodingEanOrPlu = false;
    }
    notifyListeners();
  }

  getProductByPlu({
    required String? plu,
    required int? enterpriseCode,
    required int? inventoryProcessCode,
    required int? inventoryCountingCode,
    required String? userIdentity,
  }) async {
    _products.clear();
    productErrorMessage = '';
    _isLodingEanOrPlu = true;
    notifyListeners();

    try {
      http.Response response = await http.post(
        Uri.parse(
          '${BaseUrl.url}/Inventory/GetProductByPlu?plu=$plu&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userIdentity),
      );

      var responseInString = response.body;

      print('resposta da solicitação para consultar o PLU = $responseInString');

      if (responseInString.contains('O produto não foi encontrado')) {
        productErrorMessage =
            'O produto não foi encontrado na contagem do processo de inventário.';
        _isLodingEanOrPlu = false;
        notifyListeners();
        return;
      } else if (responseInString
          .contains("tentativa de atender um serviço de integração 'cross'")) {
        productErrorMessage =
            "Ocorreu um erro durante a tentativa de atender um serviço de integração 'cross'";
        _isLodingEanOrPlu = false;
        notifyListeners();
        return;
      }

      List responseInList = json.decode(responseInString);
      Map responseInMap = responseInList.asMap();

      responseInMap.forEach((key, value) {
        _products.add(
          ProductModel(
            productName: value['Nome_Produto'],
            codigoInternoProEmb: value['CodigoInterno_ProEmb'],
            plu: value['CodigoPlu_ProEmb'],
            codigoProEmb: value['Codigo_ProEmb'],
            quantidadeInvContProEmb: value['Quantidade_InvContProEmb'] == null
                ? -1
                : value['Quantidade_InvContProEmb'],
          ),
        );
      });
    } catch (e) {
      print('erro pra obter o produto pelo plu: $e');
      productErrorMessage = 'Servidor não encontrado. Verifique a sua internet';
      _isLodingEanOrPlu = false;
      notifyListeners();
    }
    _isLodingEanOrPlu = false;
    notifyListeners();
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }
}

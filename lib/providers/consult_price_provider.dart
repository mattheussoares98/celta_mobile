import 'dart:convert';

import 'package:celta_inventario/Models/consult_price_model.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

enum SearchTypes {
  GetProductByName,
  GetProductByEAN,
  GetProductByPLU,
}

class ConsultPriceProvider with ChangeNotifier {
  List<ConsultPriceProductsModel> _products = [];

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

  String _convertToBrazilianNumber(String valueInString) {
    int lastindex = valueInString.lastIndexOf("\.");

    // print(lastindex.toString());

    valueInString = valueInString.replaceRange(lastindex, lastindex + 1, ',');
    if (lastindex > 4) {
      valueInString = valueInString.replaceFirst(RegExp(r'\,'), '.');
      return valueInString;
    } else {
      return valueInString;
    }
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String controllerText, //em string pq vem de um texfFormField
    required SearchTypes searchTypes,
    required BuildContext context,
  }) async {
    _products.clear();
    _errorMessage = "";
    _isLoading = true;
    String searchType =
        searchTypes.toString().replaceAll(RegExp(r'SearchTypes.'), '');
    notifyListeners();
    dynamic value = int.tryParse(controllerText);
    //o valor pode ser em inteiro ou em texto
    if (value == null) {
      //retorna nulo quando não consegue converter para inteiro. Se não
      //conseguir converter precisa consultar por nome, por isso pode usar o
      //próprio texto do "controllerText"
      value = controllerText;
    }

    var headers = {'Content-Type': 'application/json'};
    // print(searchType);
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/PriceConference/$searchType?enterpriseCode=$enterpriseCode&searchValue=$value'));
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do $searchType: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];
        _isLoading = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorSendToPrint,
          context: context,
        );
        notifyListeners();
        return;
      }

      ConsultPriceProductsModel.resultAsStringToConsultPriceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );

      _products.forEach((element) {
        element.SalePracticedRetail =
            _convertToBrazilianNumber(element.SalePracticedRetail.toString());
        element.CurrentStock =
            _convertToBrazilianNumber(element.CurrentStock.toString());
      });
    } catch (e) {
      print(e);
      _errorMessage =
          "Ocorreu um erro não esperado durante a operação. Verifique a sua internet e caso ela esteja funcionando, entre em contato com o suporte";
      ShowErrorMessage.showErrorMessage(
        error: _errorSendToPrint,
        context: context,
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getProductByPluEanOrName({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
  }) async {
    int? isInt = int.tryParse(controllerText);
    if (isInt != null) {
      //só faz a consulta por ean ou plu se conseguir converter o texto para inteiro
      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByPLU,
        context: context,
      );
      if (_products.isNotEmpty) return;

      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByEAN,
        context: context,
      );
      if (_products.isNotEmpty) return;
    } else {
      //só consulta por nome se não conseguir converter o valor para inteiro, pois se for inteiro só pode ser ean ou plu
      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByName,
        context: context,
      );
    }

    notifyListeners();
  }

  bool _isSendingToPrint = false;

  bool get isSendingToPrint => _isSendingToPrint;

  String _errorSendToPrint = "";

  String get errorSendToPrint => _errorSendToPrint;

  Future<void> sendToPrint({
    required int enterpriseCode,
    required int productPackingCode,
    required int index,
    required BuildContext context,
  }) async {
    _isSendingToPrint = true;
    _errorSendToPrint = "";
    notifyListeners();
    bool newValue = !_products[index].EtiquetaPendente;

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/PriceConference/SendToPrint?enterpriseCode=$enterpriseCode' +
                '&productPackingCode=$productPackingCode&send=$newValue'));
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString marcar para impressão: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];
        _isLoading = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorSendToPrint,
          context: context,
        );
        notifyListeners();
        return;
      }

      if (_products[index].EtiquetaPendenteDescricao == "Sim") {
        _products[index].EtiquetaPendenteDescricao = "Não";
      } else {
        _products[index].EtiquetaPendenteDescricao = "Sim";
      }
      //caso dê certo a alteração, vai alterar o valor localmente para o usuário
      //saber que deu certo a requisição
    } catch (e) {
      print("Erro para alterar o status da impressão");
      _errorSendToPrint =
          "Ocorreu um erro não esperado durante a operação. Verifique a sua internet e caso ela esteja funcionando, entre em contato com o suporte";
      ShowErrorMessage.showErrorMessage(
        error: _errorSendToPrint,
        context: context,
      );
    } finally {
      _isSendingToPrint = false;
      notifyListeners();
    }
  }

  orderByUpPrice() {
    _products
        .sort((a, b) => a.SalePracticedRetail.compareTo(b.SalePracticedRetail));
    notifyListeners();
  }

  orderByDownPrice() {
    _products
        .sort((a, b) => b.SalePracticedRetail.compareTo(a.SalePracticedRetail));
    notifyListeners();
  }

  orderByUpName() {
    _products.sort((a, b) => a.ProductName.compareTo(b.ProductName));

    notifyListeners();
  }

  orderByDownName() {
    _products.sort((a, b) => b.ProductName.compareTo(a.ProductName));
    notifyListeners();
  }
}

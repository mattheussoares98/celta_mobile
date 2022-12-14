import 'dart:convert';

import 'package:celta_inventario/Models/consult_price_model.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';

enum SearchTypes {
  GetProductByName,
  GetProductByEAN,
  GetProductByPLU,
  GetProductByLegacyCode,
}

class PriceConferenceProvider with ChangeNotifier {
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

  clearProducts() {
    _products.clear();
    notifyListeners();
  }

  changeFocusToConsultProduct({required BuildContext context}) {
    FocusScope.of(context).requestFocus(consultProductFocusNode);
  }

  String _convertToBrazilianNumber(String valueInString) {
    int lastIndex = valueInString.lastIndexOf("\.");

    //se não houver pontuação, vai resultar em -1
    if (lastIndex != -1) {
      valueInString = valueInString.replaceRange(lastIndex, lastIndex + 1, ',');
    }
    if (lastIndex > 4) {
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

        notifyListeners();
        return;
      }

      ConsultPriceProductsModel.resultAsStringToConsultPriceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );

      _products.forEach((element) {
        element.CurrentStock =
            _convertToBrazilianNumber(element.CurrentStock.toString());
        element.SalePracticedRetail =
            _convertToBrazilianNumber(element.SalePracticedRetail.toString());
      });
    } catch (e) {
      print("Erro para efetuar a requisição $searchType: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoading = false;
    notifyListeners();
  }

  final consultProductFocusNode = FocusNode();

  Future<void> getProductByPluEanOrName({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    if (isLegacyCodeSearch) {
      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByLegacyCode,
        context: context,
      );
    } else {
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
          // consultProductFocusNode: consultProductFocusNode,
          enterpriseCode: enterpriseCode,
          controllerText: controllerText,
          searchTypes: SearchTypes.GetProductByName,
          context: context,
        );
      }
    }

    if (_errorMessage != "") {
      //quando da erro para consultar os produtos, muda o foco novamente para o
      //campo de pesquisa dos produtos
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
      // ShowErrorMessage.showErrorMessage(
      //   error: _errorMessage,
      //   context: context,
      // );
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

      _products[index].EtiquetaPendente = !_products[index].EtiquetaPendente;
      //como deu certo a marcação/desmarcação, precisa atualizar na lista local se está marcado ou não
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorSendToPrint = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
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
    //precisei fazer esse foreach para converter a string para um double e conseguir ordenar corretamente os preços. Depois da ordenação, aí converto novamente para uma String
    _products.forEach((element) {
      element.SalePracticedRetail =
          element.SalePracticedRetail.replaceAll(RegExp(r','), '.');

      element.SalePracticedRetail =
          double.tryParse(element.SalePracticedRetail);
    });

    _products
        .sort((a, b) => a.SalePracticedRetail.compareTo(b.SalePracticedRetail));

    _products.forEach((element) {
      element.SalePracticedRetail =
          element.SalePracticedRetail.toString().replaceAll(RegExp(r'\.'), ',');
    });
    notifyListeners();
  }

  orderByDownPrice() {
    _products.forEach((element) {
      element.SalePracticedRetail =
          element.SalePracticedRetail.replaceAll(RegExp(r','), '.');

      element.SalePracticedRetail =
          double.tryParse(element.SalePracticedRetail);
    });
    _products
        .sort((a, b) => b.SalePracticedRetail.compareTo(a.SalePracticedRetail));

    _products.forEach((element) {
      element.SalePracticedRetail =
          element.SalePracticedRetail.toString().replaceAll(RegExp(r'\.'), ',');
    });
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

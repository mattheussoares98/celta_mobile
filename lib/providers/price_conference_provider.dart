import 'dart:convert';
import 'package:celta_inventario/Models/consult_price_model.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../utils/base_url.dart';
import '../utils/convert_string.dart';

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

  convertSalePracticedRetailToDouble() {
    _products.forEach((element) {
      element.SalePracticedRetail =
          element.SalePracticedRetail.toString().replaceAll(RegExp(r','), '.');

      int pointQuantity =
          ".".allMatches(element.SalePracticedRetail.toString()).length;
      for (var x = 1; x < pointQuantity; x++) {
        if (x < pointQuantity && pointQuantity > 1) {
          element.SalePracticedRetail = element.SalePracticedRetail.toString()
              .replaceFirst(RegExp(r'\.'), '');
        }
      }

      element.SalePracticedRetail =
          double.tryParse(element.SalePracticedRetail);
    });
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }

  changeFocusToConsultProduct({required BuildContext context}) {
    FocusScope.of(context).requestFocus(consultProductFocusNode);
  }

  Future<void> _getProductsOld({
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
    } catch (e) {
      print("Erro para efetuar a requisição $searchType: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getProductByPluEanOrName({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    if (isLegacyCodeSearch) {
      await _getProductsOld(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByLegacyCode,
        context: context,
      );
    } else {
      int? isInt = int.tryParse(controllerText);
      if (isInt != null) {
        //só faz a consulta por ean ou plu se conseguir converter o texto para inteiro
        await _getProductsOld(
          enterpriseCode: enterpriseCode,
          controllerText: controllerText,
          searchTypes: SearchTypes.GetProductByPLU,
          context: context,
        );
        if (_products.isNotEmpty) return;

        await _getProductsOld(
          enterpriseCode: enterpriseCode,
          controllerText: controllerText,
          searchTypes: SearchTypes.GetProductByEAN,
          context: context,
        );
        if (_products.isNotEmpty) return;
      } else {
        //só consulta por nome se não conseguir converter o valor para inteiro, pois se for inteiro só pode ser ean ou plu
        await _getProductsOld(
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

  Future<void> _getProducts({
    required int enterpriseCode,
    required String controllerText, //em string pq vem de um texfFormField
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    _products.clear();
    _errorMessage = "";
    _isLoading = true;
    controllerText =
        ConvertString.convertToRemoveSpecialCaracters(controllerText);
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
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/PriceConference/GetProduct?enterpriseCode=$enterpriseCode&searchValue=${value}'));
    if (isLegacyCodeSearch) {
      request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/PriceConference/GetProductByLegacyCode?enterpriseCode=$enterpriseCode&searchValue=$value'));
    }

    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      if (isLegacyCodeSearch) {
        print("resultAsString consultando por código legado $resultAsString");
      } else {
        print(
            "resultAsString consultando SEM SER por código legado $resultAsString");
      }

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
    } catch (e) {
      print("Erro para efetuar a requisição : $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoading = false;
    notifyListeners();
  }

  final consultProductFocusNode = FocusNode();

  Future<void> getProduct({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    await _getProducts(
      enterpriseCode: enterpriseCode,
      controllerText: controllerText,
      context: context,
      isLegacyCodeSearch: isLegacyCodeSearch,
    );
    if (_products.isEmpty && _errorMessage != "") {
      await getProductByPluEanOrName(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        context: context,
        isLegacyCodeSearch: isLegacyCodeSearch,
      );
    }

    if (_errorMessage != "") {
      //quando da erro para consultar os produtos, muda o foco novamente para o
      //campo de pesquisa dos produtos
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
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
        _errorSendToPrint = json.decode(resultAsString)["Message"];
        _isLoading = false;

        notifyListeners();
        return;
      }

      _products[index].EtiquetaPendente = !_products[index].EtiquetaPendente;
      //como deu certo a marcação/desmarcação, precisa atualizar na lista local se está marcado ou não
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorSendToPrint = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isSendingToPrint = false;
      notifyListeners();
    }
  }

  orderByUpPrice() {
    convertSalePracticedRetailToDouble();
    _products
        .sort((a, b) => a.SalePracticedRetail.compareTo(b.SalePracticedRetail));

    notifyListeners();
  }

  orderByDownPrice() {
    convertSalePracticedRetailToDouble();

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

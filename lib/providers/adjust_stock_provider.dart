import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_justification_model.dart';
import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_product_model.dart';
import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_type_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

enum SearchTypes {
  GetProductByName,
  GetProductByEAN,
  GetProductByPLU,
}

class AdjustStockProvider with ChangeNotifier {
  List<AdjustStockProductModel> _products = [];

  List<AdjustStockProductModel> get products => _products;

  List<AdjustStockTypeModel> _stockTypes = [];

  List<AdjustStockTypeModel> get stockTypes => _stockTypes;

  List<AdjustStockJustificationModel> _justifications = [];

  List<AdjustStockJustificationModel> get justifications => _justifications;

  int get productsCount {
    return _products.length;
  }

  int get justificationsCount {
    return _justifications.length;
  }

  int get stockTypesCount {
    return _stockTypes.length;
  }

  String _errorMessageGetProducts = '';

  String get errorMessageGetProducts {
    return _errorMessageGetProducts;
  }

  static bool _isLoadingProducts = false;

  bool get isLoadingProducts {
    return _isLoadingProducts;
  }

  String _errorMessageTypeStockAndJustifications = '';

  String get errorMessageTypeStockAndJustifications {
    return _errorMessageTypeStockAndJustifications;
  }

  String _errorMessageAdjustStock = '';

  String _lastUpdatedQuantity = "";
  String _indexOfLastProductChangedStockQuantity = "";

  String get lastUpdatedQuantity => _lastUpdatedQuantity;
  String get indexOfLastProductChangedStockQuantity =>
      _indexOfLastProductChangedStockQuantity;

  String get errorMessageAdjustStock {
    return _errorMessageAdjustStock;
  }

  static bool _isLoadingAdjustStock = false;

  bool get isLoadingAdjustStock {
    return _isLoadingAdjustStock;
  }

  static bool _isLoadingTypeStockAndJustifications = false;

  bool get isLoadingTypeStockAndJustifications {
    return _isLoadingTypeStockAndJustifications;
  }

  var consultProductFocusNode = FocusNode();
  var consultedProductFocusNode = FocusNode();

  Map<String, String> jsonAdjustStock = {
    "EnterpriseCode": "", //esse parâmetro vem da tela de empresas
    "ProductCode": "", //quando clica no produto, altera o código
    "ProductPackingCode": "", //quando clica no produto, altera o código
    "JustificationCode":
        "", //sempre que seleciona a opção do dropdown altera o valor aqui
    "StockTypeCode":
        "", //sempre que seleciona a opção do dropdown altera o valor aqui
    "Quantity":
        "" //quando clica em "alterar", valida se a quantidade é válida e se os dropdowns do estoque e justificativa estão selecionados. Caso esteja tudo certo, altera a quantidade do json de acordo com o que o usuário digitou
  };

  clearProductsJustificationsStockTypesAndJsonAdjustStock() {
    _justifications.clear();
    _stockTypes.clear();
    _products.clear();
    jsonAdjustStock.clear();
    _lastUpdatedQuantity = "";
    _indexOfLastProductChangedStockQuantity = "";
    notifyListeners();
  }

  updateProduct(AdjustStockProductModel currentProduct) {
    _products.clear();
    _products.add(currentProduct);
    notifyListeners();
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String controllerText, //em string pq vem de um texfFormField
    required SearchTypes searchTypes,
    required BuildContext context,
    // required FocusNode consultProductFocusNode,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
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

    try {
      var headers = {'Content-Type': 'application/json'};
      // print(searchType);
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/AdjustStock/$searchType?enterpriseCode=$enterpriseCode&searchValue=$value'));

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do $searchType: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(resultAsString)["Message"];
        _isLoadingProducts = false;

        notifyListeners();
        return;
      }

      AdjustStockProductModel.resultAsStringToAdjustStockProductModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      print("Erro para efetuar a requisição $searchType: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> getProductByPluEanOrName({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    // required FocusNode consultProductFocusNode,
  }) async {
    _lastUpdatedQuantity = "";
    _indexOfLastProductChangedStockQuantity = "";

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
    if (_errorMessageGetProducts != "") {
      //quando da erro para consultar os produtos, muda o foco novamente para o
      //campo de pesquisa dos produtos
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageGetProducts,
        context: context,
      );
    }

    notifyListeners();
  }

  _getStockType() async {
    _stockTypes.clear();
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/AdjustStock/GetStockTypes?simpleSearchValue=undefined'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do stockType: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageTypeStockAndJustifications =
            json.decode(resultAsString)["Message"];
        _isLoadingTypeStockAndJustifications = false;

        notifyListeners();
        return;
      }

      AdjustStockTypeModel.resultAsStringToAdjustStockTypeModel(
        resultAsString: resultAsString,
        listToAdd: _stockTypes,
      );
    } catch (e) {
      print("Erro para efetuar a requisição stockTypes: $e");
      _errorMessageTypeStockAndJustifications =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    notifyListeners();
  }

  _getJustificationsType() async {
    _justifications.clear();
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/AdjustStock/GetJustifications?simpleSearchValue=undefined'));

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do justifications: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageTypeStockAndJustifications =
            json.decode(resultAsString)["Message"];
        _isLoadingTypeStockAndJustifications = false;

        notifyListeners();
        return;
      }

      AdjustStockJustificationModel
          .resultAsStringToAdjustStockJustificationModel(
        resultAsString: resultAsString,
        listToAdd: _justifications,
      );
    } catch (e) {
      print("Erro para efetuar a requisição justifications: $e");
      _errorMessageTypeStockAndJustifications =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    notifyListeners();
  }

  getStockTypeAndJustifications(BuildContext context) async {
    _isLoadingTypeStockAndJustifications = true;
    _errorMessageTypeStockAndJustifications = "";

    await _getStockType();
    if (_errorMessageTypeStockAndJustifications != "") {
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageTypeStockAndJustifications,
        context: context,
      );
      _isLoadingTypeStockAndJustifications = false;
      notifyListeners();
      return;
    }
    await _getJustificationsType();

    if (_errorMessageTypeStockAndJustifications != "") {
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageTypeStockAndJustifications,
        context: context,
      );
    }

    _isLoadingTypeStockAndJustifications = false;
    notifyListeners();
  }

  confirmAdjustStock({
    required BuildContext context,
    required String indexOfProduct,
  }) async {
    _isLoadingAdjustStock = true;
    _errorMessageAdjustStock = "";
    notifyListeners();

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse(
        '${BaseUrl.url}/AdjustStock/ConfirmAdjustStock?jsonAdjustStock=$jsonAdjustStock',
      ),
    );
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      print("resultAsString consulta do justifications: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageAdjustStock = json.decode(resultAsString)["Message"];

        ShowErrorMessage.showErrorMessage(
          error: _errorMessageAdjustStock,
          context: context,
        );
        _isLoadingAdjustStock = false;
        notifyListeners();
        return;
      }

      _lastUpdatedQuantity = jsonAdjustStock["Quantity"]!;
      _indexOfLastProductChangedStockQuantity = indexOfProduct;
    } catch (e) {
      print("Erro para efetuar a requisição justifications: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }

    _isLoadingAdjustStock = false;
    notifyListeners();
  }
}

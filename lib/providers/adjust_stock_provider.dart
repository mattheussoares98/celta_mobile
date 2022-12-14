import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_justification_model.dart';
import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_product_model.dart';
import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_type_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
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
  int _indexOfLastProductChangedStockQuantity =
      -1; //index do último produto alterado. Serve para só exibir a mensagem da última quantidade alterada no produto correto

  String stockTypeName =
      ""; //quando clica no tipo de estoque altera o valor da variável. É utilizado pra se for o estoque atual, já atualizar no produto consultado
  String typeOperator =
      ""; //quando clica na opção de justificativa, obtém o tipo de operador "-" ou "+". Isso é usado pra atualizar o estoque do produto consultado após confirmar a alteração

  String get lastUpdatedQuantity => _lastUpdatedQuantity;
  int get indexOfLastProductChangedStockQuantity =>
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

  bool _justificationHasStockType = false;
  bool get justificationHasStockType => _justificationHasStockType;
  set justificationHasStockType(bool value) {
    _justificationHasStockType = value;
    notifyListeners();
  }

  Map<String, dynamic> jsonAdjustStock = {
    "EnterpriseCode": "", //esse parâmetro vem da tela de empresas
    "ProductCode": "", //quando clica no produto, altera o código
    "ProductPackingCode": "", //quando clica no produto, altera o código
    "JustificationCode":
        "", //sempre que seleciona a opção do dropdown altera o valor aqui
    "StockTypeCode":
        0, //sempre que seleciona a opção do dropdown altera o valor aqui
    "Quantity":
        "" //quando clica em "alterar", valida se a quantidade é válida e se os dropdowns do estoque e justificativa estão selecionados. Caso esteja tudo certo, altera a quantidade do json de acordo com o que o usuário digitou
  };

  _updateCurrentStock({
    required int index,
    required String consultedProductControllerText,
  }) {
    double currentStockInDouble = double.tryParse(_products[index]
        .CurrentStock
        .replaceAll(RegExp(r'\.'), '')
        .replaceAll(RegExp(r'\,'), '.'))!;

    double saldoEstoqueVendaInDouble = double.tryParse(_products[index]
        .SaldoEstoqueVenda
        .replaceAll(RegExp(r'\.'), '')
        .replaceAll(RegExp(r'\,'), '.'))!;

    dynamic newCurrentStock;
    dynamic newSaldoEstoqueVenda;

    if (typeOperator.contains("+")) {
      newCurrentStock = currentStockInDouble +
          double.tryParse(consultedProductControllerText)!;

      newSaldoEstoqueVenda = saldoEstoqueVendaInDouble +
          double.tryParse(consultedProductControllerText)!;
    } else {
      newCurrentStock = currentStockInDouble -
          double.tryParse(consultedProductControllerText)!;
      newSaldoEstoqueVenda = currentStockInDouble -
          double.tryParse(consultedProductControllerText)!;
    }

    print(stockTypeName.toLowerCase());
    if (stockTypeName.toLowerCase() == "estoque atual") {
      newCurrentStock =
          newCurrentStock.toStringAsFixed(3).replaceAll(RegExp(r'\.'), ',');
      newSaldoEstoqueVenda = newSaldoEstoqueVenda
          .toStringAsFixed(3)
          .replaceAll(RegExp(r'\.'), ',');

      AdjustStockProductModel newProduct = AdjustStockProductModel(
        CurrentStock: newCurrentStock.toString(),
        SaldoEstoqueVenda: newSaldoEstoqueVenda.toString(),
        ProductCode: _products[index].ProductCode,
        ProductPackingCode: _products[index].ProductPackingCode,
        PriceLookUp: _products[index].PriceLookUp,
        ProductName: _products[index].ProductName,
        CodigoPlu_ProEmb: _products[index].CodigoPlu_ProEmb,
        Nome_Produto: _products[index].Nome_Produto,
        Packing: _products[index].Packing,
        PackingQuantity: _products[index].PackingQuantity,
        Name: _products[index].Name,
        ReducedName: _products[index].ReducedName,
        PersonalizedCode: _products[index].PersonalizedCode,
        AllowTransfer: _products[index].AllowTransfer,
        AllowSale: _products[index].AllowSale,
        AllowBuy: _products[index].AllowBuy,
        MinimumWholeQuantity: _products[index].MinimumWholeQuantity,
        SalePracticedRetail: _products[index].SalePracticedRetail,
        SalePracticedWholeSale: _products[index].SalePracticedWholeSale,
        OperationalCost: _products[index].OperationalCost,
        ReplacementCost: _products[index].ReplacementCost,
        ReplacementCostMidle: _products[index].ReplacementCostMidle,
        LiquidCost: _products[index].LiquidCost,
        LiquidCostMidle: _products[index].LiquidCostMidle,
        RealCost: _products[index].RealCost,
        RealLiquidCost: _products[index].RealLiquidCost,
        FiscalCost: _products[index].FiscalCost,
        FiscalLiquidCost: _products[index].FiscalLiquidCost,
        CurrentStockString: _products[index].CurrentStockString,
        EtiquetaPendente: _products[index].EtiquetaPendente,
        EtiquetaPendenteDescricao: _products[index].EtiquetaPendenteDescricao,
      );
      _products[index] = newProduct;
    }
  }

  clearProductsJustificationsStockTypesAndJsonAdjustStock() {
    _justifications.clear();
    _stockTypes.clear();
    _products.clear();
    jsonAdjustStock.clear();
    _lastUpdatedQuantity = "";
    _indexOfLastProductChangedStockQuantity = -1;
    _justificationHasStockType = false;
    notifyListeners();
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String controllerText, //em string pq vem de um texfFormField
    required SearchTypes searchTypes,
    required BuildContext context,
    // required FocusNode consultProductFocusNode,
  }) async {
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
    _indexOfLastProductChangedStockQuantity = -1;
    _products.clear();
    notifyListeners();

    int? isInt = int.tryParse(controllerText);

    if (!_isLoadingTypeStockAndJustifications) {
      //logo que entra na tela de consulta de produtos, já começa a consultar os
      //tipos de estoque e justificativas. Se ainda estiver consultando e
      //colocar pra consultar os produtos, vai tentar consultar novamente os
      //tipos de estoque e justificativas
      _getStockTypeAndJustifications(context);
    }
    if (isInt != null) {
      //só faz a consulta por ean ou plu se conseguir converter o texto para inteiro
      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByPLU,
        context: context,
      );
      _justificationHasStockType = false;
      if (_products.isNotEmpty) return;

      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByEAN,
        context: context,
      );
      _justificationHasStockType = false;
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
      // ShowErrorMessage.showErrorMessage(
      //   error: _errorMessageGetProducts,
      //   context: context,
      // );
    }

    _justificationHasStockType = false;
    notifyListeners();
  }

  _getStockType() async {
    _stockTypes.clear();
    notifyListeners();
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
    notifyListeners();
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

  _getStockTypeAndJustifications(BuildContext context) async {
    _isLoadingTypeStockAndJustifications = true;
    _errorMessageTypeStockAndJustifications = "";
    notifyListeners();

    await _getStockType();

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
    required int indexOfProduct,
    required String consultedProductControllerText,
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

      print("resultAsString consulta do ConfirmAdjustStock: $resultAsString");

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

      _updateCurrentStock(
        index: indexOfProduct,
        consultedProductControllerText: consultedProductControllerText,
      );

      typeOperator = typeOperator
          .replaceAll(RegExp(r'\('), '')
          .replaceAll(RegExp(r'\)'), '');
      _lastUpdatedQuantity = typeOperator + jsonAdjustStock["Quantity"]!;
      _indexOfLastProductChangedStockQuantity = indexOfProduct;
    } catch (e) {
      print("Erro para efetuar a requisição justifications: $e");
      _errorMessageAdjustStock = DefaultErrorMessageToFindServer.ERROR_MESSAGE;

      ShowErrorMessage.showErrorMessage(
        error: _errorMessageAdjustStock,
        context: context,
      );
    }

    _isLoadingAdjustStock = false;
    notifyListeners();
  }
}

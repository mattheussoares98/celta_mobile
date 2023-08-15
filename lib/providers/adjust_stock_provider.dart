import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_justification_model.dart';
import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_product_model.dart';
import 'package:celta_inventario/Models/adjust_stock_models/adjust_stock_type_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/utils/soap_helper.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AdjustStockProvider with ChangeNotifier {
  List<AdjustStockProductModel> _products = [];
  List<AdjustStockProductModel> get products => _products;

  List<AdjustStockTypeModel> _stockTypes = [];
  List<AdjustStockTypeModel> get stockTypes => _stockTypes;

  List<AdjustStockJustificationModel> _justifications = [];
  List<AdjustStockJustificationModel> get justifications => _justifications;

  int get productsCount => _products.length;
  int get justificationsCount => _justifications.length;
  int get stockTypesCount => _stockTypes.length;
  String _errorMessageGetProducts = '';

  String get errorMessageGetProducts => _errorMessageGetProducts;
  static bool _isLoadingProducts = false;

  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageTypeStockAndJustifications = '';

  String get errorMessageTypeStockAndJustifications =>
      _errorMessageTypeStockAndJustifications;
  String _errorMessageAdjustStock = '';

  String _justificationStockTypeName = "";
  String get justificationStockTypeName => _justificationStockTypeName;
  updateJustificationStockTypeName(String newValue) {
    _justificationStockTypeName = newValue;
    notifyListeners();
  }

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

  String get errorMessageAdjustStock => _errorMessageAdjustStock;
  static bool _isLoadingAdjustStock = false;

  bool get isLoadingAdjustStock => _isLoadingAdjustStock;
  static bool _isLoadingTypeStockAndJustifications = false;

  bool get isLoadingTypeStockAndJustifications =>
      _isLoadingTypeStockAndJustifications;
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
    _products[index].CurrentStock =
        _products[index].CurrentStock.replaceAll(RegExp(r'\,'), '');
    _products[index].SaldoEstoqueVenda =
        _products[index].SaldoEstoqueVenda.replaceAll(RegExp(r'\,'), '');

    double currentStockInDouble =
        double.tryParse(_products[index].CurrentStock)!;
    double saldoEstoqueVendaInDouble =
        double.tryParse(_products[index].SaldoEstoqueVenda)!;
    double consultedProductControllerInDouble =
        double.tryParse(consultedProductControllerText)!;

    if (typeOperator.contains("+")) {
      _products[index].CurrentStock =
          (currentStockInDouble + consultedProductControllerInDouble)
              .toString();

      _products[index].SaldoEstoqueVenda =
          (saldoEstoqueVendaInDouble + consultedProductControllerInDouble)
              .toString();
    } else {
      _products[index].CurrentStock =
          (currentStockInDouble - consultedProductControllerInDouble)
              .toString();

      _products[index].SaldoEstoqueVenda =
          (currentStockInDouble - consultedProductControllerInDouble)
              .toString();
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
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    _stockTypes.clear();
    _justifications.clear();
    _justificationStockTypeName = "";
    _justificationHasStockType = false;

    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "enterpriseCode": enterpriseCode,
          "searchValue": controllerText,
          "searchTypeInt": isLegacyCodeSearch ? 11 : 0,
        },
        typeOfResponse: "GetProductCmxJsonResponse",
        SOAPAction: "GetProductCmxJson",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductCmxJsonResult",
      );

      _errorMessageGetProducts = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageGetProducts == "") {
        AdjustStockProductModel.dataToAdjustStockProductModel(
          data: SoapHelperResponseParameters.responseAsMap,
          listToAdd: _products,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição na nova forma de consulta: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    _lastUpdatedQuantity = "";
    _indexOfLastProductChangedStockQuantity = -1;
    _products.clear();
    notifyListeners();

    await _getProducts(
      enterpriseCode: enterpriseCode,
      controllerText: controllerText,
      context: context,
      isLegacyCodeSearch: isLegacyCodeSearch,
    );

    if (_products.isNotEmpty) {
      await _getStockTypeAndJustifications(context);
      return;
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

      AdjustStockTypeModel.dataToAdjustStockTypeModel(
        data: resultAsString,
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
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "simpleSearchValue": "",
          "justificationTransferType": 3,
        },
        typeOfResponse: "GetJustificationsResponse",
        SOAPAction: "GetJustifications",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetJustificationsResult",
      );

      _errorMessageTypeStockAndJustifications =
          SoapHelperResponseParameters.errorMessage;

      if (_errorMessageTypeStockAndJustifications == "") {
        AdjustStockJustificationModel
            .resultAsStringToAdjustStockJustificationModel(
          resultAsString: SoapHelperResponseParameters.responseAsString,
          listToAdd: _justifications,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição justifications: $e");
      _errorMessageTypeStockAndJustifications =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    notifyListeners();
  }

  Future<void> _getStockTypeAndJustifications(BuildContext context) async {
    _isLoadingTypeStockAndJustifications = true;
    _errorMessageTypeStockAndJustifications = "";
    _justificationHasStockType = false;
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

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "jsonAdjustStock": jsonAdjustStock,
        },
        typeOfResponse: "ConfirmAdjustStockResponse",
        SOAPAction: "ConfirmAdjustStock",
        serviceASMX: "CeltaProductService.asmx",
      );

      _errorMessageAdjustStock = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageAdjustStock == "") {
        _updateCurrentStock(
          index: indexOfProduct,
          consultedProductControllerText: consultedProductControllerText,
        );

        typeOperator = typeOperator
            .replaceAll(RegExp(r'\('), '')
            .replaceAll(RegExp(r'\)'), '');
        _lastUpdatedQuantity = typeOperator + jsonAdjustStock["Quantity"]!;
        _indexOfLastProductChangedStockQuantity = indexOfProduct;
      }
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

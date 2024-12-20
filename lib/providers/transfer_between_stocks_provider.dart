import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import './providers.dart';

class TransferBetweenStocksProvider with ChangeNotifier {
  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => _products;

  List<GetStockTypesModel> _originStockTypes = [];
  List<GetStockTypesModel> get originStockTypes => _originStockTypes;

  List<GetStockTypesModel> _destinyStockTypes = [];
  List<GetStockTypesModel> get destinyStockTypes => _destinyStockTypes;

  List<GetJustificationsModel> _justifications = [];
  List<GetJustificationsModel> get justifications => _justifications;

  int get productsCount => _products.length;
  int get justificationsCount => _justifications.length;
  int get originStockTypesCount => _originStockTypes.length;
  int get destinyStockTypesCount => _destinyStockTypes.length;
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

  // String originSockTypeName =
  //     ""; //quando clica no tipo de estoque altera o valor da variável. É utilizado pra se for o estoque atual, já atualizar no produto consultado
  // String destinyStockTypeName =
  //     ""; //quando clica no tipo de estoque altera o valor da variável. É utilizado pra se for o estoque atual, já atualizar no produto consultado
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
    "EnterpriseCode": -1, //esse parâmetro vem da tela de empresas
    "ProductCode": -1, //quando clica no produto, altera o código
    "ProductPackingCode": -1, //quando clica no produto, altera o código
    "JustificationCode":
        -1, //sempre que seleciona a opção do dropdown altera o valor aqui
    "StockTypeCode":
        -1, //sempre que seleciona a opção do dropdown altera o valor aqui
    "StockTypeRecipientCode": -1,
    "Quantity":
        -0.1 //quando clica em "alterar", valida se a quantidade é válida e se os dropdowns do estoque e justificativa estão selecionados. Caso esteja tudo certo, altera a quantidade do json de acordo com o que o usuário digitou
  };

  // _updateCurrentStock({
  //   required int index,
  //   required String consultedProductControllerText,
  // }) {
  //   _products[index].Stocks[]
  //   _products[index].CurrentStock =
  //       _products[index].CurrentStock.replaceAll(RegExp(r'\,'), '');
  //   _products[index].SaldoEstoqueVenda =
  //       _products[index].SaldoEstoqueVenda.replaceAll(RegExp(r'\,'), '');

  //   double currentStockInDouble =
  //       double.tryParse(_products[index].CurrentStock)!;
  //   double saldoEstoqueVendaInDouble =
  //       double.tryParse(_products[index].SaldoEstoqueVenda)!;
  //   double consultedProductControllerInDouble =
  //       double.tryParse(consultedProductControllerText)!;

  //   if (typeOperator.contains("+")) {
  //     _products[index].CurrentStock =
  //         (currentStockInDouble + consultedProductControllerInDouble)
  //             .toString();

  //     _products[index].SaldoEstoqueVenda =
  //         (saldoEstoqueVendaInDouble + consultedProductControllerInDouble)
  //             .toString();
  //   } else {
  //     _products[index].CurrentStock =
  //         (currentStockInDouble - consultedProductControllerInDouble)
  //             .toString();

  //     _products[index].SaldoEstoqueVenda =
  //         (currentStockInDouble - consultedProductControllerInDouble)
  //             .toString();
  //   }
  // }

  clearProductsJustificationsStockTypesAndJsonAdjustStock() {
    _justifications.clear();
    _originStockTypes.clear();
    _destinyStockTypes.clear();
    _products.clear();
    jsonAdjustStock.clear();
    _lastUpdatedQuantity = "";
    _indexOfLastProductChangedStockQuantity = -1;
    _justificationHasStockType = false;
    notifyListeners();
  }

  Future<void> _getProducts({
    required EnterpriseModel enterprise,
    required String controllerText, //em string pq vem de um texfFormField
    required BuildContext context,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;

    notifyListeners();

    try {
      await SoapHelper.getProductJsonModel(
        listToAdd: _products,
        enterprise: enterprise,
        searchValue: controllerText,
        configurationsProvider: configurationsProvider,
        routineTypeInt: 4,
      );

      _errorMessageGetProducts = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição na nova forma de consulta: $e");
      _errorMessageGetProducts = DefaultErrorMessage.ERROR;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required EnterpriseModel enterprise,
    required String controllerText,
    required BuildContext context,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _lastUpdatedQuantity = "";
    _indexOfLastProductChangedStockQuantity = -1;
    _products.clear();
    notifyListeners();

    await _getProducts(
      enterprise: enterprise,
      controllerText: controllerText,
      context: context,
      configurationsProvider: configurationsProvider,
    );

    if (_justifications.isEmpty ||
        _destinyStockTypes.isEmpty ||
        _originStockTypes.isEmpty) {
      await getStockTypeAndJustifications(context);
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

  _getStockType(BuildContext context) async {
    _originStockTypes.clear();
    _destinyStockTypes.clear();
    notifyListeners();
    try {
      await SoapHelper.getStockTypesModel(_originStockTypes);
      await SoapHelper.getStockTypesModel(_destinyStockTypes);
      _errorMessageTypeStockAndJustifications =
          SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição stockTypes: $e");
      ShowSnackbarMessage.show(
        message: _errorMessageTypeStockAndJustifications,
        context: context,
      );
    }
    notifyListeners();
  }

  _getJustificationsType(BuildContext context) async {
    _justifications.clear();
    notifyListeners();
    try {
      await SoapHelper.getJustifications(
        justificationTransferType: 1,
        listToAdd: _justifications,
      );

      _errorMessageTypeStockAndJustifications =
          SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição justifications: $e");
      _errorMessageTypeStockAndJustifications = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageTypeStockAndJustifications,
        context: context,
      );
    }
    notifyListeners();
  }

  Future<void> getStockTypeAndJustifications(BuildContext context) async {
    _isLoadingTypeStockAndJustifications = true;
    _errorMessageTypeStockAndJustifications = "";
    _justificationHasStockType = false;
    notifyListeners();

    await _getStockType(context);

    await _getJustificationsType(context);

    if (_errorMessageTypeStockAndJustifications != "") {
      ShowSnackbarMessage.show(
        message: _errorMessageTypeStockAndJustifications,
        context: context,
      );
    }

    _isLoadingTypeStockAndJustifications = false;
    notifyListeners();
  }

  _updateProductCodeAndProductPackingCode(int indexOfProduct) {
    jsonAdjustStock["ProductPackingCode"] =
        _products[indexOfProduct].productPackingCode;
    jsonAdjustStock["ProductCode"] = _products[indexOfProduct].productCode;
  }

  confirmAdjustStock({
    required BuildContext context,
    required int indexOfProduct,
    required String consultedProductControllerText,
  }) async {
    _isLoadingAdjustStock = true;
    _errorMessageAdjustStock = "";
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.transferBetweenStocksConfirmAdjust,
    );

    _updateProductCodeAndProductPackingCode(indexOfProduct);

    try {
      await SoapHelper.confirmAdjustStock(jsonAdjustStock);

      _errorMessageAdjustStock = SoapRequestResponse.errorMessage;

      if (_errorMessageAdjustStock == "") {
        typeOperator = typeOperator
            .replaceAll(RegExp(r'\('), '')
            .replaceAll(RegExp(r'\)'), '');
        _lastUpdatedQuantity = ConvertString.convertToBrazilianNumber(
            jsonAdjustStock["Quantity"]!.toString());
        _indexOfLastProductChangedStockQuantity = indexOfProduct;
      }

      if (SoapRequestResponse.errorMessage != "") {
        ShowSnackbarMessage.show(
          message: _errorMessageAdjustStock,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para confirmar o ajuste: $e");
      _errorMessageAdjustStock = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageAdjustStock,
        context: context,
      );
    }

    _isLoadingAdjustStock = false;
    notifyListeners();
  }
}

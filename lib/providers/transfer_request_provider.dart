import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/transfer_request/transfer_request.dart';
import '../utils/utils.dart';
import './providers.dart';

class TransferRequestProvider with ChangeNotifier {
  String _errorMessageRequestModel = '';
  String get errorMessageRequestModel => _errorMessageRequestModel;
  bool _isLoadingRequestModel = false;
  bool get isLoadingRequestModel => _isLoadingRequestModel;
  List<TransferRequestModel> _requestModels = [];
  List<TransferRequestModel> get requestModels => [..._requestModels];

  void clearRequestModels() {
    _requestModels.clear();
  }

  String _lastSavedTransferRequest = '';
  String get lastSavedTransferRequest => _lastSavedTransferRequest;
  String _errorMessageSaveTransferRequest = '';
  String get errorMessageSaveTransferRequest =>
      _errorMessageSaveTransferRequest;
  bool _isLoadingSaveTransferRequest = false;
  bool get isLoadingSaveTransferRequest => _isLoadingSaveTransferRequest;

  String _errorMessageDestinyEnterprise = '';
  String get errorMessageDestinyEnterprise => _errorMessageDestinyEnterprise;
  bool _isLoadingDestinyEnterprise = false;
  bool get isLoadingDestinyEnterprise => _isLoadingDestinyEnterprise;
  List<TransferRequestEnterpriseModel> _destinyEnterprises = [];
  get destinyEnterprises => [..._destinyEnterprises];
  get destinyEnterprisesCount => _destinyEnterprises.length;

  void clearDestinyEnterprise() {
    _destinyEnterprises.clear();
    notifyListeners();
  }

  String _errorMessageOriginEnterprise = '';
  String get errorMessageOriginEnterprise => _errorMessageOriginEnterprise;
  bool _isLoadingOriginEnterprise = false;
  bool get isLoadingOriginEnterprise => _isLoadingOriginEnterprise;
  List<TransferRequestEnterpriseModel> _originEnterprises = [];
  get originEnterprises => [..._originEnterprises];
  get originEnterprisesCount => _originEnterprises.length;

  void clearOriginEnterprise() {
    _originEnterprises.clear();
    notifyListeners();
  }

  Map<String, dynamic> _jsonSaleRequest = {
    "crossId": UserData.crossIdentity,
    "EnterpriseOriginCode": 0,
    "EnterpriseDestinyCode": 0,
    "RequestTypeCode": 0,
    "Products": [],
  };

  String _errorMessageProducts = '';
  String get errorMessageProducts => _errorMessageProducts;
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  List<TransferRequestProductsModel> _products = [];
  List<TransferRequestProductsModel> get products => [..._products];

  Map<String, Map<String, Map<String, List<TransferRequestCartProductsModel>>>>
      _cartProducts = {};

  List<TransferRequestCartProductsModel> getCartProducts({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    return _cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ??
        [];
  }

  restoreProductRemoved({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .insert(indexOfRemovedProduct!, removedProduct!);

    await _updateCartInDatabase();
    notifyListeners();
  }

  // Map<requestTypeCode, Map<enterpriseOriginCode, Map<enterpriseDestinyCode, List<TransferRequestCartProductsModel>>>>
  int? indexOfRemovedProduct;
  TransferRequestCartProductsModel? removedProduct;

  // getCartProducts({
  //   required String enterpriseOriginCode,
  //   required String enterpriseDestinyCode,
  // }) {
  //   return _cartProducts[enterpriseOriginCode]?[enterpriseDestinyCode] ?? 0;
  // }

  Future<void> removeProductFromCart({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    // removedProduct = _cartProducts[enterpriseCode]!.firstWhere(
    //     (element) => element.ProductPackingCode == ProductPackingCode);

    indexOfRemovedProduct = _cartProducts[requestTypeCode]![
            enterpriseOriginCode]![enterpriseDestinyCode]!
        .indexWhere(
            (element) => element.ProductPackingCode == ProductPackingCode);

    removedProduct = _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .removeAt(indexOfRemovedProduct!);

    // _cartProducts[enterpriseCode]!.removeWhere(
    //     (element) => element.ProductPackingCode == ProductPackingCode);

    await _updateCartInDatabase();

    notifyListeners();
  }

  _updateCartInDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("transferCart");
    await prefs.setString("transferCart", json.encode(_cartProducts));
  }

  void clearProducts() {
    _products.clear();
    notifyListeners();
  }

  double getTotalItensInCart({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    double atualQuantity = 0;

    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .forEach((element) {
        // print(element["ProductPackingCode"]);
        if (element.ProductPackingCode == ProductPackingCode) {
          atualQuantity = element.Quantity;
        }
      });

      return atualQuantity;
    }
  }

  _changeCursorToLastIndex(TextEditingController consultedProductController) {
    consultedProductController.selection = TextSelection.collapsed(
      offset: consultedProductController.text.length,
    );
  }

  bool canShowInsertProductQuantityForm({
    required TransferRequestProductsModel product,
    required int selectedIndex,
    required int index,
  }) {
    if (selectedIndex != index &&
        _products.length == 1 &&
        product.WholePracticedPrice > 0)
      return true;
    else {
      return false;
    }
  }

  bool alreadyContainsProduct({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return false;
    } else {
      return _cartProducts[requestTypeCode]![enterpriseOriginCode]![
                  enterpriseDestinyCode]!
              .indexWhere((element) =>
                  element.ProductPackingCode == ProductPackingCode) !=
          -1;
    }
  }

  Future<void> insertUpdateProductInCart({
    required TransferRequestProductsModel product,
    required TextEditingController quantityController,
    required TextEditingController newPriceController,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    double quantity = quantityController.text.toDouble();

    if (quantity <= 0) {
      quantity = 1;
    }

    late double price;
    if (newPriceController.text.toDouble() > 0) {
      price = newPriceController.text.toDouble();
    } else {
      price = product.Value;
    }

    late double newQuantity;

    int indexInCart = _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .indexWhere((element) =>
            element.ProductPackingCode == product.ProductPackingCode);

    if (indexInCart != -1) {
      newQuantity = quantity +
          _cartProducts[requestTypeCode]![enterpriseOriginCode]![
                  enterpriseDestinyCode]![indexInCart]
              .Quantity;
    } else {
      newQuantity = quantity;
    }

    TransferRequestCartProductsModel cartProductsModel =
        TransferRequestCartProductsModel(
      ProductPackingCode: product.ProductPackingCode,
      Name: product.Name,
      Quantity: newQuantity,
      Value: price,
      IncrementPercentageOrValue: "0.0",
      IncrementValue: 0.0,
      DiscountPercentageOrValue: "0.0",
      DiscountValue: 0.0,
      ExpectedDeliveryDate: "\"${DateTime.now().toString()}\"",
      ProductCode: product.ProductCode,
      PLU: product.PLU,
      PackingQuantity: product.PackingQuantity,
      RetailPracticedPrice: product.RetailPracticedPrice,
      RetailSalePrice: product.RetailSalePrice,
      RetailOfferPrice: product.RetailOfferPrice,
      WholePracticedPrice: product.WholePracticedPrice,
      WholeSalePrice: product.WholeSalePrice,
      WholeOfferPrice: product.WholeOfferPrice,
      ECommercePracticedPrice: product.ECommercePracticedPrice,
      ECommerceSalePrice: product.ECommerceSalePrice,
      ECommerceOfferPrice: product.ECommerceOfferPrice,
      MinimumWholeQuantity: product.MinimumWholeQuantity,
      BalanceStockSale: product.BalanceStockSale,
      StorageAreaAddress: product.StorageAreaAddress,
      StockByEnterpriseAssociateds: product.StockByEnterpriseAssociateds,
    );

    if (indexInCart == -1) {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .add(cartProductsModel);
    } else {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
          enterpriseDestinyCode]![indexInCart] = cartProductsModel;
    }

    quantityController.text = "";

    _changeCursorToLastIndex(quantityController);

    await _updateCartInDatabase();
    notifyListeners();
  }

  double getTotalItemValue({
    required TransferRequestProductsModel product,
    required TextEditingController consultedProductController,
    required TextEditingController newPriceController,
  }) {
    double _quantityToAdd = consultedProductController.text.toDouble();

    if (_quantityToAdd <= 0) {
      _quantityToAdd = 1;
    }

    late double priceValue;
    if (newPriceController.text.toDouble() > 0) {
      priceValue = newPriceController.text.toDouble();
    } else {
      priceValue = product.Value;
    }

    double _totalItemValue = _quantityToAdd * priceValue;

    double? controllerInDouble = double.tryParse(
        consultedProductController.text.replaceAll(RegExp(r'\,'), '.'));

    if (controllerInDouble != null) {
      _quantityToAdd = double.tryParse(
        consultedProductController.text.replaceAll(RegExp(r','), '\.'),
      )!;
    }

    _changeCursorToLastIndex(consultedProductController);

    return _totalItemValue;
  }

  Future<void> restoreProducts({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    final cart = await PrefsInstance.getString(PrefsKeys.transferCart);

    if (cart.isEmpty) {
      _cartProducts.clear();
    } else {
      Map cartProductsInDatabase = jsonDecode(cart);

      List<TransferRequestCartProductsModel> cartProductsTemp = [];

      if (cartProductsInDatabase.isEmpty) {
        return;
      } else if (cartProductsInDatabase[requestTypeCode] == null) {
        return;
      } else if (cartProductsInDatabase[requestTypeCode]
              [enterpriseOriginCode] ==
          null) {
        return;
      } else if (cartProductsInDatabase[requestTypeCode][enterpriseOriginCode]
              [enterpriseDestinyCode] ==
          null) return;

      _cartProducts[requestTypeCode] = {};
      _cartProducts[requestTypeCode]![enterpriseOriginCode] = {};
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
          enterpriseDestinyCode] = [];
      _cartProducts[requestTypeCode]?[enterpriseOriginCode]
          ?[enterpriseDestinyCode] = [];

      //se não fizer essas atribuições, não funciona adicionar os produtos do cartProductsTemp no _cartProducts

      cartProductsInDatabase[requestTypeCode][enterpriseOriginCode]
              [enterpriseDestinyCode]
          .forEach((element) {
        cartProductsTemp
            .add(TransferRequestCartProductsModel.fromJson(element));
        _cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] = cartProductsTemp;
      });
    }

    notifyListeners();
  }

  Future<void> updateProductFromCart({
    required int productPackingCode,
    required double quantity,
    required double value,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
    required int index,
  }) async {
    _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]![index]
        .Quantity = quantity;

    await _updateCartInDatabase();
    notifyListeners();
  }

  Future<void> clearCart({
    required String requestTypeCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
  }) async {
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] !=
        null) {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .clear();
    }

    await _updateCartInDatabase();
    notifyListeners();
  }

  Future<void> getRequestModels({bool isConsultingAgain = false}) async {
    if (_isLoadingRequestModel) return;

    _errorMessageRequestModel = '';
    _isLoadingRequestModel = true;
    _destinyEnterprises.clear();
    clearRequestModels();

    if (isConsultingAgain) notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "simpleSearchValue": "",
          // "enterpriseCode": "int",
          "inclusiveTransfer": true,
          "inclusiveBuy": false,
          "inclusiveSale": false,
        },
        typeOfResponse: "GetRequestTypesJsonResponse",
        SOAPAction: "GetRequestTypesJson",
        serviceASMX: "CeltaRequestTypeService.asmx",
        typeOfResult: "GetRequestTypesJsonResult",
      );

      _errorMessageRequestModel = SoapRequestResponse.errorMessage;

      if (_errorMessageRequestModel == "") {
        _requestModels =
            (json.decode(SoapRequestResponse.responseAsString) as List)
                .map((e) => TransferRequestModel.fromJson(e))
                .toList();
      }
    } catch (e) {
      //print('deu erro para consultar os pedidos: $e');
      _errorMessageRequestModel = DefaultErrorMessage.ERROR;
    }
    _isLoadingRequestModel = false;
    notifyListeners();
  }

  Future<void> getOriginEnterprises({
    required int? requestTypeCode,
    bool isConsultingAgain = false,
  }) async {
    if (_isLoadingOriginEnterprise) return;

    _errorMessageOriginEnterprise = '';
    _isLoadingOriginEnterprise = true;
    _originEnterprises.clear();

    if (isConsultingAgain) notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          // "simpleSearchValue": "string",
          "requestTypeCode": requestTypeCode,
        },
        typeOfResponse: "GetEnterprisesJsonResponse",
        SOAPAction: "GetEnterprisesJson",
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResult: "GetEnterprisesJsonResult",
      );

      _errorMessageOriginEnterprise = SoapRequestResponse.errorMessage;

      if (_errorMessageOriginEnterprise == "") {
        _originEnterprises =
            (json.decode(SoapRequestResponse.responseAsString) as List)
                .map((e) => TransferRequestEnterpriseModel.fromJson(e))
                .toList();
      }
    } catch (e) {
      //print('deu erro para consultar as empresas de origem: $e');
      _errorMessageOriginEnterprise = DefaultErrorMessage.ERROR;
    }
    _isLoadingOriginEnterprise = false;
    notifyListeners();
  }

  int cartProductsCount({
    required String? enterpriseOriginCode,
    required String? enterpriseDestinyCode,
    required String? requestTypeCode,
  }) {
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else if (_cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .isEmpty) {
      return 0;
    } else {
      return _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .length;
    }
  }

  double getTotalCartPrice({
    required String? enterpriseOriginCode,
    required String? enterpriseDestinyCode,
    required String? requestTypeCode,
  }) {
    double total = 0;
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .forEach((element) {
        total += (element.Quantity * element.Value) - element.DiscountValue;
      });

      return total;
    }
  }

  Future<void> getDestinyEnterprises({
    required int? requestTypeCode,
    required int? enterpriseOriginCode,
    bool isConsultingAgain = false,
  }) async {
    _errorMessageDestinyEnterprise = '';
    _isLoadingDestinyEnterprise = true;
    _destinyEnterprises.clear();
    notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          // "simpleSearchValue": "string",
          "requestTypeCode": requestTypeCode,
          "enterpriseOriginCode": enterpriseOriginCode,
        },
        typeOfResponse: "GetEnterprisesDestinyJsonResponse",
        SOAPAction: "GetEnterprisesDestinyJson",
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResult: "GetEnterprisesDestinyJsonResult",
      );

      _errorMessageDestinyEnterprise = SoapRequestResponse.errorMessage;

      if (_errorMessageDestinyEnterprise == "") {
        _destinyEnterprises =
            (json.decode(SoapRequestResponse.responseAsString) as List)
                .map((e) => TransferRequestEnterpriseModel.fromJson(e))
                .toList();
      }
    } catch (e) {
      //print('deu erro para consultar as empresas de destino: $e');
      _errorMessageDestinyEnterprise = DefaultErrorMessage.ERROR;
    } finally {
      _isLoadingDestinyEnterprise = false;
      notifyListeners();
    }
  }

  Future<void> getProducts({
    required String requestTypeCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String value,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _errorMessageProducts = '';
    _isLoadingProducts = true;
    _products.clear();
    notifyListeners();

    try {
      await SoapHelper.getProductTransferRequest(
        enterpriseOriginCode: enterpriseOriginCode.toString(),
        enterpriseDestinyCode: enterpriseDestinyCode.toString(),
        requestTypeCode: requestTypeCode.toString(),
        searchValue: value,
        configurationsProvider: configurationsProvider,
        products: _products,
      );

      _errorMessageProducts = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print('deu erro para consultar os produtos: $e');
      _errorMessageProducts = DefaultErrorMessage.ERROR;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> saveTransferRequest({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
    required BuildContext context,
  }) async {
    _jsonSaleRequest["crossId"] = '${UserData.crossIdentity}';

    TransferRequestCartProductsModel.updateJsonSaleRequest(
      products: _cartProducts[requestTypeCode]![enterpriseOriginCode]![
          enterpriseDestinyCode]!,
      jsonSaleRequest: _jsonSaleRequest,
      enterpriseOriginCode: int.parse(enterpriseOriginCode),
      enterpriseDestinyCode: int.parse(enterpriseDestinyCode),
      requestTypeCode: int.parse(requestTypeCode),
    );

    _errorMessageSaveTransferRequest = "";
    _isLoadingSaveTransferRequest = true;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      FirebaseCallEnum.transferRequestSave,
    );

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "json": json.encode(_jsonSaleRequest),
        },
        typeOfResponse: "InsertResponse",
        SOAPAction: "Insert",
        serviceASMX: "CeltaTransferRequestService.asmx",
      );

      _errorMessageSaveTransferRequest = SoapRequestResponse.errorMessage;

      if (_errorMessageSaveTransferRequest == "") {
        await clearCart(
          requestTypeCode: requestTypeCode,
          enterpriseOriginCode: enterpriseOriginCode,
          enterpriseDestinyCode: enterpriseDestinyCode,
        );

        ShowSnackbarMessage.show(
          message: "O pedido foi salvo com sucesso!",
          context: context,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );

        RegExp regex = RegExp(
            r'\((.*?)\)'); // Expressão regular para capturar o conteúdo entre parênteses

        Match? match = regex.firstMatch(SoapRequestResponse
            .responseAsString); // Encontrar o primeiro match na string

        if (match != null) {
          _lastSavedTransferRequest = "Último pedido salvo: " + match.group(1)!;
        } else {
          //print("Nenhum conteúdo entre parênteses encontrado.");
        }
      } else {
        _isLoadingSaveTransferRequest = false;

        ShowSnackbarMessage.show(
          message: _errorMessageSaveTransferRequest,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para salvar a transferência: $e");
      _errorMessageSaveTransferRequest = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageSaveTransferRequest,
        context: context,
      );
    } finally {
      _isLoadingSaveTransferRequest = false;
      notifyListeners();
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/models.dart';
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
  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => [..._products];

  Map<String, Map<String, Map<String, List<GetProductJsonModel>>>>
      _cartProducts = {};

  List<GetProductJsonModel> getCartProducts({
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

  // Map<requestTypeCode, Map<enterpriseOriginCode, Map<enterpriseDestinyCode, List<GetProductJsonModel>>>>
  int? indexOfRemovedProduct;
  GetProductJsonModel? removedProduct;

  // getCartProducts({
  //   required String enterpriseOriginCode,
  //   required String enterpriseDestinyCode,
  // }) {
  //   return _cartProducts[enterpriseOriginCode]?[enterpriseDestinyCode] ?? 0;
  // }

  Future<void> removeProductFromCart({
    required int? ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    // removedProduct = _cartProducts[enterpriseCode]!.firstWhere(
    //     (element) => element.productPackingCode == ProductPackingCode);

    indexOfRemovedProduct = _cartProducts[requestTypeCode]![
            enterpriseOriginCode]![enterpriseDestinyCode]!
        .indexWhere(
            (element) => element.productPackingCode == ProductPackingCode);

    removedProduct = _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .removeAt(indexOfRemovedProduct!);

    // _cartProducts[enterpriseCode]!.removeWhere(
    //     (element) => element.productPackingCode == ProductPackingCode);

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
    required int? ProductPackingCode,
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
        if (element.productPackingCode == ProductPackingCode) {
          atualQuantity = element.quantity;
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
    required GetProductJsonModel product,
    required int selectedIndex,
    required int index,
  }) {
    if (selectedIndex != index &&
        _products.length == 1 &&
        product.wholePracticedPrice != null &&
        product.wholePracticedPrice!.toDouble() > 0)
      return true;
    else {
      return false;
    }
  }

  bool alreadyContainsProduct({
    required int? ProductPackingCode,
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
                  element.productPackingCode == ProductPackingCode) !=
          -1;
    }
  }

  Future<void> insertUpdateProductInCart({
    required GetProductJsonModel product,
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
      price = product.value ?? 0;
    }

    late double newQuantity;

    int? indexInCart = _cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode]
        ?.indexWhere((element) =>
            element.productPackingCode == product.productPackingCode);

    if (indexInCart != null && indexInCart != -1) {
      newQuantity = quantity +
          _cartProducts[requestTypeCode]![enterpriseOriginCode]![
                  enterpriseDestinyCode]![indexInCart]
              .quantity;
    } else {
      newQuantity = quantity;
    }

    GetProductJsonModel cartProductsModel = GetProductJsonModel(
      ExpectedDeliveryDate: "\"${DateTime.now().toString()}\"",
      quantity: newQuantity,
      value: price,
      enterpriseCode: product.enterpriseCode,
      productCode: product.productCode,
      productPackingCode: product.productPackingCode,
      plu: product.plu,
      name: product.name,
      packingQuantity: product.packingQuantity,
      retailPracticedPrice: product.retailPracticedPrice,
      retailSalePrice: product.retailSalePrice,
      retailOfferPrice: product.retailOfferPrice,
      wholePracticedPrice: product.wholePracticedPrice,
      wholeSalePrice: product.wholeSalePrice,
      wholeOfferPrice: product.wholeOfferPrice,
      eCommercePracticedPrice: product.eCommercePracticedPrice,
      eCommerceSalePrice: product.eCommerceSalePrice,
      eCommerceOfferPrice: product.eCommerceOfferPrice,
      minimumWholeQuantity: product.minimumWholeQuantity,
      storageAreaAddress: product.storageAreaAddress,
      balanceLabelType: product.balanceLabelType,
      balanceLabelQuantity: product.balanceLabelQuantity,
      pendantPrintLabel: product.pendantPrintLabel,
      operationalCost: product.operationalCost,
      replacementCost: product.replacementCost,
      replacementCostMidle: product.replacementCostMidle,
      liquidCost: product.liquidCost,
      liquidCostMidle: product.liquidCostMidle,
      realCost: product.realCost,
      realLiquidCost: product.realLiquidCost,
      fiscalCost: product.fiscalCost,
      fiscalLiquidCost: product.fiscalLiquidCost,
      stockByEnterpriseAssociateds: product.stockByEnterpriseAssociateds,
      stocks: product.stocks,
      lastBuyEntrance: product.lastBuyEntrance,
      markUpdateClassInAdjustSalePriceIndividual:
          product.markUpdateClassInAdjustSalePriceIndividual,
      inClass: product.inClass,
      isFatherOfGrate: product.isFatherOfGrate,
      alterationPriceForAllPackings: product.alterationPriceForAllPackings,
      isChildOfGrate: product.isChildOfGrate,
      priceCost: product.priceCost,
    );

    if (indexInCart == null || indexInCart == -1) {
      if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
              ?[enterpriseDestinyCode] ==
          null) {
        _cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] = [];
      }
      _cartProducts[requestTypeCode]?[enterpriseOriginCode]
              ?[enterpriseDestinyCode]
          ?.add(cartProductsModel);
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
    required GetProductJsonModel product,
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
      priceValue = product.value ?? 0;
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

      List<GetProductJsonModel> cartProductsTemp = [];

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
        cartProductsTemp.add(GetProductJsonModel.fromJson(element));
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
        .quantity = quantity;

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
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else {
      return _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .fold(0.0, (previous, atual) {
        return previous +=
            (atual.quantity * (atual.value ?? 0)) - (atual.DiscountValue ?? 0);
      }); //TODO test if is working
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
      _products = await SoapHelper.getProductTransferRequest(
        enterpriseOriginCode: enterpriseOriginCode.toString(),
        enterpriseDestinyCode: enterpriseDestinyCode.toString(),
        requestTypeCode: requestTypeCode.toString(),
        searchValue: value,
        configurationsProvider: configurationsProvider,
      );

      _errorMessageProducts = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print('deu erro para consultar os produtos: $e');
      _errorMessageProducts = DefaultErrorMessage.ERROR;
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
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

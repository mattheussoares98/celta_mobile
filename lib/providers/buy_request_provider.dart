import 'dart:convert';

import 'package:celta_inventario/Models/buy_request_models/buy_request_buyer_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_cart_product_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_enterprise_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_enterprise_selected_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_requests_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_supplier_model.dart';
import 'package:celta_inventario/api/prefs_instance.dart';
import 'package:celta_inventario/api/soap_helper.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:flutter/material.dart';

class BuyRequestProvider with ChangeNotifier {
  List<BuyRequestProductsModel> _products = [];
  List<BuyRequestProductsModel> get products => [..._products];
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageGetProducts = "";
  String get errorMessageGetProducts => _errorMessageGetProducts;
  int get productsCount => _products.length;

  List<BuyRequestBuyerModel> _buyers = [];
  List<BuyRequestBuyerModel> get buyers => [..._buyers];
  bool _isLoadingBuyer = false;
  bool get isLoadingBuyer => _isLoadingBuyer;
  String _errorMessageBuyer = "";
  String get errorMessageBuyer => _errorMessageBuyer;
  int get buyersCount => _buyers.length;
  BuyRequestBuyerModel? _selectedBuyer;
  BuyRequestBuyerModel? get selectedBuyer => _selectedBuyer;
  set selectedBuyer(BuyRequestBuyerModel? value) {
    _selectedBuyer = value;

    notifyListeners();
  }

  List<BuyRequestRequestsTypeModel> _requestsType = [];
  List<BuyRequestRequestsTypeModel> get requestsType => [..._requestsType];
  bool _isLoadingRequestsType = false;
  bool get isLoadingRequestsType => _isLoadingRequestsType;
  String _errorMessageRequestsType = "";
  String get errorMessageRequestsType => _errorMessageRequestsType;
  int get requestsTypeCount => _requestsType.length;
  BuyRequestRequestsTypeModel? _selectedRequestModel;
  BuyRequestRequestsTypeModel? get selectedRequestModel =>
      _selectedRequestModel;
  set selectedRequestModel(BuyRequestRequestsTypeModel? value) {
    _selectedRequestModel = value;

    clearSuppliers();
    clearProducts();
    _clearCartProducts();
    clearEnterprises();

    notifyListeners();
  }

  List<BuyRequestSupplierModel> _suppliers = [];
  List<BuyRequestSupplierModel> get suppliers => [..._suppliers];
  bool _isLoadingSupplier = false;
  bool get isLoadingSupplier => _isLoadingSupplier;
  String _errorMessageSupplier = "";
  String get errorMessageSupplier => _errorMessageSupplier;
  int get suppliersCount => _suppliers.length;
  BuyRequestSupplierModel? _selectedSupplier;
  BuyRequestSupplierModel? get selectedSupplier => _selectedSupplier;
  set selectedSupplier(BuyRequestSupplierModel? value) {
    _selectedSupplier = value;

    clearEnterprises();
    clearProducts();
    _clearCartProducts();

    notifyListeners();
    _updateBuyRequestInDatabase();
  }

  List<BuyRequestEnterpriseModel> _enterprises = [];
  List<BuyRequestEnterpriseModel> get enterprises => [..._enterprises];
  bool _isLoadingEnterprises = false;
  bool get isLoadingEnterprises => _isLoadingEnterprises;
  String _errorMessageEnterprises = "";
  String get errorMessageEnterprises => _errorMessageEnterprises;
  int get enterprisesCount => _enterprises.length;
  bool get hasSelectedEnterprise {
    bool hasSelectedEnterprise = false;
    for (var index = 0; index < _enterprises.length; index++) {
      if (_enterprises[index].selected) {
        hasSelectedEnterprise = true;
        break;
      }
    }
    return hasSelectedEnterprise;
  }

  bool _isLoadingInsertBuyRequest = false;
  bool get isLoadingInsertBuyRequest => _isLoadingInsertBuyRequest;
  String _errorMessageInsertBuyRequest = "";
  String get errorMessageInsertBuyRequest => _errorMessageInsertBuyRequest;

  List<BuyRequestEnterpriseSelectedModel> _enterprisesSelecteds = [];

  List<BuyRequestCartProductModel> _cartProducts = [];
  List<BuyRequestCartProductModel> get cartProducts => [..._cartProducts];
  int get cartProductsCount => _cartProducts.length;

  FocusNode focusNodeConsultProduct = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  int indexOfSelectedProduct = -1;
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> insertQuantityFormKey = GlobalKey();

  String _obvervations = "";
  String get observations => _obvervations;
  set observations(String newValue) {
    _obvervations = newValue;
    _updateBuyRequestInDatabase();
  }

  Map get _jsonBuyRequest => {
        "CrossIdentity": UserData.crossIdentity,
        "BuyerCode": -1,
        "RequestTypeCode": -1,
        "SupplierCode": -1,
        // "DateOfCreation": DateTime.now(),
        // "DateOfCreation": "2023-10-25T10:07:00",
        "Observations": "",
        "Enterprises": [],
        "Products": [],
      };

  double get totalCartPrice {
    double total = _cartProducts.fold(0, (previousValue, product) {
      double productTotal = product.Quantity * product.Value;
      return previousValue + productTotal;
    });

    return total;
  }

  Future<void> _updateBuyRequestInDatabase() async {
    var buyersJsonList = _buyers.map((buyer) => buyer.toJson()).toList();
    var suppliersJsonList =
        _suppliers.map((supplier) => supplier.toJson()).toList();
    var enterprisesJsonList =
        _enterprises.map((enterprise) => enterprise.toJson()).toList();
    var cartProductsJsonList =
        _cartProducts.map((cartProduct) => cartProduct.toJson()).toList();
    var requestsTypesJsonList =
        _requestsType.map((requestsType) => requestsType.toJson()).toList();

    Map _json = {
      "buyers": buyersJsonList,
      "suppliers": suppliersJsonList,
      "enterprises": enterprisesJsonList,
      "cartProducts": cartProductsJsonList,
      "requestsType": requestsTypesJsonList,
      "observations": _obvervations,
      "selectedBuyer": _selectedBuyer?.toJson(),
      "selectedRequestModel": _selectedRequestModel?.toJson(),
      "selectedSupplier": _selectedSupplier?.toJson(),
    };

    await PrefsInstance.setBuyRequest(json.encode(_json));
  }

  Future<void> restoreBuyRequestDataInDatabase() async {
    String buyRequestStringInDatabase = await PrefsInstance.getBuyRequest();

    if (buyRequestStringInDatabase == "") {
      return;
    }

    Map jsonInDatabase = {};
    jsonInDatabase = json.decode(buyRequestStringInDatabase);

    _restoreRequestTypeAndSelectedRequestType(jsonInDatabase);
    _restoreBuyersAndSelectedBuyer(jsonInDatabase);
    _restoreSuppliersAndSelectedSuppliers(jsonInDatabase);
    _restoreEnterprises(jsonInDatabase);
    notifyListeners();
  }

  _restoreBuyersAndSelectedBuyer(Map jsonInDatabase) {
    List<BuyRequestBuyerModel> buyersTemp = [];
    if (jsonInDatabase.containsKey("buyers")) {
      jsonInDatabase["buyers"].forEach((element) {
        buyersTemp.add(BuyRequestBuyerModel.fromJson(element));
      });
      _buyers = buyersTemp;
    }

    if (jsonInDatabase.containsKey("selectedBuyer") &&
        jsonInDatabase["selectedBuyer"] != null) {
      _selectedBuyer =
          BuyRequestBuyerModel.fromJson(jsonInDatabase["selectedBuyer"]);
    }
  }

  _restoreRequestTypeAndSelectedRequestType(Map jsonInDatabase) {
    List<BuyRequestRequestsTypeModel> requestsTypeTemp = [];
    if (jsonInDatabase.containsKey("requestsType")) {
      jsonInDatabase["requestsType"].forEach((element) {
        requestsTypeTemp.add(BuyRequestRequestsTypeModel.fromJson(element));
      });
      _requestsType = requestsTypeTemp;
    }

    if (jsonInDatabase.containsKey("selectedRequestModel") &&
        jsonInDatabase["selectedRequestModel"] != null) {
      _selectedRequestModel = BuyRequestRequestsTypeModel.fromJson(
          jsonInDatabase["selectedRequestModel"]);
    }
  }

  _restoreSuppliersAndSelectedSuppliers(Map jsonInDatabase) {
    List<BuyRequestSupplierModel> suppliersTemp = [];
    if (jsonInDatabase.containsKey("suppliers")) {
      jsonInDatabase["suppliers"].forEach((element) {
        suppliersTemp.add(BuyRequestSupplierModel.fromJson(element));
      });
      _suppliers = suppliersTemp;
    }

    if (jsonInDatabase.containsKey("selectedSupplier") &&
        jsonInDatabase["selectedSupplier"] != null) {
      _selectedSupplier =
          BuyRequestSupplierModel.fromJson(jsonInDatabase["selectedSupplier"]);
    }
  }

  _restoreEnterprises(Map jsonInDatabase) {
    List<BuyRequestEnterpriseModel> enterprisesTemp = [];

    if (jsonInDatabase.containsKey("enterprises")) {
      jsonInDatabase["enterprises"].forEach((element) {
        enterprisesTemp.add(BuyRequestEnterpriseModel.fromJson(element));
      });
      _enterprises = enterprisesTemp;
    }
  }

  void updateSelectedEnterprise(BuyRequestEnterpriseModel enterprise) async {
    int indexOfEnterprise = _enterprises.indexOf(enterprise);

    final newEnterprise = BuyRequestEnterpriseModel(
      Code: enterprise.Code,
      SaleRequestTypeCode: enterprise.SaleRequestTypeCode,
      PersonalizedCode: enterprise.PersonalizedCode,
      Name: enterprise.Name,
      FantasizesName: enterprise.FantasizesName,
      CnpjNumber: enterprise.CnpjNumber,
      InscriptionNumber: enterprise.InscriptionNumber,
      selected: !enterprise.selected, //única propriedade que muda
    );

    if (indexOfEnterprise != -1) {
      _enterprises[indexOfEnterprise] = newEnterprise;
    }

    _addOrRemoveEnterprisesSelecteds(enterprise);
    await _updateBuyRequestInDatabase();

    notifyListeners();
  }

  _addOrRemoveEnterprisesSelecteds(BuyRequestEnterpriseModel enterprise) {
    int indexOfSelectedEnterprise = _enterprisesSelecteds
        .indexWhere((element) => element.EnterpriseCode == enterprise.Code);

    if (indexOfSelectedEnterprise == -1) {
      final selectedEnterprise = BuyRequestEnterpriseSelectedModel(
        IsPrincipal: _enterprisesSelecteds.isEmpty,
        EnterpriseCode: enterprise.Code,
      );

      _enterprisesSelecteds.add(selectedEnterprise);
    } else {
      _enterprisesSelecteds.removeAt(indexOfSelectedEnterprise);
    }
  }

  void _clearEnterprisesSelecteds() {
    _enterprisesSelecteds.clear();
  }

  void clearProducts() {
    _products.clear();
  }

  void _clearCartProducts() {
    _cartProducts.clear();
  }

  void clearBuyers() {
    _buyers.clear();
    _selectedBuyer = null;
  }

  void clearRequestsType() {
    _requestsType.clear();
    _selectedRequestModel = null;
  }

  void clearSuppliers() {
    _suppliers.clear();
    _selectedSupplier = null;
  }

  void clearEnterprises() {
    _enterprises.clear();
    _clearEnterprisesSelecteds();
  }

  bool hasProductInCart(BuyRequestProductsModel product) {
    int index = _cartProducts.indexWhere((cartProduct) =>
        product.ProductPackingCode == cartProduct.ProductPackingCode &&
        product.EnterpriseCode == cartProduct.EnterpriseCode);

    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  void _updateProductWithProductCart() {
    if (cartProductsCount == 0) {
      _products.forEach((element) {
        element.Value = 0;
        element.quantity = 0;
      });
      return;
    }

    for (int i = 0; i < _products.length; i++) {
      for (int j = 0; j < _cartProducts.length; j++) {
        if (_products[i].ProductPackingCode ==
                _cartProducts[j].ProductPackingCode &&
            _products[i].EnterpriseCode == _cartProducts[j].EnterpriseCode) {
          _products[i].Value = _cartProducts[j].Value;
          _products[i].quantity = _cartProducts[j].Quantity;

          break;
        }
      }
    }
    notifyListeners();
  }

  void changeSelectedRequestModel() {
    clearSuppliers();
    clearEnterprises();
    clearProducts();
    _clearCartProducts();
  }

  Future<void> getProducts({
    required String searchValue,
    required BuildContext context,
  }) async {
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    _products.clear();
    indexOfSelectedProduct = -1;
    notifyListeners();

    Map jsonGetProducts = {
      "CrossIdentity": UserData.crossIdentity,
      "RoutineInt": 2,
      "SearchValue": searchValue,
      "RequestTypeCode": _selectedRequestModel!.Code,
      "EnterpriseCodes": [1, 2, 3, 4],
      "SupplierCode": _selectedSupplier!.Code,
      // "EnterpriseDestinyCode": 0,
      // "SearchTypeInt": 0,
      // "SearchType": 0,
      // "Routine": 0,
    };

    try {
      await SoapHelper.soapPost(
        parameters: {
          "filters": json.encode(jsonGetProducts),
        },
        typeOfResponse: "GetProductsJsonResponse",
        SOAPAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductsJsonResult",
      );

      _errorMessageGetProducts = SoapHelperResponseParameters.errorMessage;

      SoapHelperResponseParameters.responseAsString;

      if (_errorMessageGetProducts == "") {
        BuyRequestProductsModel.responseAsStringToBuyRequestProductsModel(
          responseAsString: SoapHelperResponseParameters.responseAsString,
          listToAdd: _products,
        );

        _updateProductWithProductCart();

        _products.sort((a, b) => a.PLU.compareTo(b.PLU));
      } else {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageGetProducts,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageGetProducts,
        context: context,
      );
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> getBuyers({
    bool? isSearchingAgain = false,
    required BuildContext context,
  }) async {
    _errorMessageBuyer = "";
    _isLoadingBuyer = true;
    clearBuyers();
    if (isSearchingAgain!) notifyListeners();

    Map jsonGetBuyer = {
      "CrossIdentity": UserData.crossIdentity,
      // "SearchValue": "teste",
      // "RoutineInt": 2,
      // "Routine": 2,
      // "TopQuantity": 1,
      // "SearchTypeInt": 0,
      // "RequestTypeCode": 0,
      // "SupplierCode": 0,
      // "SearchType": 0,
    };

    try {
      await SoapHelper.soapPost(
        parameters: {
          "filters": json.encode(jsonGetBuyer),
        },
        typeOfResponse: "GetEmployeeJsonResponse",
        SOAPAction: "GetEmployeeJson",
        serviceASMX: "CeltaEmployeeService.asmx",
        typeOfResult: "GetEmployeeJsonResult",
      );

      _errorMessageBuyer = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageBuyer == "") {
        BuyRequestBuyerModel.responseAsStringToBuyRequestBuyerModel(
          responseAsString: SoapHelperResponseParameters.responseAsString,
          listToAdd: _buyers,
        );
      } else {
        ShowSnackbarMessage.showMessage(
          message:
              "Ocorreu um erro não esperado para consultar os compradores. Verifique a sua internet",
          context: context,
        );
      }
    } catch (e) {
      print("Erro para obter os compradores: $e");
      _errorMessageBuyer = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageBuyer,
        context: context,
      );
    }
    _isLoadingBuyer = false;
    notifyListeners();
  }

  Future<void> getRequestsType({
    bool? isSearchingAgain = false,
    required BuildContext context,
  }) async {
    _errorMessageRequestsType = "";
    _isLoadingRequestsType = true;
    clearRequestsType();
    if (isSearchingAgain!) notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "inclusiveBuy": true,
          "inclusiveTransfer": false,
          "inclusiveSale": false,
          // "simpleSearchValue": "string",
          // "enterpriseCode": "int",
        },
        serviceASMX: "CeltaRequestTypeService.asmx",
        typeOfResponse: "GetRequestTypesJsonResponse",
        SOAPAction: "GetRequestTypesJson",
        typeOfResult: "GetRequestTypesJsonResult",
      );

      _errorMessageRequestsType = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageRequestsType == "") {
        BuyRequestRequestsTypeModel
            .responseAsStringToBuyRequestRequestsTypeModel(
          responseAsString: SoapHelperResponseParameters.responseAsString,
          listToAdd: _requestsType,
        );
      } else {
        ShowSnackbarMessage.showMessage(
          message:
              "Ocorreu um erro não esperado para consultar os modelos de pedido. Verifique a sua internet",
          context: context,
        );
      }
    } catch (e) {
      print("Erro para obter os modelos de pedido: $e");
      _errorMessageRequestsType = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageRequestsType,
        context: context,
      );
    }
    _isLoadingRequestsType = false;
    notifyListeners();
  }

  Future<void> getSuppliers({
    required BuildContext context,
    required String searchValue,
  }) async {
    _errorMessageSupplier = "";
    _isLoadingSupplier = true;
    clearSuppliers();
    notifyListeners();

    Map jsonGetSupplier = {
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": searchValue,
      "RoutineInt": 2,
      // "Routine": 0,
    };

    try {
      await SoapHelper.soapPost(
        parameters: {
          "filters": json.encode(jsonGetSupplier),
        },
        serviceASMX: "CeltaSupplierService.asmx",
        typeOfResponse: "GetSupplierJsonResponse",
        SOAPAction: "GetSupplierJson",
        typeOfResult: "GetSupplierJsonResult",
      );

      _errorMessageSupplier = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageSupplier == "") {
        BuyRequestSupplierModel.responseAsStringToBuyRequestSupplierModel(
          responseAsString: SoapHelperResponseParameters.responseAsString,
          listToAdd: _suppliers,
        );
      }
    } catch (e) {
      print("Erro para obter os fornecedores: $e");
      _errorMessageSupplier = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageSupplier,
        context: context,
      );
    }
    _isLoadingSupplier = false;
    notifyListeners();
  }

  Future<void> getEnterprises({
    required BuildContext context,
    bool isSearchingAgain = true,
  }) async {
    _errorMessageEnterprises = "";
    _isLoadingEnterprises = true;
    clearEnterprises();
    if (isSearchingAgain) notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
        },
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResponse: "GetEnterprisesJsonResponse",
        SOAPAction: "GetEnterprisesJson",
        typeOfResult: "GetEnterprisesJsonResult",
      );

      _errorMessageEnterprises = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageEnterprises == "") {
        BuyRequestEnterpriseModel.responseAsStringToBuyRequestEnterpriseModel(
          responseAsString: SoapHelperResponseParameters.responseAsString,
          listToAdd: _enterprises,
        );

        await _updateBuyRequestInDatabase();
      } else {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageEnterprises,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para obter as empresas: $e");
      _errorMessageEnterprises = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageEnterprises,
        context: context,
      );
    }
    _isLoadingEnterprises = false;
    notifyListeners();
  }

  void updateProductInCart({
    required TextEditingController priceController,
    required TextEditingController quantityController,
    required int index,
  }) {
    double price =
        double.parse(priceController.text.replaceAll(RegExp(r','), '.'));
    double quantity =
        double.parse(quantityController.text.replaceAll(RegExp(r','), '.'));

    BuyRequestProductsModel product = _products[index];
    product.quantity = quantity;
    product.Value = price;

    BuyRequestCartProductModel cartProduct = BuyRequestCartProductModel(
      EnterpriseCode: product.EnterpriseCode,
      ProductPackingCode: product.ProductPackingCode,
      Value: price,
      Quantity: quantity,
      IncrementPercentageOrValue: "R\$",
      IncrementValue: 0,
      DiscountPercentageOrValue: "R\$",
      DiscountValue: 0,
    );

    int indexOfCartProduct = _cartProducts.indexWhere((element) =>
        element.EnterpriseCode == product.EnterpriseCode &&
        element.ProductPackingCode == product.ProductPackingCode);

    if (indexOfCartProduct == -1) {
      _cartProducts.add(cartProduct);
    } else {
      _cartProducts[indexOfCartProduct] = cartProduct;
    }

    notifyListeners();
  }

  void removeProductFromCart(BuyRequestProductsModel product) {
    int indexOfProduct = _products.indexWhere(
      (element) =>
          element.ProductPackingCode == product.ProductPackingCode &&
          element.EnterpriseCode == product.EnterpriseCode,
    );

    _products[indexOfProduct].Value = 0;
    _products[indexOfProduct].quantity = 0;

    _cartProducts.removeWhere(
      (element) =>
          element.ProductPackingCode == product.ProductPackingCode &&
          element.EnterpriseCode == product.EnterpriseCode,
    );

    notifyListeners();
  }

  Future<void> insertBuyRequest(BuildContext context) async {
    _isLoadingInsertBuyRequest = true;
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": '${json.encode(_jsonBuyRequest)}',
        },
        serviceASMX: "CeltaBuyRequestService.asmx",
        typeOfResponse: "InsertResponse",
        SOAPAction: "Insert",
        typeOfResult: "InsertResult",
      );

      _errorMessageInsertBuyRequest = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageInsertBuyRequest != "") {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageInsertBuyRequest,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para salvar o pedido: $e");
      _errorMessageInsertBuyRequest =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageInsertBuyRequest,
        context: context,
      );
    }

    _isLoadingInsertBuyRequest = false;
    notifyListeners();
  }
}

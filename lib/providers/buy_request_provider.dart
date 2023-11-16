import 'dart:convert';

import 'package:celta_inventario/Models/buy_request_models/buy_request_buyer_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_requests_model.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_supplier_model.dart';
import 'package:celta_inventario/api/soap_helper.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:flutter/material.dart';

class BuyRequestProvider with ChangeNotifier {
  List<BuyRequestProductsModel> _products = [];
  List<BuyRequestProductsModel> get products => _products;
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageGetProducts = "";
  String get errorMessageGetProducts => _errorMessageGetProducts;
  int get productsCount => _products.length;

  List<BuyRequestBuyerModel> _buyers = [];
  List<BuyRequestBuyerModel> get buyers => _buyers;
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
  List<BuyRequestRequestsTypeModel> get requestsType => _requestsType;
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
    notifyListeners();
  }

  List<BuyRequestSupplierModel> _suppliers = [];
  List<BuyRequestSupplierModel> get suppliers => _suppliers;
  bool _isLoadingSupplier = false;
  bool get isLoadingSupplier => _isLoadingSupplier;
  String _errorMessageSupplier = "";
  String get errorMessageSupplier => _errorMessageSupplier;
  int get suppliersCount => _suppliers.length;
  BuyRequestSupplierModel? selectedSupplier;
  set selectedBuyerDropDown(String? value) {
    _selectedBuyerDropDown = value;
    notifyListeners();
  }

  List<BuyRequestSupplierModel> _enterprises = [];
  List<BuyRequestSupplierModel> get enterprises => _enterprises;
  bool _isLoadingEnterprises = false;
  bool get isLoadingEnterprises => _isLoadingEnterprises;
  String _errorMessageEnterprises = "";
  String get errorMessageEnterprises => _errorMessageEnterprises;
  int get enterprisesCount => _enterprises.length;
  String? _selectedBuyerDropDown;
  String? get selectedBuyerDropDown => _selectedBuyerDropDown;

  void clearProducts() {
    _products.clear();
  }

  void clearBuyers() {
    _buyers.clear();
  }

  void clearRequestsType() {
    _requestsType.clear();
  }

  void clearSuppliers() {
    _suppliers.clear();
    selectedSupplier = null;
  }

  void clearEnterprises() {
    _enterprises.clear();
  }

  Future<void> getProducts({
    required String searchValue,
    required BuildContext context,
  }) async {
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    _products.clear();
    notifyListeners();

    Map jsonGetProducts = {
      "CrossIdentity": UserData.crossIdentity,
      "RoutineInt": 2,
      "SearchValue": searchValue,
      // "SearchTypeInt": 0,
      "RequestTypeCode": _selectedRequestModel!.Code,
      "EnterpriseCodes": [1, 2, 3, 4],
      // "EnterpriseDestinyCode": 0,
      "SupplierCode": selectedSupplier!.Code,
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
    bool isSearchingAgain = false,
  }) async {
    _errorMessageEnterprises = "";
    _isLoadingEnterprises = true;
    clearEnterprises();
    if (isSearchingAgain) notifyListeners();

    Map jsonGetEnterprises = {
      "crossIdentity": UserData.crossIdentity,
    };

    try {
      await SoapHelper.soapPost(
        parameters: {
          "filters": json.encode(jsonGetEnterprises),
        },
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResponse: "GetEnterprisesJsonResponse",
        SOAPAction: "GetEnterprisesJson",
        typeOfResult: "GetEnterprisesJsonResult",
      );

      _errorMessageEnterprises = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageEnterprises == "") {
        // BuyRequestSupplierModel.responseAsStringToBuyRequestSupplierModel(
        //   responseAsString: SoapHelperResponseParameters.responseAsString,
        //   listToAdd: _suppliers,
        // );
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
}

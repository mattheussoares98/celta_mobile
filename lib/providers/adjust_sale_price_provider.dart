import 'dart:convert';

import 'package:celta_inventario/api/soap/soap.dart';
import 'package:celta_inventario/models/soap/products/get_product_json/get_product_json_model.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'providers.dart';

class AdjustSalePriceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => [..._products];

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<String> get saleOrOffer => ["Venda", "Oferta"];

  Future<void> getProducts({
    required int enterpriseCode,
    required String searchValue,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _isLoading = true;
    _products.clear();
    _errorMessage = "";
    notifyListeners();

    try {
      await SoapHelper.getProductJsonModel(
        listToAdd: _products,
        enterpriseCode: enterpriseCode,
        searchValue: searchValue,
        configurationsProvider: configurationsProvider,
        routineTypeInt: 0,
      );

      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductSchedules({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    _isLoading = true;
    _errorMessage = "";

    try {
      Map jsonGetSchedules = {
        "CrossIdentity": UserData.crossIdentity,
        "EnterpriseCode": 1,
        "ProductCode": 2,
        "ProductPackingCode": 3,
        "SaleTypeInt": 1,
      };
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(jsonGetSchedules),
        },
        typeOfResponse: "GetPriceSchedulesResponse",
        SOAPAction: "GetPriceSchedules",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetPriceSchedulesResult",
      );

      print(SoapRequestResponse.responseAsString);
      print(SoapRequestResponse.responseAsMap);
      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
  }
}

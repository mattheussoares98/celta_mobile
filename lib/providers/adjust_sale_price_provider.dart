import 'dart:convert';

import 'package:celta_inventario/api/soap/soap.dart';
import 'package:celta_inventario/models/soap/products/get_product_json/get_product_json_model.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/adjust_sale_request/adjust_sale_request.dart';
import 'providers.dart';

class AdjustSalePriceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => [..._products];

  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => [..._schedules];

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<String> get saleOrOffer => ["Venda", "Oferta"];

  void clearDataOnCloseAdjustPriceScreen() {
    _schedules.clear();
    _errorMessage = "";
  }

  void clearDataOnCloseProductsScreen() {
    _products.clear();
    _errorMessage = "";
  }

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
    _schedules.clear();
    notifyListeners();

    try {
      Map jsonGetSchedules = {
        "CrossIdentity": UserData.crossIdentity,
        "EnterpriseCode": enterpriseCode,
        "ProductCode": productCode,
        "ProductPackingCode": productPackingCode,
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
      final List teste = json.decode(SoapRequestResponse.responseAsString);

      _schedules = teste.map((e) => ScheduleModel.fromJson(e)).toList();

      // _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> confirmAdjust({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required bool updatePriceClass,
    required bool updatePackings,
    required bool updateEnterpriseGroup,
    required bool updateGrate,
    required int saleTypeInt, //1 == varejo; 2 == atacado; 3 == ecommerce
    required double price,
    required DateTime effectuationDatePrice,
    required DateTime effectuationDateOffer,
    required DateTime endDateOffer,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final Map jsonRequest = {
        "CrossIdentity": UserData.crossIdentity,
        "EnterpriseCode": enterpriseCode,
        "ProductCode": productCode,
        "ProductPackingCode": productPackingCode,
        "UpdatePriceClass": updatePriceClass,
        "UpdatePackings": updatePackings,
        "UpdateEnterpriseGroup": updateEnterpriseGroup,
        "UpdateGrate": updateGrate,
        "SaleTypeInt": saleTypeInt, //1 == varejo; 2 == atacado; 3 == ecommerce
        "Price": price,
        "Offer": price,
        "EffectuationDatePrice": effectuationDatePrice.toIso8601String(),
        "EffectuationDateOffer": effectuationDateOffer.toIso8601String(),
        "EndDateOffer": endDateOffer.toIso8601String()
      };
      SoapRequest.soapPost(
        parameters: {
          "parameters": json.encode(jsonRequest),
        },
        typeOfResponse: "AdjustSalePriceResponse",
        SOAPAction: "AdjustSalePrice",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "AdjustSalePriceResult",
      );
      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
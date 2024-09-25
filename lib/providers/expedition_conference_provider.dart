import 'dart:convert';

import 'package:celta_inventario/api/api.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/expedition_control/expedition_control.dart';
import '../models/soap/soap.dart';
import 'providers.dart';

class ExpeditionConferenceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<ExpeditionControlModel> _expeditionControlsToConference = [];
  List<ExpeditionControlModel> get expeditionControlsToConference =>
      [..._expeditionControlsToConference];

  List<ExpeditionControlProductModel> _pendingProducts = [];
  List<ExpeditionControlProductModel> get pendingProducts =>
      [..._pendingProducts];

  List<ExpeditionControlProductModel> _checkedProducts = [];
  List<ExpeditionControlProductModel> get checkedProducts =>
      [..._checkedProducts];

  List<GetProductJsonModel> _searchedProducts = [];
  List<GetProductJsonModel> get searchedProducts => [..._searchedProducts];
  String _errorMessageGetProducts = "";
  String get errorMessageGetProducts => _errorMessageGetProducts;

  Future<void> getExpeditionControlsToConference({
    required int enterpriseCode,
  }) async {
    _errorMessage = "";
    _isLoading = true;
    _expeditionControlsToConference.clear();
    notifyListeners();

    try {
      final jsonFilters = {
        "CrossIdentity": UserData.crossIdentity,
        "EnterpriseCode": enterpriseCode,
      };

      await SoapRequest.soapPost(
        parameters: {
          "stringFilters": json.encode(jsonFilters),
        },
        typeOfResponse: "GetExpeditionControlsToConferenceResponse",
        SOAPAction: "GetExpeditionControlsToConference",
        serviceASMX: "celtaproductservice.asmx",
        typeOfResult: "GetExpeditionControlsToConferenceResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage != "") {
        return;
      }

      List responseAsMap = json.decode(SoapRequestResponse.responseAsString);

      _expeditionControlsToConference =
          responseAsMap.map((e) => ExpeditionControlModel.fromJson(e)).toList();

      if (_expeditionControlsToConference.isEmpty) {
        _errorMessage =
            "Nenhum documento está no processo de conferência de produtos";
      }
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPendingProducts({
    required int expeditionControlCode,
  }) async {
    _errorMessage = "";
    _isLoading = true;
    _checkedProducts.clear();
    _pendingProducts.clear();
    notifyListeners();

    try {
      final jsonFilters = {
        "CrossIdentity": UserData.crossIdentity,
        "ExpeditionControlCode": expeditionControlCode,
      };

      await SoapRequest.soapPost(
        parameters: {
          "stringFilters": json.encode(jsonFilters),
        },
        typeOfResponse: "GetExpeditionControlProductsResponse",
        SOAPAction: "GetExpeditionControlProducts",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetExpeditionControlProductsResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage.isNotEmpty) {
        return;
      }

      List decodedResponse = json.decode(SoapRequestResponse.responseAsString);
      _pendingProducts = decodedResponse
          .map((e) => ExpeditionControlProductModel.fromJson(e))
          .toList();
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProducts({
    required String value,
    required int enterpriseCode,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _isLoading = true;
    _errorMessageGetProducts = "";
    _searchedProducts.clear();
    notifyListeners();

    try {
      await SoapHelper.getProductJsonModel(
        listToAdd: _searchedProducts,
        enterpriseCode: enterpriseCode,
        searchValue: value,
        configurationsProvider: configurationsProvider,
        routineTypeInt: 0,
      );

      _errorMessageGetProducts = SoapRequestResponse.errorMessage;
      if (_errorMessageGetProducts != "") {
        return;
      }
    } catch (e) {
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool addConfirmedProduct(int indexOfSearchedProduct) {
    final confirmedProduct = _searchedProducts[indexOfSearchedProduct];

    final indexOfConfirmedProductInPendingProducts = _pendingProducts
        .indexWhere((e) => e.PriceLookUp == confirmedProduct.plu);

    if (indexOfConfirmedProductInPendingProducts == -1) {
      _errorMessageGetProducts = "Esse produto não faz parte da conferência";
      return false;
    }

    final pendingProduct =
        _pendingProducts[indexOfConfirmedProductInPendingProducts];

    if (pendingProduct.Quantity <= 1) {
      _pendingProducts.removeAt(indexOfConfirmedProductInPendingProducts);
      _addOrSumQuantityInCheckedProducts(pendingProduct);
    } else {
      _addOrSumQuantityInCheckedProducts(pendingProduct);
      _pendingProducts[indexOfConfirmedProductInPendingProducts] =
          ExpeditionControlProductModel(
        EnterpriseCode: pendingProduct.EnterpriseCode,
        ProductCode: pendingProduct.ProductCode,
        ProductPackingCode: pendingProduct.ProductPackingCode,
        Quantity: pendingProduct.Quantity - 1,
        PriceLookUp: pendingProduct.PriceLookUp,
        Name: pendingProduct.Name,
        Packing: pendingProduct.Packing,
      );
    }
    notifyListeners();
    return true;
  }

  void _addOrSumQuantityInCheckedProducts(
    ExpeditionControlProductModel pendingProduct,
  ) {
    int indexOfPendingProductInCheckedProducts = _checkedProducts
        .indexWhere((e) => e.PriceLookUp == pendingProduct.PriceLookUp);

    if (indexOfPendingProductInCheckedProducts == -1) {
      _checkedProducts.add(
        ExpeditionControlProductModel(
          EnterpriseCode: pendingProduct.EnterpriseCode,
          ProductCode: pendingProduct.ProductCode,
          ProductPackingCode: pendingProduct.ProductPackingCode,
          Quantity: 1,
          PriceLookUp: pendingProduct.PriceLookUp,
          Name: pendingProduct.Name,
          Packing: pendingProduct.Packing,
        ),
      );
    } else {
      final checkedProduct =
          _checkedProducts[indexOfPendingProductInCheckedProducts];
      _checkedProducts[indexOfPendingProductInCheckedProducts] =
          ExpeditionControlProductModel(
        EnterpriseCode: checkedProduct.EnterpriseCode,
        ProductCode: checkedProduct.ProductCode,
        ProductPackingCode: checkedProduct.ProductPackingCode,
        Quantity: checkedProduct.Quantity + 1,
        PriceLookUp: checkedProduct.PriceLookUp,
        Name: checkedProduct.Name,
        Packing: checkedProduct.Packing,
      );
    }
  }
}

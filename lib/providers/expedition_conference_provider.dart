import 'dart:convert';

import '../api/api.dart';
import '../utils/utils.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';
import '../models/models.dart';
import 'providers.dart';

class ExpeditionConferenceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String _errorMessageConfirmConference = "";
  String get errorMessageConfirmConference => _errorMessageConfirmConference;

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
    required EnterpriseModel enterprise,
  }) async {
    _errorMessage = "";
    _isLoading = true;
    _expeditionControlsToConference.clear();
    notifyListeners();

    try {
      final jsonFilters = {
        "CrossIdentity": UserData.crossIdentity,
        "EnterpriseCode": enterprise.Code,
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
      _errorMessage = DefaultErrorMessage.ERROR;
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
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProducts({
    required String value,
    required EnterpriseModel enterprise,
    required ConfigurationsProvider configurationsProvider,
    required int expeditionControlCode,
    required int stepCode,
    required Future<void> Function() searchAgainByCamera,
  }) async {
    _isLoading = true;
    _errorMessageGetProducts = "";
    _searchedProducts.clear();
    notifyListeners();

    try {
      _searchedProducts = await SoapHelper.getProductsJsonModel(
        enterprise: enterprise,
        searchValue: value,
        configurationsProvider: configurationsProvider,
        enterprisesCodes: [enterprise.Code],
        routineTypeInt: 0,
      );

      _errorMessageGetProducts = SoapRequestResponse.errorMessage;
      if (_errorMessageGetProducts != "") {
        ShowSnackbarMessage.show(
          message: _errorMessageGetProducts,
          context: NavigatorKey.navigatorKey.currentState!.context,
        );
      } else if (_searchedProducts.length == 1) {
        await addConfirmedProduct(
          indexOfSearchedProduct: 0,
          expeditionControlCode: expeditionControlCode,
          enterprise: enterprise,
          stepCode: stepCode,
        );

        if (_errorMessageGetProducts == "" &&
            configurationsProvider.autoScan?.value == true &&
            _pendingProducts.isNotEmpty) {
          await searchAgainByCamera();
        }
      }
    } catch (e) {
      _errorMessageGetProducts = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageGetProducts,
        context: NavigatorKey.navigatorKey.currentState!.context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addConfirmedProduct({
    required int indexOfSearchedProduct,
    required int expeditionControlCode,
    required EnterpriseModel enterprise,
    required int stepCode,
  }) async {
    final confirmedProduct = _searchedProducts[indexOfSearchedProduct];

    final indexOfConfirmedProductInPendingProducts = _pendingProducts
        .indexWhere((e) => e.PriceLookUp == confirmedProduct.plu);

    if (indexOfConfirmedProductInPendingProducts == -1) {
      _errorMessageGetProducts = "Esse produto não faz parte da conferência";
      ShowSnackbarMessage.show(
        message: _errorMessageGetProducts,
        context: NavigatorKey.navigatorKey.currentState!.context,
      );
      return;
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
    ShowSnackbarMessage.show(
      message: "Produto conferido",
      context: NavigatorKey.navigatorKey.currentState!.context,
      backgroundColor: Theme.of(NavigatorKey.navigatorKey.currentState!.context)
          .colorScheme
          .primary,
    );

    Navigator.of(NavigatorKey.navigatorKey.currentState!.context).popUntil(
      (route) =>
          route.settings.name == APPROUTES.EXPEDITION_CONFERENCE_PRODUCTS,
    );

    if (_pendingProducts.isEmpty) {
      await confirmConference(
        expeditionControlCode: expeditionControlCode,
        enterprise: enterprise,
        stepCode: stepCode,
      );
    }
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

  Future<void> confirmConference({
    required int expeditionControlCode,
    required EnterpriseModel enterprise,
    required int stepCode,
  }) async {
    _errorMessageConfirmConference = "";
    _isLoading = true;
    notifyListeners();
    try {
      final parameters = {
        "CrossIdentity": UserData.crossIdentity,
        "ExpeditionControlCode": expeditionControlCode,
        "StepCode": stepCode,
        "Confered": true,
      };
      await SoapRequest.soapPost(
        parameters: {"parametersString": json.encode(parameters)},
        typeOfResponse: "ConfirmConferenceResponse",
        SOAPAction: "ConfirmConference",
        serviceASMX: "CeltaProductService.asmx",
      );
      _errorMessageConfirmConference = SoapRequestResponse.errorMessage;

      if (_errorMessageConfirmConference.isEmpty) {
        Navigator.of(NavigatorKey.navigatorKey.currentState!.context).popUntil(
          (route) =>
              route.settings.name ==
              APPROUTES.EXPEDITION_CONFERENCE_CONTROLS_TO_CONFERENCE,
        );

        ShowSnackbarMessage.show(
          message: "Conferência concluída com sucesso",
          context: NavigatorKey.navigatorKey.currentState!.context,
          backgroundColor:
              Theme.of(NavigatorKey.navigatorKey.currentState!.context)
                  .colorScheme
                  .primary,
        );

        await getExpeditionControlsToConference(enterprise: enterprise);
      }
    } catch (e) {
      _errorMessageConfirmConference = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

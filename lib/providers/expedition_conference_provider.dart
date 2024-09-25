import 'dart:convert';

import 'package:celta_inventario/api/api.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/expedition_control/expedition_control.dart';

class ExpeditionConferenceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<ExpeditionControlModel> _expeditionControlsToConference = [];
  List<ExpeditionControlModel> get expeditionControlsToConference =>
      _expeditionControlsToConference;

  List<ExpeditionControlProductModel> _pendingProducts = [];
  List<ExpeditionControlProductModel> get pendingProducts => _pendingProducts;

  List<ExpeditionControlProductModel> _checkedProducts = [];
  List<ExpeditionControlProductModel> get checkedProducts =>
      _checkedProducts;

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

  Future<void> getProducts({
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
}

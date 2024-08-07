import 'dart:convert';

import 'package:celta_inventario/api/api.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

class ProductsConferenceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<void> getExpeditionControlsToConference({
    required int enterpriseCode,
  }) async {
    _errorMessage = "";
    _isLoading = true;
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

      SoapRequestResponse.responseAsMap;
      SoapRequestResponse.responseAsString;
      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

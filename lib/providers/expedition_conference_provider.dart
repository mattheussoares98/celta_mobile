import 'dart:convert';

import 'package:celta_inventario/api/api.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import '../models/products_conference/products_conference.dart';

class ExpeditionConferenceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<ExpeditionControlModel> _expeditionControlsToConference = [];
  List<ExpeditionControlModel> get expeditionControlsToConference =>
      _expeditionControlsToConference;

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

      SoapRequestResponse.responseAsMap;
      SoapRequestResponse.responseAsString;
      _errorMessage = SoapRequestResponse.errorMessage;
      List responseAsMap = json.decode(SoapRequestResponse.responseAsString);

      _expeditionControlsToConference =
          responseAsMap.map((e) => ExpeditionControlModel.fromJson(e)).toList();

      // _expeditionControlsProducts =
      //     (SoapRequestResponse.responseAsString as Map)
      //         .map((e) => ExpeditionControlModel.fromJson(e))
      //         .toList();
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

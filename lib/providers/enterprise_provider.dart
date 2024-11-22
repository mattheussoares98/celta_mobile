import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/enterprise/enterprise.dart';
import '../models/firebase/firebase.dart';
import '../utils/utils.dart';

class EnterpriseProvider with ChangeNotifier {
  List<EnterpriseModel> _enterprises = [];

  List<EnterpriseModel> get enterprises => [..._enterprises];
  int get enterpriseCount => _enterprises.length;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  static bool _isLoading = false;

  bool get isLoading => _isLoading;

  FirebaseEnterpriseModel? _firebaseEnterpriseModel;
  FirebaseEnterpriseModel? get firebaseEnterpriseModel =>
      _firebaseEnterpriseModel;

  bool _userCanAdjustSalePrice = false;
  bool get userCanAdjustSalePrice => _userCanAdjustSalePrice;

  Future<void> getEnterprises({
    bool? verifyUserCanAdjustSalePrice,
  }) async {
    if (_isLoading) {
      return;
    }
    _enterprises.clear();
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      if (verifyUserCanAdjustSalePrice == true) {
        _userCanAdjustSalePrice = await _verifyUserCanAdjustSalePrice();
        if (!_userCanAdjustSalePrice) {
          return;
        }
      }

      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "simpleSearchValue": "",
          "requestTypeCode": 0,
        },
        typeOfResponse: "GetEnterprisesResponse",
        SOAPAction: "GetEnterprises",
        serviceASMX: "celtaenterpriseService.asmx",
        typeOfResult: "GetEnterprisesResult",
      );

      _enterprises = (SoapRequestResponse.responseAsMap["Empresas"] as List)
          .map((e) => EnterpriseModel.fromJson(e))
          .toList();

      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getFirebaseEnterpriseModel() async {
    _errorMessage = "";
    _isLoading = true;
    _firebaseEnterpriseModel = null;
    notifyListeners();

    try {
      _firebaseEnterpriseModel =
          await FirebaseHelper.getFirebaseEnterpriseModel();
    } catch (e) {
      _errorMessage =
          "Ocorreu um erro não esperado para carregar as informações da empresa \n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearEnterprises() {
    _enterprises.clear();
    notifyListeners();
  }

  Future<bool> _verifyUserCanAdjustSalePrice() async {
    try {
      final encoded = json.encode({
        "CrossIdentity": UserData.crossIdentity,
        // "ResourceCode": "609",
        "RoutineInt": 8, //adjustSalePrice
      });

      await SoapRequest.soapPost(
        parameters: {
          "jsonParameters": encoded,
        },
        typeOfResponse: "UserCanAccessCrossResourceResponse",
        SOAPAction: "UserCanAccessCrossResource",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanAccessCrossResourceResult",
      );

      if (SoapRequestResponse.errorMessage != "") {
        _errorMessage = SoapRequestResponse.errorMessage;
        return false;
      } else {
        return json.decode(SoapRequestResponse.responseAsString)["CanAccess"];
      }
    } catch (e) {
      _errorMessage = DefaultErrorMessage.ERROR;
      return false;
    }
  }
}

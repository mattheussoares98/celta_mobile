import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class EnterpriseProvider with ChangeNotifier {
  List<EnterpriseModel> _enterprises = [];

  List<EnterpriseModel> get enterprises => [..._enterprises];
  int get enterpriseCount => _enterprises.length;
  String _errorMessage = '';

  String get errorMessage => _errorMessage;
  static bool _isLoading = false;

  bool get isLoading => _isLoading;

  static FirebaseEnterpriseModel? _firebaseEnterpriseModel;
  FirebaseEnterpriseModel? get firebaseEnterpriseModel =>
      _firebaseEnterpriseModel;

  bool _userCanAdjustSalePrice = false;
  bool get userCanAdjustSalePrice => _userCanAdjustSalePrice;

  bool _bsAlreadyInLatestVersion = false;
  bool get bsAlreadyInLatestVersion => _bsAlreadyInLatestVersion;

  Future<void> getEnterprises({
    bool? verifyUserCanAdjustSalePrice,
  }) async {
    if (_isLoading) {
      return;
    }
    _bsAlreadyInLatestVersion = false;
    _enterprises.clear();
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    try {
      if (verifyUserCanAdjustSalePrice == true) {
        _userCanAdjustSalePrice = await SoapHelper.userCanAccessResource(
          resourceCode: 609,
          routineInt: 8,
        );

        if (!_userCanAdjustSalePrice) {
          _errorMessage = "O usuário não possui permissão para alterar preços";
          return;
        }
      }

      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "simpleSearchValue": "",
          "requestTypeCode": 0,
        },
        typeOfResponse: "GetEnterprisesJsonResponse",
        SOAPAction: "GetEnterprisesJson",
        serviceASMX: "celtaenterpriseService.asmx",
        typeOfResult: "GetEnterprisesJsonResult",
      );

      final decodedResponse = json.decode(SoapRequestResponse.responseAsString);
      _enterprises = (decodedResponse as List)
          .map((e) => EnterpriseModel.fromJson(e))
          .toList();

      _errorMessage = SoapRequestResponse.errorMessage;

      _bsAlreadyInLatestVersion = await SoapHelper.bsAlreadyInLatestVersion();
    } catch (e) {
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateFirebaseEnterpriseModel() async {
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
}

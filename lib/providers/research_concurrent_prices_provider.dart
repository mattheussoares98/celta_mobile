import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/global_widgets/global_widgets.dart';
import '../models/research_prices/research_prices.dart';
import '../utils/utils.dart';

class ResearchPricesProvider with ChangeNotifier {
  bool _isLoadingGetResearchPrices = false;
  bool get isLoadingResearchPrices => _isLoadingGetResearchPrices;
  String _errorGetResearchPrices = "";
  String get errorGetResearchPrices => _errorGetResearchPrices = "";
  final List<ResearchsModel> _researchPrices = [];
  List<ResearchsModel> get researchPrices => [..._researchPrices];
  int get researchPricesCount => _researchPrices.length;
  FocusNode researchPricesFocusNode = FocusNode();

  bool _isLoadingGetConcurrents = false;
  bool get isLoadingGetConcurrents => _isLoadingGetConcurrents;
  String _errorGetConcurrents = "";
  String get errorGetConcurrents => _errorGetConcurrents = "";
  final List<ConcurrentsModel> _concurrents = [];
  List<ConcurrentsModel> get concurrents => [..._concurrents];
  int get concurrentsCount => _concurrents.length;
  FocusNode concurrentsFocusNode = FocusNode();

  bool _isLoadingCreateConcurrents = false;
  bool get isLoadingCreateConcurrents => _isLoadingCreateConcurrents;
  String _errorCreateConcurrents = "";
  String get errorCreateConcurrents => _errorCreateConcurrents = "";

  void clearResearchPrices() {
    _researchPrices.clear();
    notifyListeners();
  }

  void clearConcurrents() {
    _concurrents.clear();
    notifyListeners();
  }

  Future<void> _getResearchPrices({required bool isExactCode}) async {
    try {
      await SoapHelper.soapPost(
        parameters: {
          "CrossIdentity": UserData.crossIdentity,
          "EnterpriseCode": 1,
          // "InitialCreationDate": DateTime.MinValue,
          // "FinalCreationDate": DateTime.Now,
          "SearchValue": isExactCode
              //ExactCode = 1, ApproximateName = 2
              ? 1
              : 2,
          "SearchTypeInt": 2
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorGetResearchPrices = SoapHelperResponseParameters.errorMessage;
    } catch (e) {}
  }

  Future<void> getResearchPrices(
    BuildContext context,
  ) async {
    _errorGetResearchPrices = "";
    _isLoadingGetResearchPrices = true;
    notifyListeners();

    await _getResearchPrices(isExactCode: true);
    if (_researchPrices == 0) {
      await _getResearchPrices(isExactCode: false);
    }

    if (_errorGetResearchPrices != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorGetResearchPrices,
        context: context,
      );
    } else {
      Map resultAsMap =
          json.decode(SoapHelperResponseParameters.responseAsString);
      _researchPrices.add(resultAsMap as ResearchsModel);
      //converter os dados para ResearchPricesModel
    }

    _isLoadingGetResearchPrices = false;
    notifyListeners();
  }

  Future<void> createConcurrentPrices(
    BuildContext context,
  ) async {
    _errorCreateConcurrents = "";
    _isLoadingCreateConcurrents = true;
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "ResearchOfPriceCode": 0,
          "ConcurrentCode": 0,
          "Name": "Name",
          "Observation": "Observation",
          // "Address" : JsonAddress.Default(),
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorCreateConcurrents = SoapHelperResponseParameters.errorMessage;
    } catch (e) {}

    if (_errorCreateConcurrents != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorCreateConcurrents,
        context: context,
      );
    } else {
      //converter os dados para ResearchPricesModel
      // Map resultAsMap =
      //     json.decode(SoapHelperResponseParameters.responseAsString);
    }

    _isLoadingCreateConcurrents = false;
    notifyListeners();
  }

  Future<void> _getConcurrents({required bool isExactCode}) async {
    try {
      await SoapHelper.soapPost(
        parameters: {
          "CrossIdentity": "CrossIdentity",
          "SearchValue": isExactCode ? 1 : 2,
          "SearchTypeInt": 2,
        },
        typeOfResponse: "UserCanLoginJsonResponse",
        SOAPAction: "UserCanLoginJson",
        serviceASMX: "CeltaSecurityService.asmx",
        typeOfResult: "UserCanLoginJsonResult",
      );
      _errorGetConcurrents = SoapHelperResponseParameters.errorMessage;
    } catch (e) {}
  }

  Future<void> getConcurrents(
    BuildContext context,
  ) async {
    _errorGetConcurrents = "";
    _isLoadingGetConcurrents = true;
    notifyListeners();

    await _getConcurrents(isExactCode: true);
    if (_concurrents == 0) {
      await _getConcurrents(isExactCode: false);
    }

    if (_errorGetConcurrents != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorGetConcurrents,
        context: context,
      );
    } else {
      //converter os dados para ResearchPricesModel
      Map resultAsMap =
          json.decode(SoapHelperResponseParameters.responseAsString);
      _concurrents.add(resultAsMap as ConcurrentsModel);
    }

    _isLoadingGetConcurrents = false;
    notifyListeners();
  }
}

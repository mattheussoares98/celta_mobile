import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Models/research_prices/research_prices.dart';
import '../api/api.dart';
import '../components/global_widgets/global_widgets.dart';
import '../utils/utils.dart';

class ResearchPricesProvider with ChangeNotifier {
  bool _isLoadingGetResearchPrices = false;
  bool get isLoadingResearchPrices => _isLoadingGetResearchPrices;
  String _errorGetResearchPrices = "";
  String get errorGetResearchPrices => _errorGetResearchPrices;
  final List<ResearchModel> _researchPrices = [];
  List<ResearchModel> get researchPrices => [..._researchPrices];
  int get researchPricesCount => _researchPrices.length;
  FocusNode researchPricesFocusNode = FocusNode();

  bool _isLoadingAddOrUpdateResearch = false;
  bool get isLoadingAddOrUpdateResearch => _isLoadingAddOrUpdateResearch;
  String _errorAddOrUpdateResearch = "";
  String get errorAddOrUpdateResearch => _errorAddOrUpdateResearch;

  bool _isLoadingConcurrents = false;
  bool get isLoadingConcurrents => _isLoadingConcurrents;
  String _errorConcurrents = "";
  String get errorConcurrents => _errorConcurrents;
  final List<ConcurrentsModel> _concurrents = [];
  List<ConcurrentsModel> get concurrents => [..._concurrents];
  int get concurrentsCount => _concurrents.length;
  FocusNode concurrentsFocusNode = FocusNode();

  void clearResearchPrices() {
    _researchPrices.clear();
    _errorGetResearchPrices = "";
    _isLoadingGetResearchPrices = false;
    notifyListeners();
  }

  void clearConcurrents() {
    _concurrents.clear();
    _errorConcurrents = "";
    _isLoadingConcurrents = false;
    notifyListeners();
  }

  Future<void> _getResearchPrices({
    required bool isExactCode,
    required int enterpriseCode,
  }) async {
    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
          // "creationDate" : "",
        },
        typeOfResponse: "GetResearchOfPriceResponse",
        SOAPAction: "GetResearchOfPrice",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetResearchOfPriceResult",
      );
      _errorGetResearchPrices = SoapHelperResponseParameters.errorMessage;
    } catch (e) {}
  }

  Future<void> getResearchPrices({
    required BuildContext context,
    required bool notifyListenersFromUpdate,
    required int enterpriseCode,
  }) async {
    _errorGetResearchPrices = "";
    _isLoadingGetResearchPrices = true;
    if (notifyListenersFromUpdate) notifyListeners();

    await _getResearchPrices(
      isExactCode: false,
      enterpriseCode: enterpriseCode,
    );
    // if (researchPricesCount == 0) {
    //   await _getResearchPrices(
    //     isExactCode: false,
    //     enterpriseCode: enterpriseCode,
    //   );
    // }

    if (_errorGetResearchPrices != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorGetResearchPrices,
        context: context,
      );
    } else {
      ResearchModel.resultAsStringToResearchModel(
        resultAsString: SoapHelperResponseParameters.responseAsString,
        listToAdd: _researchPrices,
      );
    }

    _isLoadingGetResearchPrices = false;
    if (notifyListenersFromUpdate) notifyListeners();
  }

  Future<void> addOrUpdateResearch({
    required BuildContext context,
    required bool isNewResearch,
    required String name,
    required String observations,
    required int enterpriseCode,
  }) async {
    _isLoadingAddOrUpdateResearch = true;
    _errorAddOrUpdateResearch = "";
    notifyListeners();

    try {
      var jsonBody = json.encode(
        {
          "CrossIdentity": UserData.crossIdentity,
          "Code": 1,
          "EnterpriseCode": 1,
          "EnterpriseName": "EnterpriseName",
          "CreationDate": "2024-02-27T16:31:58.4818772-03:00",
          "Name": "Name",
          "Observation": "Observations",
        },
      );
      await SoapHelper.soapPost(
        parameters: {
          "Json": jsonBody,
        },
        typeOfResponse: "InsertUpdateResearchOfPriceResponse",
        SOAPAction: "InsertUpdateResearchOfPrice",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateResearchOfPriceResult",
      );

      _errorAddOrUpdateResearch = SoapHelperResponseParameters.errorMessage;
      if (_errorAddOrUpdateResearch != "") {
        ShowSnackbarMessage.showMessage(
          message: _errorAddOrUpdateResearch,
          context: context,
        );
      } else {
        Map resultAsMap =
            json.decode(SoapHelperResponseParameters.responseAsString);
        _researchPrices.add(resultAsMap as ResearchModel);
        //converter os dados para ResearchPricesModel
      }
    } catch (e) {
      print(e.toString());
      _errorAddOrUpdateResearch = SoapHelperResponseParameters.errorMessage;
    }

    if (_errorAddOrUpdateResearch != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorAddOrUpdateResearch,
        context: context,
      );
    }

    _isLoadingAddOrUpdateResearch = false;
    notifyListeners();
  }

  Future<void> createConcurrentPrices({
    required BuildContext context,
    // required int researchOfPriceCode,
    // required String concurrentCode,
    // required String observation,
    // required String adress,
  }) async {
    _errorConcurrents = "";
    _isLoadingConcurrents = true;
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode({
            "ResearchOfPriceCode": 0,
            "ConcurrentCode": 0,
            "Name": "Name",
            "Observation": "Observation",
            "Address": "teste",
          })
        },
        typeOfResponse: "InsertUpdateConcurrentJsonResponse",
        SOAPAction: "InsertUpdateConcurrentJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateConcurrentJsonResult",
      );
      _errorConcurrents = SoapHelperResponseParameters.errorMessage;
    } catch (e) {
      _errorConcurrents = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }

    // if (_errorConcurrents != "") {
    //   ShowSnackbarMessage.showMessage(
    //     message: _errorConcurrents,
    //     context: context,
    //   );
    // } else {
    //   //converter os dados para ResearchPricesModel
    //   // Map resultAsMap =
    //   //     json.decode(SoapHelperResponseParameters.responseAsString);
    // }

    _isLoadingConcurrents = false;
    notifyListeners();
  }

  Future<void> _getConcurrents({required bool isExactCode}) async {
    var jsonBody = json.encode({
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": "",
      "SearchTypeInt": isExactCode ? 1 : 2,
    });
    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": jsonBody,
        },
        SOAPAction: "GetConcurrentJson",
        typeOfResponse: "GetConcurrentJsonResponse",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetConcurrentJsonResult",
      );
      _errorConcurrents = SoapHelperResponseParameters.errorMessage;
    } catch (e) {}
  }

  Future<void> getConcurrents({
    required BuildContext context,
    required bool notifyListenersFromUpdate,
  }) async {
    _errorConcurrents = "";
    _isLoadingConcurrents = true;
    if (notifyListenersFromUpdate) notifyListeners();

    await _getConcurrents(isExactCode: true);
    if (concurrentsCount == 0) {
      await _getConcurrents(isExactCode: false);
    }

    if (_errorConcurrents != "") {
      ShowSnackbarMessage.showMessage(
        message: _errorConcurrents,
        context: context,
      );
    } else {
      //converter os dados para ResearchPricesModel
      Map resultAsMap =
          json.decode(SoapHelperResponseParameters.responseAsString);
      _concurrents.add(resultAsMap as ConcurrentsModel);
    }

    _isLoadingConcurrents = false;
    notifyListeners();
  }
}

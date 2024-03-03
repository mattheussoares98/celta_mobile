import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/research_prices/research_prices.dart';
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

  bool _isLoadingAddOrUpdateConcurrents = false;
  bool get isLoadingAddOrUpdateConcurrents => _isLoadingAddOrUpdateConcurrents;
  String _errorConcurrents = "";
  String get errorConcurrents => _errorConcurrents;
  final List<ConcurrentsModel> _concurrents = [];
  List<ConcurrentsModel> get concurrents => [..._concurrents];
  int get concurrentsCount => _concurrents.length;
  FocusNode concurrentsFocusNode = FocusNode();

  ResearchModel? _selectedResearch;
  ResearchModel? get selectedResearch => _selectedResearch;
  updateSelectedResearch(ResearchModel? research) {
    _selectedResearch = research;
  }

  ConcurrentsModel? _selectedConcurrent;
  ConcurrentsModel? get selectedConcurrent => _selectedConcurrent;
  updateSelectedConcurrent(ConcurrentsModel? concurrent) {
    _selectedConcurrent = concurrent;
  }

  void clearResearchPrices() {
    _researchPrices.clear();
    _errorGetResearchPrices = "";
    _isLoadingGetResearchPrices = false;
    updateSelectedResearch(null);
    notifyListeners();
  }

  void clearConcurrents() {
    _concurrents.clear();
    _errorConcurrents = "";
    _isLoadingAddOrUpdateConcurrents = false;
    updateSelectedConcurrent(null);
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
    _researchPrices.clear();
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
    notifyListeners();
  }

  Future<void> addOrUpdateResearch({
    required BuildContext context,
    required int enterpriseCode,
    String? enterpriseName,
    String? observation,
    String? researchName,
    ResearchModel? research,
  }) async {
    _isLoadingAddOrUpdateResearch = true;
    _errorAddOrUpdateResearch = "";
    notifyListeners();

    try {
      var jsonBody = json.encode(
        {
          "CrossIdentity": UserData.crossIdentity,
          "Code": research == null ? 0 : research.Code,
          "EnterpriseCode": enterpriseCode,
          "EnterpriseName": enterpriseName,
          "CreationDate": DateTime.now().toIso8601String(),
          "Name": researchName,
          "Observation": observation,
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

  Future<void> addOrUpdateConcurrent({
    required BuildContext context,
    // required int researchOfPriceCode,
    // required String concurrentCode,
    // required String observation,
    // required String adress,
  }) async {
    _errorConcurrents = "";
    _isLoadingAddOrUpdateConcurrents = true;
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode({
            "CrossIdentity": UserData.crossIdentity,
            "ResearchOfPriceCode": 0,
            "ConcurrentCode": 0,
            "Name": "novo concorrente",
            "Observation": "nova observação",
          })
        },
        // "Address": "teste",
        typeOfResponse: "InsertUpdateConcurrentJsonResponse",
        SOAPAction: "InsertUpdateConcurrentJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateConcurrentJsonResult",
      );
      _errorConcurrents = SoapHelperResponseParameters.errorMessage;

      if (_errorConcurrents == "") {
        ShowSnackbarMessage.showMessage(
          message: "Concorrente inserido com sucesso!",
          backgroundColor: Colors.green,
          context: context,
        );
      }
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

    _isLoadingAddOrUpdateConcurrents = false;
    notifyListeners();
  }

  Future<void> _getConcurrents({
    required bool isExactCode,
    required BuildContext context,
  }) async {
    var jsonBody = json.encode({
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue":
          "%", // "SearchTypeInt - ExactCode = 1, ApproximateName = 2"
      "SearchTypeInt": 2,
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

      List resultAsList =
          json.decode(SoapHelperResponseParameters.responseAsString);
      ConcurrentsModel.addConcurrentsWithResultAsList(
        listToAdd: _concurrents,
        resultAsList: resultAsList,
      );
    } catch (e) {}
  }

  Future<void> getConcurrents({
    required BuildContext context,
    required bool notifyListenersFromUpdate,
  }) async {
    clearConcurrents();
    _isLoadingAddOrUpdateConcurrents = true;
    if (notifyListenersFromUpdate) notifyListeners();

    await _getConcurrents(isExactCode: false, context: context);

    _isLoadingAddOrUpdateConcurrents = false;
    notifyListeners();
  }
}

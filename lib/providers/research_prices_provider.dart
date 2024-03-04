import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../models/address/address.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';
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
  String _errorAddOrUpdateConcurrents = "";
  String get errorAddOrUpdateConcurrents => _errorAddOrUpdateConcurrents;
  final List<ConcurrentsModel> _concurrents = [];
  List<ConcurrentsModel> get concurrents => [..._concurrents];
  int get concurrentsCount => _concurrents.length;
  FocusNode concurrentsFocusNode = FocusNode();

  List<ResearchPricesProductsModel> _associatedsProducts = [];
  List<ResearchPricesProductsModel> get associatedsProducts =>
      [..._associatedsProducts];
  int get associatedsProductsCount => _associatedsProducts.length;
  List<ResearchPricesProductsModel> _notAssociatedsProducts = [];
  List<ResearchPricesProductsModel> get notAssociatedProducts =>
      [..._notAssociatedsProducts];
  int get notAssociatedProductsCount => _notAssociatedsProducts.length;

  String _errorGetAssociatedsProducts = "";
  String get errorGetAssociatedsProducts => _errorGetAssociatedsProducts;
  String _errorGetNotAssociatedsProducts = "";
  String get errorGetNotAssociatedsProducts => _errorGetNotAssociatedsProducts;

  bool _isLoadingGetProducts = false;
  bool get isLoadingGetProducts => _isLoadingGetProducts;

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
    _errorAddOrUpdateConcurrents = "";
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
    required int? enterpriseCode,
    String? enterpriseName,
    String? observation,
    String? researchName,
  }) async {
    _isLoadingAddOrUpdateResearch = true;
    _errorAddOrUpdateResearch = "";
    notifyListeners();

    try {
      var jsonBody = json.encode(
        {
          "CrossIdentity": UserData.crossIdentity,
          "Code": _selectedResearch == null ? 0 : _selectedResearch?.Code,
          "EnterpriseCode": _selectedResearch == null ? 0 : enterpriseCode,
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
        _selectedResearch = null;
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
    required AddressModel address,
    required String concurrentName,
    required String observation,
  }) async {
    _errorAddOrUpdateConcurrents = "";
    _isLoadingAddOrUpdateConcurrents = true;
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode({
            "CrossIdentity": UserData.crossIdentity,
            "ResearchOfPriceCode":
                _selectedResearch != null ? _selectedResearch!.Code : 0,
            "ConcurrentCode": _selectedConcurrent != null
                ? _selectedConcurrent!.ConcurrentCode
                : 0,
            "Name": concurrentName,
            "Observation": observation,
            "Address": address,
          })
        },
        typeOfResponse: "InsertUpdateConcurrentJsonResponse",
        SOAPAction: "InsertUpdateConcurrentJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateConcurrentJsonResult",
      );
      _errorAddOrUpdateConcurrents = SoapHelperResponseParameters.errorMessage;
    } catch (e) {
      _errorAddOrUpdateConcurrents =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    if (_errorAddOrUpdateConcurrents == "") {
      ShowSnackbarMessage.showMessage(
        message: "Concorrente cadastrado/alterado com sucesso!",
        backgroundColor: Colors.green,
        context: context,
      );
      _selectedConcurrent = null;
    } else {
      ShowSnackbarMessage.showMessage(
        message: _errorAddOrUpdateConcurrents,
        context: context,
      );
    }

    _isLoadingAddOrUpdateConcurrents = false;
    notifyListeners();
  }

  Future<void> _getConcurrents({
    required bool isExactCode,
    required BuildContext context,
  }) async {
    var jsonBody = json.encode({
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": "%",
      "SearchTypeInt":
          2, // "SearchTypeInt - ExactCode = 1, ApproximateName = 2"
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
      _errorAddOrUpdateConcurrents = SoapHelperResponseParameters.errorMessage;

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

  void clearAssociatedsProducts() {
    _associatedsProducts.clear();
    _errorGetAssociatedsProducts = "";
  }

  void clearNotAssociatedsProducts() {
    _notAssociatedsProducts.clear();
    _errorGetNotAssociatedsProducts = "";
  }

  Future<void> getProduct({
    required bool getAssociatedsProducts,
    required String searchProductControllerText,
    required BuildContext context,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _errorGetAssociatedsProducts = "";
    _isLoadingGetProducts = true;
    notifyListeners();

    // Map jsonGetProducts = {
    //   "CrossIdentity": UserData.crossIdentity,
    //   "RoutineInt": 7, //ResearchOfPrice
    //   "ResearchOfPriceCode": _selectedResearch!.Code,
    //   "AssociateInResearchOfPrice": getAssociatedsProducts, //Seta como true
    //   "SearchValue": searchProductControllerText,
    //   // "SearchTypeInt": configurationsProvider.useLegacyCode ? 11 : 0,
    //   "EnterpriseCodes": [2],
    // };
    Map jsonGetProducts = {
      "CrossIdentity": UserData.crossIdentity,
      "RoutineInt": 7,
      "SearchValue": searchProductControllerText,
      "EnterpriseCodes": [2],
      // "EnterpriseDestinyCode": 0,
      "SearchTypeInt": configurationsProvider.useLegacyCode ? 11 : 0,
      // "SearchType": 0,
      // "Routine": 0,
    };

    try {
      await SoapHelper.soapPost(
        parameters: {
          "filters": json.encode(jsonGetProducts),
        },
        typeOfResponse: "GetProductsJsonResponse",
        SOAPAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductsJsonResult",
      );

      _errorGetAssociatedsProducts = SoapHelperResponseParameters.errorMessage;

      SoapHelperResponseParameters.responseAsString;

      if (_errorGetAssociatedsProducts == "") {
        // BuyRequestProductsModel.responseAsStringToBuyRequestProductsModel(
        //   responseAsString: SoapHelperResponseParameters.responseAsString,
        //   listToAdd: _products,
        // );
      } else {
        ShowSnackbarMessage.showMessage(
          message: _errorGetAssociatedsProducts,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorGetAssociatedsProducts =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingGetProducts = false;
      notifyListeners();
    }
  }
}

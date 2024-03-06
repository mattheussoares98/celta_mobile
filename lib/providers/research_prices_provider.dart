import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../models/research_prices/research_prices.dart';
import '../../providers/providers.dart';
import '../utils/utils.dart';

class ResearchPricesProvider with ChangeNotifier {
  bool _isLoadingGetResearchPrices = false;
  bool get isLoadingResearchPrices => _isLoadingGetResearchPrices;
  String _errorGetResearchPrices = "";
  String get errorGetResearchPrices => _errorGetResearchPrices;
  List<ResearchModel> _researchPrices = [];
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

  bool _isLoadingGetConcurrents = false;
  bool get isLoadingGetConcurrents => _isLoadingGetConcurrents;
  String _errorGetConcurrents = "";
  String get errorGetConcurrents => _errorGetConcurrents;
  List<ConcurrentsModel> _concurrents = [];
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
    _errorGetConcurrents = "";
    _isLoadingAddOrUpdateConcurrents = false;
    updateSelectedConcurrent(null);
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
    } catch (e) {
      _errorGetResearchPrices = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }

    if (_errorGetResearchPrices == "") {
      _researchPrices = ResearchModel.convertResultToResearchModel();
    }

    _isLoadingGetResearchPrices = false;
    notifyListeners();
  }

  Map _jsonBodyAddOrUpdateResearch({
    required bool isAssociatingConcurrents,
    required int? enterpriseCode,
    String? observation,
    String? researchName,
  }) {
    if (isAssociatingConcurrents) {
      return {
        "CrossIdentity": UserData.crossIdentity,
        "Code": _selectedResearch == null
            ? 0 //0 pra cadastrar um novo
            : _selectedResearch?.Code,
        "EnterpriseCode": enterpriseCode,
        "Name": researchName,
        "Observation": observation,
        "IsAssociatingConcurrents": true,
        "Concurrents": [
          {
            "ResearchOfPriceCode": _selectedResearch!.Code,
            "ConcurrentCode": _selectedConcurrent!.ConcurrentCode,
            "Observation": _selectedConcurrent?.Observation,
          }
        ]
      };
    } else {
      return {
        "CrossIdentity": UserData.crossIdentity,
        "Code": _selectedResearch == null
            ? 0 //0 pra cadastrar um novo
            : _selectedResearch?.Code,
        "EnterpriseCode": enterpriseCode,
        "Name": researchName,
        "Observation": observation,
      };
    }
  }

  Future<void> addOrUpdateResearch({
    required bool isAssociatingConcurrents,
    required BuildContext context,
    required int? enterpriseCode,
    required String? observation,
    String? researchName,
  }) async {
    _isLoadingAddOrUpdateResearch = true;
    _errorAddOrUpdateResearch = "";
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode(
            _jsonBodyAddOrUpdateResearch(
              enterpriseCode: enterpriseCode,
              isAssociatingConcurrents: isAssociatingConcurrents,
              observation: observation,
              researchName: researchName,
            ),
          ),
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
      }

      _selectedResearch = null;
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
    required AddressProvider addressProvider,
    required String concurrentName,
    required String observation,
  }) async {
    _errorAddOrUpdateConcurrents = "";
    _isLoadingAddOrUpdateConcurrents = true;
    notifyListeners();

    Map jsonBody = {
      "ConcurrentCode":
          _selectedConcurrent != null ? _selectedConcurrent!.ConcurrentCode : 0,
      "CrossIdentity": UserData.crossIdentity,
      "Name": concurrentName,
      "Observation": observation,
    };
    if (addressProvider.addressesCount > 0) {
      //significa que adicionou um endereço e por isso precisa enviar o que foi adicionado
      jsonBody["Address"] = addressProvider.addresses[0].toJson();
    } else if (_selectedConcurrent?.Address.Zip != null &&
        //se o usuário tem um endereço, o ideal é mandar o mesmo endereço de novo. Se mandar sem a tag de endereço da erro
        _selectedConcurrent?.Address.Zip != "") {
      jsonBody["Address"] = _selectedConcurrent!.Address.toJson();
    }

    try {
      await SoapHelper.soapPost(
        parameters: {"json": json.encode(jsonBody)},
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
      await getConcurrents(
        searchConcurrentControllerText: "%",
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

  Future<void> getConcurrents({
    required String searchConcurrentControllerText,
  }) async {
    clearConcurrents();
    _isLoadingGetConcurrents = true;
    notifyListeners();

    var jsonBody = json.encode({
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": int.tryParse(searchConcurrentControllerText) != null
          ? int.parse(searchConcurrentControllerText)
          : searchConcurrentControllerText,

      "SearchTypeInt": int.tryParse(searchConcurrentControllerText) != null
          ? 1
          : 2, // "SearchTypeInt - ExactCode = 1, ApproximateName = 2"
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
      _errorGetConcurrents = SoapHelperResponseParameters.errorMessage;

      _concurrents = ConcurrentsModel.convertResultToListOfConcurrents();
    } catch (e) {
      _errorGetConcurrents = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }

    _isLoadingGetConcurrents = false;
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

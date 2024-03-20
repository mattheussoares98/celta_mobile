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
  final List<ResearchPricesResearchModel> _researchPrices = [];
  List<ResearchPricesResearchModel> get researchPrices => [..._researchPrices];
  int get researchPricesCount => _researchPrices.length;

  bool _isLoadingAddOrUpdateOfResearch = false;
  bool get isLoadingAddOrUpdateOfResearch => _isLoadingAddOrUpdateOfResearch;
  String _errorAddOrUpdateOfResearch = "";
  String get errorAddOrUpdateOfResearch => _errorAddOrUpdateOfResearch;

  bool _isLoadingAssociateConcurrentToResearch = false;
  bool get isLoadingAssociateConcurrentToResearch =>
      _isLoadingAssociateConcurrentToResearch;
  String _errorAssociateConcurrentToResearch = "";
  String get errorAssociateConcurrentToResearch =>
      _errorAssociateConcurrentToResearch;

  bool _isLoadingAddOrUpdateConcurrents = false;
  bool get isLoadingAddOrUpdateConcurrents => _isLoadingAddOrUpdateConcurrents;
  String _errorAddOrUpdateConcurrents = "";
  String get errorAddOrUpdateConcurrents => _errorAddOrUpdateConcurrents;

  bool _isLoadingGetConcurrents = false;
  bool get isLoadingGetConcurrents => _isLoadingGetConcurrents;
  String _errorGetConcurrents = "";
  String get errorGetConcurrents => _errorGetConcurrents;
  List<ResearchPricesConcurrentsModel> _concurrents = [];
  List<ResearchPricesConcurrentsModel> get concurrents => [..._concurrents];
  int get concurrentsCount => _concurrents.length;
  FocusNode concurrentsFocusNode = FocusNode();

  List<dynamic> _associatedsProducts = [];
  List<dynamic> get associatedsProducts => [..._associatedsProducts];
  int get associatedsProductsCount => _associatedsProducts.length;
  List<dynamic> _notAssociatedsProducts = [];
  List<dynamic> get notAssociatedProducts => [..._notAssociatedsProducts];
  int get notAssociatedProductsCount => _notAssociatedsProducts.length;
  bool _isLoadingGetProducts = false;
  bool get isLoadingGetProducts => _isLoadingGetProducts;

  String _errorGetAssociatedsProducts = "";
  String get errorGetAssociatedsProducts => _errorGetAssociatedsProducts;
  String _errorGetNotAssociatedsProducts = "";
  String get errorGetNotAssociatedsProducts => _errorGetNotAssociatedsProducts;

  bool _isLoadingInsertConcurrentPrices = false;
  bool get isLoadingInsertConcurrentPrices => _isLoadingInsertConcurrentPrices;
  String _errorInsertConcurrentPrices = "";
  String get errorInsertConcurrentPrices => _errorInsertConcurrentPrices;

  ResearchPricesResearchModel? _selectedResearch;
  ResearchPricesResearchModel? get selectedResearch => _selectedResearch;
  updateSelectedResearch(ResearchPricesResearchModel? research) {
    _selectedResearch = research;
  }

  ResearchPricesConcurrentsModel? _selectedConcurrent;
  ResearchPricesConcurrentsModel? get selectedConcurrent => _selectedConcurrent;
  updateSelectedConcurrent(ResearchPricesConcurrentsModel? concurrent) {
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

  bool _concurrentAlreadyIsAssociated() {
    return _selectedResearch!.Concurrents.contains(_selectedConcurrent);
  }

  void _addConcurrentInResearchs() {
    int index = _researchPrices.indexOf(_selectedResearch!);
    if (index != -1) {
      _researchPrices[index].Concurrents.add(_selectedConcurrent!);
    }
  }

  Future<void> associateConcurrentToResearchPrice({
    required BuildContext context,
    required int? enterpriseCode,
  }) async {
    if (_concurrentAlreadyIsAssociated()) return;
    _isLoadingAssociateConcurrentToResearch = true;
    _errorAssociateConcurrentToResearch = "";
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode(
            {
              "CrossIdentity": UserData.crossIdentity,
              "Code": _selectedResearch!.Code,
              "IsAssociatingConcurrents": true,
              "Concurrents": [
                {
                  "ResearchOfPriceCode": _selectedResearch!.Code,
                  "ConcurrentCode": _selectedConcurrent!.ConcurrentCode,
                  "Observation": _selectedConcurrent?.Observation,
                }
              ],
            },
          ),
        },
        typeOfResponse: "InsertUpdateResearchOfPriceResponse",
        SOAPAction: "InsertUpdateResearchOfPrice",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateResearchOfPriceResult",
      );

      _errorAssociateConcurrentToResearch =
          SoapHelperResponseParameters.errorMessage;

      if (_errorAssociateConcurrentToResearch.isNotEmpty) {
        ShowSnackbarMessage.showMessage(
          message: _errorAssociateConcurrentToResearch,
          context: context,
        );
      } else {
        _addConcurrentInResearchs();
      }
    } catch (e) {
      print(e.toString());
      _errorAssociateConcurrentToResearch =
          SoapHelperResponseParameters.errorMessage;
    }

    _isLoadingAssociateConcurrentToResearch = false;
    notifyListeners();
  }

  Future<void> getResearchPrices({
    required BuildContext context,
    required bool notifyListenersFromUpdate,
    required int enterpriseCode,
    required String searchText,
  }) async {
    _researchPrices.clear();
    _errorGetResearchPrices = "";
    _isLoadingGetResearchPrices = true;
    if (notifyListenersFromUpdate) notifyListeners();

    final jsonRequest = {
      "CrossIdentity": UserData.crossIdentity,
      "EnterpriseCode": enterpriseCode,
      // "InitialCreationDate": "0001-01-01T00:00:00",
      // "FinalCreationDate": DateTime.now().toIso8601String(),
      "SearchValue":
          int.tryParse(searchText) != null ? int.parse(searchText) : searchText,

      "SearchTypeInt": int.tryParse(searchText) != null ? 1 : 2,
    };

    try {
      await SoapHelper.soapPost(
        parameters: {"json": json.encode(jsonRequest)},
        typeOfResponse: "GetResearchOfPriceJsonResponse",
        SOAPAction: "GetResearchOfPriceJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetResearchOfPriceJsonResult",
      );
      SoapHelperResponseParameters.responseAsMap;
      SoapHelperResponseParameters.responseAsString;
      _errorGetResearchPrices = SoapHelperResponseParameters.errorMessage;
    } catch (e) {
      _errorGetResearchPrices = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }

    if (_errorGetResearchPrices == "") {
      _researchPrices.addAll(
        ResearchPricesResearchModel.convertResultToResearchModel(),
      );
    }

    _isLoadingGetResearchPrices = false;
    notifyListeners();
  }

  Future<void> addOrUpdateResearchOfPrice({
    required BuildContext context,
    required int enterpriseCode,
    String? observation,
    String? name,
  }) async {
    _isLoadingAddOrUpdateOfResearch = true;
    _errorAddOrUpdateOfResearch = "";
    notifyListeners();

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode(
            {
              "CrossIdentity": UserData.crossIdentity,
              "Code": _selectedResearch == null
                  ? 0 //0 pra cadastrar um novo
                  : _selectedResearch?.Code,
              "EnterpriseCode": enterpriseCode,
              "Name": name,
              "Observation": observation,
            },
          ),
        },
        typeOfResponse: "InsertUpdateResearchOfPriceResponse",
        SOAPAction: "InsertUpdateResearchOfPrice",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "InsertUpdateResearchOfPriceResult",
      );

      _errorAddOrUpdateOfResearch = SoapHelperResponseParameters.errorMessage;

      if (_errorAddOrUpdateOfResearch.isNotEmpty) {
        ShowSnackbarMessage.showMessage(
          message: _errorAddOrUpdateOfResearch,
          context: context,
        );
      } else if (_selectedResearch != null) {
        //só precisa alterar a pesquisa se houver alguma selecionada. Se não
        //houver uma pesquisa selecionada, significa que está cadastrando uma
        //nova e por isso não precisa alterar
        int index = _researchPrices.indexOf(_selectedResearch!);

        if (index != -1) {
          _researchPrices[index].Name = name;
          _researchPrices[index].Observation = observation;
        }
      }
    } catch (e) {
      print(e.toString());
      _errorAddOrUpdateOfResearch = SoapHelperResponseParameters.errorMessage;
    }

    _isLoadingAddOrUpdateOfResearch = false;
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
        getAllConcurrents: true,
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
    required bool getAllConcurrents,
  }) async {
    if (!getAllConcurrents) clearConcurrents();

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

      if (_errorGetConcurrents == "") {
        _concurrents.addAll(
          ResearchPricesConcurrentsModel.convertResultToListOfConcurrents()
              .where(
            (newConcurrent) => !_concurrents.any(
              (concurrent) =>
                  //adiciona o concorrente somente se não houver um com o mesmo
                  //código
                  concurrent.ConcurrentCode == newConcurrent.ConcurrentCode,
            ),
          ),
        );
      }
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

  Future<void> getAssociatedProducts({
    required String searchProductControllerText,
    required BuildContext context,
    required bool? withPrices,
  }) async {
    _errorGetAssociatedsProducts = "";
    _isLoadingGetProducts = true;
    _associatedsProducts.clear();
    notifyListeners();

    Map jsonGetProducts = {
      "CrossIdentity": UserData.crossIdentity,
      "ResearchOfPriceCode": _selectedResearch!.Code,
      "ConcurrentCode": _selectedConcurrent!.ConcurrentCode,
      "WithPrices":
          withPrices, //Null (Todos) | True (preços informados) | False (sem preços informados)
    };

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": json.encode(jsonGetProducts),
        },
        typeOfResponse: "GetConcurrentProductsJsonResponse",
        SOAPAction: "GetConcurrentProductsJson",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
        typeOfResult: "GetConcurrentProductsJsonResult",
      );

      _errorGetAssociatedsProducts = SoapHelperResponseParameters.errorMessage;

      if (_errorGetAssociatedsProducts == "") {
        _associatedsProducts.addAll(
          ResearchPricesProductsModel.resultAsStringToProductsModel(),
        );
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

  Future<void> getNotAssociatedProducts({
    required String searchProductControllerText,
  }) async {
    _errorGetNotAssociatedsProducts = "";
    _isLoadingGetProducts = true;
    _notAssociatedsProducts.clear();
    notifyListeners();

    Map jsonGetProducts = {
      "CrossIdentity": UserData.crossIdentity,
      "RoutineInt": 7,
      "SearchValue": searchProductControllerText,
      "ResearchOfPriceFilters": {
        "ResearchOfPriceCode": _selectedResearch!.Code,
        "ConcurrentCode": _selectedConcurrent!.ConcurrentCode,
      },
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

      _errorGetNotAssociatedsProducts =
          SoapHelperResponseParameters.errorMessage;

      if (_errorGetNotAssociatedsProducts == "") {
        _notAssociatedsProducts.addAll(
          ResearchPricesProductsModel.resultAsStringToProductsModel(),
        );
      }
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorGetNotAssociatedsProducts =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingGetProducts = false;
      notifyListeners();
    }
  }

  void loadAssociatedsConcurrents() {
    _researchPrices.forEach((research) {
      if (research.Code == _selectedResearch!.Code) {
        _concurrents.clear();
        _concurrents.addAll(research.Concurrents);
      }
    });
    notifyListeners();
  }

  Map _jsonInsertConcurrentPrices({
    required int productCode,
    required String priceLookUp,
    required String productName,
    required double? priceRetail,
    required double? offerRetail,
    required double? priceWhole,
    required double? offerWhole,
    required double? priceECommerce,
    required double? offerECommerce,
  }) {
    Map jsonInsertConcurrentPrices = {
      "CrossIdentity": UserData.crossIdentity,
      "ResearchOfPriceCode": _selectedResearch!.Code,
      "ConcurrentCode": _selectedConcurrent!.ConcurrentCode,
      "ProductPackingCode": productCode,
      "PriceLookUp": priceLookUp,
      "ProductName": productName,
      // "PriceRetail": 1, //somente para teste
      // "OfferRetail": 2, //somente para teste
      // "PriceWhole": 3, //somente para teste
      // "OfferWhole": 4, //somente para teste
      // "PriceECommerce": 5, //somente para teste
      // "OfferECommerce": 6, //somente para teste
    };

    if (priceRetail != null) {
      jsonInsertConcurrentPrices.putIfAbsent("PriceRetail", () => priceRetail);
    }
    if (offerRetail != null) {
      jsonInsertConcurrentPrices.putIfAbsent("OfferRetail", () => offerRetail);
    }
    if (priceWhole != null) {
      jsonInsertConcurrentPrices.putIfAbsent("PriceWhole", () => priceWhole);
    }
    if (offerWhole != null) {
      jsonInsertConcurrentPrices.putIfAbsent("OfferWhole", () => offerWhole);
    }
    if (priceECommerce != null) {
      jsonInsertConcurrentPrices.putIfAbsent(
          "PriceECommerce", () => priceECommerce);
    }
    if (offerECommerce != null) {
      jsonInsertConcurrentPrices.putIfAbsent(
          "OfferECommerce", () => offerECommerce);
    }

    return jsonInsertConcurrentPrices;
  }

  Future<void> insertConcurrentPrices({
    required int productCode,
    required String priceLookUp,
    required String productName,
    required BuildContext context,
    required double? priceRetail,
    required double? offerRetail,
    required double? priceWhole,
    required double? offerWhole,
    required double? priceECommerce,
    required double? offerECommerce,
  }) async {
    _errorInsertConcurrentPrices = "";
    _isLoadingInsertConcurrentPrices = true;
    notifyListeners();

    Map jsonInsertConcurrentPrices = _jsonInsertConcurrentPrices(
      productCode: productCode,
      priceLookUp: priceLookUp,
      productName: productName,
      priceRetail: priceRetail,
      offerRetail: offerRetail,
      priceWhole: priceWhole,
      offerWhole: offerWhole,
      priceECommerce: priceECommerce,
      offerECommerce: offerECommerce,
    );

    try {
      await SoapHelper.soapPost(
        parameters: {
          "json": [json.encode(jsonInsertConcurrentPrices)],
        },
        typeOfResponse: "InsertConcurrentProductResponse",
        SOAPAction: "InsertConcurrentProduct",
        serviceASMX: "CeltaResearchOfPriceService.asmx",
      );

      _errorInsertConcurrentPrices = SoapHelperResponseParameters.errorMessage;
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorInsertConcurrentPrices =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingInsertConcurrentPrices = false;
      notifyListeners();
    }
  }
}

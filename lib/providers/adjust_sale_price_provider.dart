import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../Models/models.dart';
import '../utils/utils.dart';
import 'providers.dart';

class AdjustSalePriceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => [..._products];

  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> get schedules => [..._schedules];

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  String _errorMessageSchedule = "";
  String get errorMessageSchedule => _errorMessageSchedule;

  List<SaleTypeModel> _saleTypes = [];
  List<SaleTypeModel> get saleTypes => [..._saleTypes];

  List<PriceTypeModel> _priceTypes = [
    PriceTypeModel(priceTypeName: PriceTypeName.Venda),
    PriceTypeModel(priceTypeName: PriceTypeName.Oferta),
  ];
  List<PriceTypeModel> get priceTypes => [..._priceTypes];

  List<ReplicationModel> _replicationParameters = [];
  List<ReplicationModel> get replicationParameters =>
      [..._replicationParameters];

  DateTime? _initialDate;
  DateTime? get initialDate => _initialDate;
  set initialDate(DateTime? newDate) => _initialDate = newDate;

  DateTime? _finishDate;
  DateTime? get finishDate => _finishDate;
  set finishDate(DateTime? newDate) => _finishDate = newDate;

  void addUsedSaleTypes(EnterpriseModel enterpriseModel) {
    _saleTypes.clear();

    if (enterpriseModel.useRetailSale) {
      _saleTypes.add(SaleTypeModel.fromSaleTypeName(SaleTypeName.Varejo));
    }
    if (enterpriseModel.useWholeSale) {
      _saleTypes.add(SaleTypeModel.fromSaleTypeName(SaleTypeName.Atacado));
    }
    if (enterpriseModel.useEcommerceSale) {
      _saleTypes.add(SaleTypeModel.fromSaleTypeName(SaleTypeName.Ecommerce));
    }
  }

  void updateSelectedPriceType(int index) {
    _unselectAllPriceTypes();
    _priceTypes[index].selected = true;
    notifyListeners();
  }

  void _unselectAllPriceTypes() {
    for (var priceType in _priceTypes) {
      priceType.selected = false;
    }
  }

  void updateSelectedSaleType(int index) {
    _unselectAllSaleTypes();

    _saleTypes[index].selected = true;
  }

  void _unselectAllSaleTypes() {
    for (var saleType in _saleTypes) {
      saleType.selected = false;
    }
  }

  void clearDataOnCloseAdjustPriceScreen() {
    _schedules.clear();
    _errorMessageSchedule = "";
    _unselectAllPriceTypes();
    _unselectAllSaleTypes();
    _clearReplicationParameters();
    initialDate = null;
    finishDate = null;
  }

  void _clearReplicationParameters() {
    _replicationParameters.clear();
  }

  void clearDataOnCloseProductsScreen() {
    _products.clear();
    _errorMessage = "";
  }

  Future<void> getProducts({
    required EnterpriseModel enterprise,
    required String searchValue,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _isLoading = true;
    _products.clear();
    _errorMessage = "";
    notifyListeners();

    try {
      _products = await SoapHelper.getProductsJsonModel(
        enterprise: enterprise,
        searchValue: searchValue,
        configurationsProvider: configurationsProvider,
        enterprisesCodes: [enterprise.Code],
        routineTypeInt: 8,
      );

      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getProductSchedules({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
  }) async {
    _isLoading = true;
    _errorMessageSchedule = "";
    _schedules.clear();
    notifyListeners();

    try {
      Map jsonGetSchedules = {
        "CrossIdentity": UserData.crossIdentity,
        "EnterpriseCode": enterpriseCode,
        "ProductCode": productCode,
        "ProductPackingCode": productPackingCode,
        "SaleTypeInt": 1,
      };
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(jsonGetSchedules),
        },
        typeOfResponse: "GetPriceSchedulesResponse",
        SOAPAction: "GetPriceSchedules",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetPriceSchedulesResult",
      );
      _errorMessageSchedule = SoapRequestResponse.errorMessage;

      if (_errorMessageSchedule != "") {
        return;
      }

      final List teste = json.decode(SoapRequestResponse.responseAsString);

      _schedules = teste.map((e) => ScheduleModel.fromJson(e)).toList();

      if (_schedules.isEmpty) {
        _errorMessageSchedule =
            "Não foram encontrados agendamentos para esse produto";
      }
    } catch (e) {
      _errorMessageSchedule = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool allObligatoryDataAreInformed() {
    int priceTypeIndex = _priceTypes.indexWhere((e) => e.selected == true);
    int saleTypeIndex = _saleTypes.indexWhere((e) => e.selected == true);

    return (priceTypeIndex != -1 && saleTypeIndex != -1);
  }

  bool offerPriceIsSelected() {
    return _priceTypes
        .firstWhere((e) => e.priceTypeName == PriceTypeName.Oferta)
        .selected;
  }

  void addPermittedReplicationParameters(
    GetProductJsonModel product,
    EnterpriseModel enterprise,
  ) {
    _replicationParameters.add(
      ReplicationModel(
        replicationName: ReplicationNames.Packings,
      ),
    );

    if (product.isFatherOfGrate == true || product.isChildOfGrate == true) {
      _replicationParameters.add(
        ReplicationModel(
          replicationName: ReplicationNames.Grid,
        ),
      );
    }
    if (product.inClass == true) {
      _replicationParameters.add(
        ReplicationModel(
          replicationName: ReplicationNames.Class,
          selected: product.markUpdateClassInAdjustSalePriceIndividual == true,
        ),
      );
    }

    if (enterprise.EnterpriseParticipateEnterpriseGroup == true) {
      _replicationParameters.add(
        ReplicationModel(
          replicationName: ReplicationNames.OperationalGrouping,
        ),
      );
    }

    notifyListeners();
  }

  bool _getReplicationIsSelected(ReplicationNames replicationName) {
    int index = _replicationParameters
        .indexWhere((e) => e.replicationName == replicationName);

    if (index != -1) {
      return _replicationParameters[index].selected;
    } else {
      return false;
    }
  }

  Map<String, dynamic> _getJsonRequest({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required double price,
    required DateTime? effectuationDatePrice,
    required DateTime? effectuationDateOffer,
    required DateTime? endDateOffer,
  }) {
    final Map<String, dynamic> jsonRequest = {
      "CrossIdentity": UserData.crossIdentity,
      "EnterpriseCode": enterpriseCode,
      "ProductCode": productCode,
      "ProductPackingCode": productPackingCode,
      "UpdatePriceClass": _getReplicationIsSelected(ReplicationNames.Class),
      "UpdatePackings": _getReplicationIsSelected(ReplicationNames.Packings),
      "UpdateEnterpriseGroup":
          _getReplicationIsSelected(ReplicationNames.OperationalGrouping),
      "UpdateGrate": _getReplicationIsSelected(ReplicationNames.Grid),
      "SaleTypeInt": _saleTypes
          .firstWhere((e) => e.selected == true)
          .priceTypeInt, //1 == varejo; 2 == atacado; 3 == ecommerce
    };

    if (offerPriceIsSelected()) {
      jsonRequest["Offer"] = price;

      jsonRequest["EffectuationDateOffer"] =
          (effectuationDateOffer ?? DateTime.now()).toIso8601String();
      if (endDateOffer != null) {
        jsonRequest["EndDateOffer"] = endDateOffer.toIso8601String();
      }
    } else {
      jsonRequest["EffectuationDatePrice"] =
          (effectuationDatePrice ?? DateTime.now()).toIso8601String();
      jsonRequest["Price"] = price;
    }

    return jsonRequest;
  }

  Future<void> confirmAdjust({
    required int enterpriseCode,
    required int productCode,
    required int productPackingCode,
    required double price,
    required DateTime? effectuationDatePrice,
    required DateTime? effectuationDateOffer,
    required DateTime? endDateOffer,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      FirebaseHelper.addSoapCallInFirebase(
        FirebaseCallEnum.adjustSalePrice,
      );
      final jsonRequest = _getJsonRequest(
        enterpriseCode: enterpriseCode,
        productCode: productCode,
        productPackingCode: productPackingCode,
        price: price,
        effectuationDatePrice: effectuationDatePrice,
        effectuationDateOffer: effectuationDateOffer,
        endDateOffer: endDateOffer,
      );

      await SoapRequest.soapPost(
        parameters: {
          "parameters": json.encode(jsonRequest),
        },
        typeOfResponse: "AdjustSalePriceResponse",
        SOAPAction: "AdjustSalePrice",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "AdjustSalePriceResult",
      );
      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

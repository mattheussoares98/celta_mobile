import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import 'providers.dart';

class BuyQuotationProvider with ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GetProductJsonModel> _searchedProducts = [];
  List<GetProductJsonModel> get searchedProducts => [..._searchedProducts];
  GetProductJsonModel? _selectedProduct;
  GetProductJsonModel? get selectedProduct => _selectedProduct;

  List<SupplierModel> _searchedSuppliers = [];
  List<SupplierModel> get searchedSuppliers => [..._searchedSuppliers];
  SupplierModel? _selectedSupplier;
  SupplierModel? get selectedSupplier => _selectedSupplier;

  List<BuyerModel> _searchedBuyers = [];
  List<BuyerModel> get searchedBuyers => [..._searchedBuyers];
  BuyerModel? _selectedBuyer;
  BuyerModel? get selectedBuyer => _selectedBuyer;

  List<BuyQuotationIncompleteModel> _incompletesBuyQuotations = [];
  List<BuyQuotationIncompleteModel> get incompletesBuyQuotations =>
      [..._incompletesBuyQuotations];

  void doOnPopScreen() {
    _searchedBuyers.clear();
    _searchedProducts.clear();
    _searchedSuppliers.clear();
    _selectedBuyer = null;
    _selectedProduct = null;
    _selectedSupplier = null;
  }

  Future<void> insertUpdateBuyQuotation({
    required bool isInserting,
  }) async {
    _isLoading = true;
    _errorMessage = "";

    try {} catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  Future<void> getBuyQuotation({
    required BuildContext context,
    required String valueToSearch,
    required bool searchByPersonalizedCode,
    required int enterpriseCode,
    DateTime? initialDateOfCreation,
    DateTime? finalDateOfCreation,
    DateTime? initialDateOfLimit,
    DateTime? finalDateOfLimit,
    int? supplierCode,
    // int? buyerCode,
    bool? inclusiveExpired,
    bool? complete = false,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    _incompletesBuyQuotations.clear();
    notifyListeners();

    try {
      final filters = {
        "CrossIdentity": UserData.crossIdentity,
        "Complete": complete,
        "Data": valueToSearch.isEmpty ? "%" : valueToSearch,
        "DataType": searchByPersonalizedCode
            ? 2 // 2-Codigo personalizado
            : 1, //1-Codigo
        "InitialDateOfCreation": initialDateOfCreation?.toIso8601String(),
        "FinalDateOfCreation": finalDateOfCreation?.toIso8601String(),
        "InitialDateOfLimit": initialDateOfLimit?.toIso8601String(),
        "FinalDateOfLimit": finalDateOfLimit?.toIso8601String(),
        "ProductCode": _selectedProduct?.productCode,
        "ProductPackingCode": _selectedProduct?.productPackingCode,
        "SupplierCode": supplierCode,
        "BuyerCode":
            null, //se mandar o código 0, leva em consideração o funcionário vinculado ao usuário. Vou deixar sem esse filtro
        "EnterpriseCode": enterpriseCode,
        "InclusiveExpired": inclusiveExpired == true,
      };
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(filters),
        },
        typeOfResponse: "GetBuyQuotationJsonResponse",
        SOAPAction: "GetBuyQuotationJson",
        serviceASMX: "CeltaBuyRequestService.asmx",
        typeOfResult: "GetBuyQuotationJsonResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage != "") {
        ShowSnackbarMessage.show(
          message: _errorMessage,
          context: context,
        );
      } else {
        _incompletesBuyQuotations = (json.decode(
                    SoapRequestResponse.responseAsString.removeBreakLines())
                as List)
            .map((e) => BuyQuotationIncompleteModel.fromJson(e))
            .toList();
      }
      SoapRequestResponse.responseAsMap;
      SoapRequestResponse.responseAsString;
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessage,
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProduct({
    required EnterpriseModel enterprise,
    required TextEditingController searchProductController,
    required ConfigurationsProvider configurationsProvider,
    required BuildContext context,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    _searchedProducts.clear();
    _selectedProduct = null;
    notifyListeners();

    try {
      await SoapHelper.getProductJsonModel(
        listToAdd: _searchedProducts,
        enterprise: enterprise,
        searchValue: searchProductController.text,
        configurationsProvider: configurationsProvider,
        routineTypeInt: 9,
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage != "") {
        ShowSnackbarMessage.show(
          message: _errorMessage,
          context: context,
        );
      } else {
        _searchedProducts =
            (json.decode(SoapRequestResponse.responseAsString) as List)
                .map((e) => GetProductJsonModel.fromJson(e))
                .toList();

        if (_searchedProducts.length == 1) {
          updateSelectedProduct(_searchedProducts[0]);
        }
      }

      searchProductController.text = "";
    } catch (e) {
      ShowSnackbarMessage.show(
        message: e.toString(),
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedProduct(GetProductJsonModel? product) {
    _searchedProducts.clear();
    _selectedProduct = product;
    notifyListeners();
  }

  void updateSelectedSupplier(SupplierModel? supplier) {
    _searchedSuppliers.clear();
    _selectedSupplier = supplier;
    notifyListeners();
  }

  Future<void> searchSupplier({
    required BuildContext context,
    required TextEditingController searchController,
  }) async {
    _isLoading = false;
    _errorMessage = "";
    _searchedSuppliers.clear();
    _selectedSupplier = null;
    notifyListeners();

    Map jsonGetSupplier = {
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": searchController.text,
      "RoutineInt": 9,
    };

    try {
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(jsonGetSupplier),
        },
        serviceASMX: "CeltaSupplierService.asmx",
        typeOfResponse: "GetSupplierJsonResponse",
        SOAPAction: "GetSupplierJson",
        typeOfResult: "GetSupplierJsonResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage != "") {
        ShowSnackbarMessage.show(message: _errorMessage, context: context);
      } else {
        _searchedSuppliers =
            (json.decode(SoapRequestResponse.responseAsString) as List)
                .map((e) => SupplierModel.fromJson(e))
                .toList();
        if (_searchedSuppliers.length == 1) {
          _selectedSupplier = _searchedSuppliers[0];
        }
      }
    } catch (e) {
      ShowSnackbarMessage.show(message: e.toString(), context: context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedBuyer(BuyerModel? buyer) {
    _selectedBuyer = buyer;
    notifyListeners();
  }

  Future<void> searchBuyer(BuildContext context) async {
    _isLoading = false;
    _errorMessage = "";
    _searchedBuyers.clear();
    _selectedBuyer = null;
    notifyListeners();

    try {
      _searchedBuyers = await SoapHelper.getBuyers();

      if (SoapRequestResponse.errorMessage != "") {
        ShowSnackbarMessage.show(
          message: SoapRequestResponse.errorMessage,
          context: context,
        );
      } else if (_searchedBuyers.length == 1) {
        _selectedBuyer = _searchedBuyers[0];
      }
    } catch (e) {
      ShowSnackbarMessage.show(message: e.toString(), context: context);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

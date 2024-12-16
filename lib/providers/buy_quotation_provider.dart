import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/enterprise/enterprise.dart';
import '../models/soap/soap.dart';
import '../utils/utils.dart';
import 'providers.dart';

class BuyQuotationProvider with ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GetProductJsonModel> _searchedProducts = [];
  List<GetProductJsonModel> get searchedProducts => [..._searchedProducts];

  GetProductJsonModel? _filteredProduct;
  GetProductJsonModel? get filteredProduct => _filteredProduct;

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
    required DateTime? initialDateOfCreation,
    required DateTime? finalDateOfCreation,
    required DateTime? initialDateOfLimit,
    required DateTime? finalDateOfLimit,
    required int enterpriseCode,
    int? productCode,
    int? productPackingCode,
    int? supplierCode,
    int? buyerCode,
    bool? inclusiveExpired,
  }) async {
    _isLoading = true;
    _errorMessage = "";

    try {
      final filters = {
        "CrossIdentity": UserData.crossIdentity,
        "Complete": false,
        // "Data": valueToSearch.isEmpty ? "%" : valueToSearch,
        // "DataType": searchByPersonalizedCode
        //     ? 2 // 2-Codigo personalizado
        //     : 1, //1-Codigo
        "InitialDateOfCreation": initialDateOfCreation?.toIso8601String(),
        "FinalDateOfCreation": finalDateOfCreation?.toIso8601String(),
        "InitialDateOfLimit": initialDateOfLimit?.toIso8601String(),
        "FinalDateOfLimit": finalDateOfLimit?.toIso8601String(),
        "ProductCode": productCode,
        "ProductPackingCode": productPackingCode,
        "SupplierCode": supplierCode,
        "BuyerCode": buyerCode,
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
    _filteredProduct = null;
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
          updateFilteredProduct(_searchedProducts[0]);
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

  void updateFilteredProduct(GetProductJsonModel? product) {
    _filteredProduct = product;
    notifyListeners();
  }
}

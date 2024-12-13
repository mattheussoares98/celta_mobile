import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../utils/utils.dart';

class BuyQuotationProvider with ChangeNotifier {
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
    required DateTime initialDateOfCreation,
    required DateTime finalDateOfCreation,
    required DateTime initialDateOfLimit,
    required DateTime finalDateOfLimit,
    int? productCode,
    int? productPackingCode,
    int? supplierCode,
    int? buyerCode,
    int? enterpriseCode,
    bool? inclusiveExpired,
  }) async {
    _isLoading = true;
    _errorMessage = "";

    try {
      final filters = {
        "CrossIdentity": UserData.crossIdentity,
        "Complete": false,
        "Data": valueToSearch,
        "DataType": searchByPersonalizedCode
            ? 2 // 2-Codigo personalizado
            : 1, //1-Codigo
        "InitialDateOfCreation": initialDateOfCreation.toIso8601String(),
        "FinalDateOfCreation": finalDateOfCreation.toIso8601String(),
        "InitialDateOfLimit": initialDateOfLimit.toIso8601String(),
        "FinalDateOfLimit": finalDateOfLimit.toIso8601String(),
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
}

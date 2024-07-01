import '../../models/soap/soap.dart';

import '../../utils/utils.dart';
import 'soap.dart';

class SoapHelper {
  static Future<void> getGetProductCmxJson({
    required int enterpriseCode,
    required String searchValue,
    required bool isLegacyCodeSearch,
    required List<GetProductCmxJson> listToAdd,
  }) async {
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
          "searchValue": searchValue,
          "searchTypeInt": isLegacyCodeSearch ? 11 : 0,
        },
        typeOfResponse: "GetProductCmxJsonResponse",
        SOAPAction: "GetProductCmxJson",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductCmxJsonResult",
      );

      if (SoapRequestResponse.errorMessage != "") {
        throw Exception();
      }

      GetProductCmxJson.dataToGetProductCmxJson(
        data: SoapRequestResponse.responseAsMap,
        listToAdd: listToAdd,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> getStockTypesModel(
    List<GetStockTypesModel> listToAdd,
  ) async {
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "simpleSearchValue": "undefined",
        },
        typeOfResponse: "GetStockTypesResponse",
        SOAPAction: "GetStockTypes",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetStockTypesResult",
      );

      if (SoapRequestResponse.errorMessage != "") {
        throw Exception();
      }

      GetStockTypesModel.resultAsStringToGetStockTypesModel(
        resultAsString: SoapRequestResponse.responseAsString,
        listToAdd: listToAdd,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> getJustifications({
    required int justificationTransferType,
    required List<GetJustificationsModel> listToAdd,
  }) async {
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          'simpleSearchValue': 'undefined',
          "justificationTransferType": justificationTransferType,
        },
        typeOfResponse: "GetJustificationsResponse",
        typeOfResult: "GetJustificationsResult",
        SOAPAction: "GetJustifications",
        serviceASMX: "CeltaProductService.asmx",
      );

      if (SoapRequestResponse.errorMessage != "") {
        throw Exception();
      }

      GetJustificationsModel.resultAsStringToJustificationsModel(
        resultAsString: SoapRequestResponse.responseAsString,
        listToAdd: listToAdd,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> getProductJsonModel({
    required List<GetProductJsonModel> listToAdd,
    required int enterpriseCode,
    required String searchValue,
    required bool isLegacyCodeSearch,
    required int routineTypeInt,
  }) async {
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
          "searchValue": searchValue,
          "searchTypeInt": isLegacyCodeSearch ? 11 : 0,
          //   {
          // Generic = 0,
          // SaleRequest = 1,
          // BuyRequest = 2,
          // TransferRequest = 3,
          // PriceConference = 4,
          // AdjustStock = 5,
          // GoodsReceiving = 6,
          // ResearchOfPrice = 7,
          // AdjustSalePrice = 8
          //   }
          "routineTypeInt": routineTypeInt,
        },
        typeOfResponse: "GetProductJsonResponse",
        typeOfResult: "GetProductJsonResult",
        SOAPAction: "GetProductJson",
        serviceASMX: "CeltaProductService.asmx",
      );

      if (SoapRequestResponse.errorMessage != "") {
        throw Exception();
      }

      GetProductJsonModel.responseAsStringToGetProductJsonModel(
        responseAsString: SoapRequestResponse.responseAsString,
        listToAdd: listToAdd,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> confirmAdjustStock(
    Map<String, dynamic> jsonAdjustStock,
  ) async {
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "jsonAdjustStock": jsonAdjustStock,
        },
        typeOfResponse: "ConfirmAdjustStockResponse",
        SOAPAction: "ConfirmAdjustStock",
        serviceASMX: "CeltaProductService.asmx",
      );

      if (SoapRequestResponse.errorMessage != "") {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }
}

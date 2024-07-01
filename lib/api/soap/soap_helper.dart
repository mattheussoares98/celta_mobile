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

  static Future<void> getStockTypesModel({
    required int enterpriseCode,
    required String searchValue,
    required bool isLegacyCodeSearch,
    required List<GetStockTypesModel> listToAdd,
  }) async {
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
}

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

  // static Future<void> getJustifications({
  //   required int justificationTransferType,
  //   required GetJustificationsModel listToAdd,
  // }) async {
  //   try {
  //     await SoapRequest.soapPost(
  //       parameters: {
  //         "crossIdentity": UserData.crossIdentity,
  //         'simpleSearchValue': 'undefined',
  //         "justificationTransferType": justificationTransferType,
  //       },
  //       typeOfResponse: "GetJustificationsResponse",
  //       typeOfResult: "GetJustificationsResult",
  //       SOAPAction: "GetJustifications",
  //       serviceASMX: "CeltaProductService.asmx",
  //     );

  //     if (SoapRequestResponse.errorMessage != "") {
  //       throw Exception();
  //     }

  //     if (_errorMessageTypeStockAndJustifications == "") {
  //       TransferBetweenStocksJustificationsModel
  //           .resultAsStringToTransferBetweenStocksJustificationsModel(
  //         resultAsString: SoapRequestResponse.responseAsString,
  //         listToAdd: _justifications,
  //       );
  //     } else {
  //       ShowSnackbarMessage.showMessage(
  //         message: _errorMessageTypeStockAndJustifications,
  //         context: context,
  //       );
  //     }

  //     _errorMessageTypeStockAndJustifications =
  //         SoapRequestResponse.errorMessage;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}

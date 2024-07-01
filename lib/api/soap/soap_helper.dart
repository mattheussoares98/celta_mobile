import '../../models/soap/products/products.dart';
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

      return GetProductCmxJson.dataToGetProductCmxJson(
        data: SoapRequestResponse.responseAsMap,
        listToAdd: listToAdd,
      );
    } catch (e) {
      rethrow;
    }
  }
}

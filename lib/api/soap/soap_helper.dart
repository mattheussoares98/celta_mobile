import '../../utils/utils.dart';
import 'soap.dart';

Future<void> getGetProductCmxJson({
  required int enterpriseCode,
  required String searchValue,
  required bool isLegacyCodeSearch,
}) async {
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
}

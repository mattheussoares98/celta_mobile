import 'dart:convert';

class BuyRequestEnterpriseModel {
  final int Code;
  final int SaleRequestTypeCode;
  final String PersonalizedCode;
  final String Name;
  final String FantasizesName;
  final String CnpjNumber;
  final String InscriptionNumber;
  final bool selected;

  BuyRequestEnterpriseModel({
    required this.Code,
    required this.SaleRequestTypeCode,
    required this.PersonalizedCode,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjNumber,
    required this.InscriptionNumber,
    this.selected = false,
  });

  static responseAsStringToBuyRequestEnterpriseModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    if (responseAsString.contains("\\")) {
      //foi corrigido para não ficar mandando "\", "\n" e sinal de " a mais nos retornos. Somente quando estiver desatualido o CMX que vai enviar dessa forma
      responseAsString = responseAsString
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceFirst(RegExp(r'"'), '');

      int lastIndex = responseAsString.lastIndexOf('"');
      responseAsString =
          responseAsString.replaceRange(lastIndex, lastIndex + 1, "");
    }

    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        BuyRequestEnterpriseModel(
          Code: data["Code"],
          SaleRequestTypeCode: data["SaleRequestTypeCode"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          FantasizesName: data["FantasizesName"],
          CnpjNumber: data["CnpjNumber"],
          InscriptionNumber: data["InscriptionNumber"],
        ),
      );
    });
  }

  toJson() => {
        "Code": Code,
        "SaleRequestTypeCode": SaleRequestTypeCode,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "FantasizesName": FantasizesName,
        "CnpjNumber": CnpjNumber,
        "InscriptionNumber": InscriptionNumber,
        "selected": selected,
      };
}

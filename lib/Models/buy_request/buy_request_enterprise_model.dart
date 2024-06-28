import 'dart:convert';

class BuyRequestEnterpriseModel {
  final int Code;
  final int SaleRequestTypeCode;
  final String PersonalizedCode;
  final String Name;
  final String FantasizesName;
  final String CnpjNumber;
  final String InscriptionNumber;
  bool selected;

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

  static fromJson(Map json) => BuyRequestEnterpriseModel(
        Code: json["Code"],
        SaleRequestTypeCode: json["SaleRequestTypeCode"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        FantasizesName: json["FantasizesName"],
        CnpjNumber: json["CnpjNumber"],
        InscriptionNumber: json["InscriptionNumber"],
        selected: json["selected"],
      );
}

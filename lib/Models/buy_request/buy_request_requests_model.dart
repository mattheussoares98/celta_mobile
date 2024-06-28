import 'dart:convert';

class BuyRequestRequestsTypeModel {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final int OperationType;
  final String OperationTypeString;
  final int UseWholePrice;
  final String UseWholePriceString;
  final int UnitValueType;
  final String UnitValueTypeString;
  final int TransferUnitValueType;
  final String TransferUnitValueTypeString;

  BuyRequestRequestsTypeModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationType,
    required this.OperationTypeString,
    required this.UseWholePrice,
    required this.UseWholePriceString,
    required this.UnitValueType,
    required this.UnitValueTypeString,
    required this.TransferUnitValueType,
    required this.TransferUnitValueTypeString,
  });

  static responseAsStringToBuyRequestRequestsTypeModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        BuyRequestRequestsTypeModel(
          Code: data["Code"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          OperationType: data["OperationType"],
          OperationTypeString: data["OperationTypeString"],
          UseWholePrice: data["UseWholePrice"],
          UseWholePriceString: data["UseWholePriceString"],
          UnitValueType: data["UnitValueType"],
          UnitValueTypeString: data["UnitValueTypeString"],
          TransferUnitValueType: data["TransferUnitValueType"],
          TransferUnitValueTypeString: data["TransferUnitValueTypeString"],
        ),
      );
    });
  }

  toJson() => {
        "Code": Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "OperationType": OperationType,
        "OperationTypeString": OperationTypeString,
        "UseWholePrice": UseWholePrice,
        "UseWholePriceString": UseWholePriceString,
        "UnitValueType": UnitValueType,
        "UnitValueTypeString": UnitValueTypeString,
        "TransferUnitValueType": TransferUnitValueType,
        "TransferUnitValueTypeString": TransferUnitValueTypeString,
      };

  static fromJson(Map json) => BuyRequestRequestsTypeModel(
        Code: json["Code"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        OperationType: json["OperationType"],
        OperationTypeString: json["OperationTypeString"],
        UseWholePrice: json["UseWholePrice"],
        UseWholePriceString: json["UseWholePriceString"],
        UnitValueType: json["UnitValueType"],
        UnitValueTypeString: json["UnitValueTypeString"],
        TransferUnitValueType: json["TransferUnitValueType"],
        TransferUnitValueTypeString: json["TransferUnitValueTypeString"],
      );
}

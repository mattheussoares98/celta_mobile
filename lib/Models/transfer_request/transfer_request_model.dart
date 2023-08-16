import 'dart:convert';

class TransferRequestModel {
  final int Code;
  final int OperationType;
  final int UseWholePrice;
  final int UnitValueType;
  final String PersonalizedCode;
  final String Name;
  final String OperationTypeString;
  final String UseWholePriceString;
  final String UnitValueTypeString;

  TransferRequestModel({
    required this.Code,
    required this.OperationType,
    required this.UseWholePrice,
    required this.UnitValueType,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationTypeString,
    required this.UseWholePriceString,
    required this.UnitValueTypeString,
  });

  static resultAsStringToTransferRequestModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        TransferRequestModel(
          Code: data["Code"],
          OperationType: data["OperationType"],
          UseWholePrice: data["UseWholePrice"],
          UnitValueType: data["UnitValueType"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          OperationTypeString: data["OperationTypeString"],
          UseWholePriceString: data["UseWholePriceString"],
          UnitValueTypeString: data["UnitValueTypeString"],
        ),
      );
    });
  }
}

import 'dart:convert';

class SaleRequestRequestTypeModel {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final bool OperationType;
  final bool TransferUnitValueType;
  final bool UseWholePrice;

  SaleRequestRequestTypeModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationType,
    required this.TransferUnitValueType,
    required this.UseWholePrice,
  });

  static responseAsStringToSaleRequestRequestTypeModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    responseAsString = responseAsString
        .replaceAll(RegExp(r'\\'), '')
        .replaceAll(RegExp(r'\n'), '')
        .replaceAll(RegExp(r' '), '')
        .replaceFirst(RegExp(r'"'), '');

    int lastIndex = responseAsString.lastIndexOf('"');
    responseAsString =
        responseAsString.replaceRange(lastIndex, lastIndex + 1, "");
    //precisei fazer esse tratamento acima porque o estava retornando "\", "\n"
    //e sinal de " a mais, causando erro no decode

    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        SaleRequestRequestTypeModel(
          Code: data["Code"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          OperationType: data["OperationType"],
          TransferUnitValueType: data["TransferUnitValueType"],
          UseWholePrice: data["UseWholePrice"],
        ),
      );
    });
  }
}

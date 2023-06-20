import 'dart:convert';

class SaleRequestCostumerModel {
  int Code;
  String PersonalizedCode;
  String Name;
  String ReducedName;
  String CpfCnpjNumber;
  String RegistrationNumber;
  String SexType;
  bool selected;

  SaleRequestCostumerModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.ReducedName,
    required this.CpfCnpjNumber,
    required this.RegistrationNumber,
    required this.SexType,
    this.selected = false,
  });

  static responseAsStringToSaleRequestCostumerModel({
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
        SaleRequestCostumerModel.fromJson(data),
      );
    });
  }

  SaleRequestCostumerModel.fromJson(Map json)
      : Code = json["Code"],
        PersonalizedCode = json["PersonalizedCode"],
        Name = json["Name"],
        ReducedName = json["ReducedName"],
        CpfCnpjNumber = json["CpfCnpjNumber"],
        selected = json["selected"] ?? false,
        RegistrationNumber = json["RegistrationNumber"],
        SexType = json["SexType"];

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "ReducedName": ReducedName,
        "CpfCnpjNumber": CpfCnpjNumber,
        "selected": selected,
        "RegistrationNumber": RegistrationNumber,
        "SexType": SexType,
      };
}

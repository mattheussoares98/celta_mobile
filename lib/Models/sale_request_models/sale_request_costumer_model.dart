// var x = {
//   "Code": 5,
//   "PersonalizedCode": "5",
//   "Name": "1PessoaFisicaSP",
//   "ReducedName": "1PessoaFisicaSP",
//   "CpfCnpjNumber": "13198543894",
//   "RegistrationNumber": "197741435",
//   "SexType": "M"
// };

import 'dart:convert';

class SaleRequestCostumerModel {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final String ReducedName;
  final String CpfCnpjNumber;
  final String RegistrationNumber;
  final String SexType;

  SaleRequestCostumerModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.ReducedName,
    required this.CpfCnpjNumber,
    required this.RegistrationNumber,
    required this.SexType,
  });

  static responseAsStringToSaleRequestCostumerModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    responseAsString = responseAsString
        .replaceAll(RegExp(r'\\'), '')
        .replaceAll(RegExp(r'\n'), '')
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
        SaleRequestCostumerModel(
          Code: data["Code"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          ReducedName: data["ReducedName"],
          CpfCnpjNumber: data["CpfCnpjNumber"],
          RegistrationNumber: data["RegistrationNumber"],
          SexType: data["SexType"],
        ),
      );
    });
  }
}

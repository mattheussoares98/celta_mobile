import 'dart:convert';

class EnterpriseJsonModel {
  final int Code;
  final int SaleRequestTypeCode;
  final String PersonalizedCode;
  final String Name;
  final String FantasizesName;
  final String CnpjNumber;
  final String InscriptionNumber;

  EnterpriseJsonModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjNumber,
    required this.InscriptionNumber,
    required this.SaleRequestTypeCode,
  });

  static resultAsStringToEnterpriseJsonModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    print(resultAsString);
    resultAsString = resultAsString
        .replaceAll(RegExp(r'\\'), '')
        .replaceAll(RegExp(r'\n'), '')
        .replaceAll(RegExp(r' '), '')
        .replaceFirst(RegExp(r'"'), '');

    int lastIndex = resultAsString.lastIndexOf('"');
    resultAsString = resultAsString.replaceRange(lastIndex, lastIndex + 1, "");
    //precisei fazer esse tratamento acima porque o estava retornando "\", "\n"
    //e sinal de " a mais, causando erro no decode

    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        EnterpriseJsonModel(
          Code: data["Code"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          FantasizesName: data["FantasizesName"],
          CnpjNumber: data["CnpjNumber"],
          InscriptionNumber: data["InscriptionNumber"],
          SaleRequestTypeCode: data["SaleRequestTypeCode"],
        ),
      );
    });
  }
}

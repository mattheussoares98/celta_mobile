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

    if (resultAsString.contains("\\")) {
      //foi corrigido para não ficar mandando "\", "\n" e sinal de " a mais nos retornos. Somente quando estiver desatualido o CMX que vai enviar dessa forma
      resultAsString = resultAsString
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceFirst(RegExp(r'"'), '');

      int lastIndex = resultAsString.lastIndexOf('"');
      resultAsString =
          resultAsString.replaceRange(lastIndex, lastIndex + 1, "");
    }

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

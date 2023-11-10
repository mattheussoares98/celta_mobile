import 'dart:convert';

class BuyRequestBuyerModel {
  final int Code; /*  "Code":10 */
  final String PersonalizedCode; /*  "PersonalizedCode":"9999" */
  final String Name; /*  "Name":"Celtaware" */
  final String NameReduced; /*  "NameReduced":"" */
  final String CpfNumber; /*  "CpfNumber":"39367507852" */
  final String RgNumber; /*  "RgNumber":"" */
  final bool Seller; /*  "Seller":false */
  final bool Buyer; /*  "Buyer":false,}; */

  BuyRequestBuyerModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.NameReduced,
    required this.CpfNumber,
    required this.RgNumber,
    required this.Seller,
    required this.Buyer,
  });

  static responseAsStringToBuyRequestBuyerModel({
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
        BuyRequestBuyerModel(
          Code: data["Code"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          NameReduced: data["NameReduced"],
          CpfNumber: data["CpfNumber"],
          RgNumber: data["RgNumber"],
          Seller: data["Seller"],
          Buyer: data["Buyer"],
        ),
      );
    });
  }
}

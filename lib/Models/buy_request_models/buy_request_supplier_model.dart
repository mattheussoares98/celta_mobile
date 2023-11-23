import 'dart:convert';

class BuyRequestSupplierModel {
  final int Code;
  final String Name;
  final String FantasizesName;
  final String CnpjCpfNumber;
  final String InscriptionRgNumber;
  final String SupplierType;
  final String SupplierRegimeType;
  final String Date;
  final List? Emails;
  final List? Telephones;
  final List? Addresses;

  BuyRequestSupplierModel({
    required this.Code,
    required this.Name,
    required this.FantasizesName,
    required this.CnpjCpfNumber,
    required this.InscriptionRgNumber,
    required this.SupplierType,
    required this.SupplierRegimeType,
    required this.Date,
    this.Emails,
    this.Telephones,
    this.Addresses,
  });

  static responseAsStringToBuyRequestSupplierModel({
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
        BuyRequestSupplierModel(
          Code: data["Code"],
          Name: data["Name"],
          FantasizesName: data["FantasizesName"],
          CnpjCpfNumber: data["CnpjCpfNumber"],
          InscriptionRgNumber: data["InscriptionRgNumber"],
          SupplierType: data["SupplierType"],
          SupplierRegimeType: data["SupplierRegimeType"],
          Date: data["Date"],
          Addresses: data["Addresses"],
          Emails: data["Emails"],
          Telephones: data["Telephones"],
        ),
      );
    });
  }

  toJson() => {
        "Code": Code,
        "Name": Name,
        "FantasizesName": FantasizesName,
        "CnpjCpfNumber": CnpjCpfNumber,
        "InscriptionRgNumber": InscriptionRgNumber,
        "SupplierType": SupplierType,
        "SupplierRegimeType": SupplierRegimeType,
        "Date": Date,
        "Emails": Emails,
        "Telephones": Telephones,
        "Addresses": Addresses,
      };
}

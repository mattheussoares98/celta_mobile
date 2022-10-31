import 'dart:convert';

class ReceiptModel {
  final int CodigoInterno_ProcRecebDoc;
  final int CodigoInterno_Empresa;
  final String Numero_ProcRecebDoc;
  final String EmitterName;
  dynamic Status; //ele vem como inteiro mas preciso tratar como string

  ReceiptModel({
    required this.CodigoInterno_ProcRecebDoc,
    required this.CodigoInterno_Empresa,
    required this.Numero_ProcRecebDoc,
    required this.EmitterName,
    required this.Status,
  });

  static responseAsStringToReceiptModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        ReceiptModel(
          CodigoInterno_ProcRecebDoc: data["CodigoInterno_ProcRecebDoc"],
          CodigoInterno_Empresa: data["CodigoInterno_Empresa"],
          Numero_ProcRecebDoc: data["Numero_ProcRecebDoc"],
          EmitterName: data["EmitterName"],
          Status: data["Status"].toString(),
        ),
      );
    });
  }
}

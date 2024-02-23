

import 'package:flutter/material.dart';

class ReceiptModel {
  final int CodigoInterno_ProcRecebDoc;
  final int CodigoInterno_Empresa;
  final String Numero_ProcRecebDoc;
  final String EmitterName;
  final String Grupo;
  dynamic Status; //ele vem como inteiro mas preciso tratar como string
  Color StatusColor;

  ReceiptModel({
    required this.CodigoInterno_ProcRecebDoc,
    required this.CodigoInterno_Empresa,
    required this.Numero_ProcRecebDoc,
    required this.EmitterName,
    required this.Grupo,
    required this.Status,
    required this.StatusColor,
  });

  static dataToReceiptModel({
    required dynamic data,
    required List listToAdd,
  }) {
    if (data == null) {
      return;
    }
    List dataList = [];
    if (data is Map) {
      dataList.add(data);
    } else {
      dataList = data;
    }

    dataList.forEach((element) {
      listToAdd.add(
        ReceiptModel(
          CodigoInterno_ProcRecebDoc:
              int.parse(element["CodigoInterno_ProcRecebDoc"]),
          CodigoInterno_Empresa: int.parse(element["CodigoInterno_Empresa"]),
          Numero_ProcRecebDoc: element["Numero_ProcRecebDoc"],
          EmitterName: element["EmitterName"] ?? "",
          Grupo: element["Grupo"] ?? "-1",
          Status: element["Status"].toString(),
          StatusColor: Colors.black,
        ),
      );
    });
  }
}

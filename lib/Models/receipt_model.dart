import 'dart:convert';

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
          Grupo: data["Grupo"] ?? "-1",
          Status: data["Status"].toString(),
          StatusColor: Colors.black,
        ),
      );
    });
  }
}

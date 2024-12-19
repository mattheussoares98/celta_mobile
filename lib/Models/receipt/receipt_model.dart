import 'package:flutter/material.dart';

class ReceiptModel {
  final int CodigoInterno_ProcRecebDoc;
  final int CodigoInterno_Empresa;
  final String Numero_ProcRecebDoc;
  final String EmitterName;
  final String Grupo;
  final String? Observacoes_ProcRecebDoc;
  final String? DefaultObservations;
  dynamic Status; //ele vem como inteiro mas preciso tratar como string
  Color StatusColor;

  ReceiptModel({
    required this.CodigoInterno_ProcRecebDoc,
    required this.CodigoInterno_Empresa,
    required this.Numero_ProcRecebDoc,
    required this.EmitterName,
    required this.Grupo,
    required this.Observacoes_ProcRecebDoc,
    required this.DefaultObservations,
    required this.Status,
    required this.StatusColor,
  });

  factory ReceiptModel.fromJson(Map json) => ReceiptModel(
        CodigoInterno_ProcRecebDoc:
            int.parse(json["CodigoInterno_ProcRecebDoc"]),
        CodigoInterno_Empresa: int.parse(json["CodigoInterno_Empresa"]),
        Numero_ProcRecebDoc: json["Numero_ProcRecebDoc"],
        EmitterName: json["EmitterName"] ?? "",
        Grupo: json["Grupo"] ?? "-1",
        Status: json["Status"].toString(),
        StatusColor: Colors.black,
        Observacoes_ProcRecebDoc: json["Observacoes_ProcRecebDoc"],
        DefaultObservations: json["DefaultObservations"],
      );
}

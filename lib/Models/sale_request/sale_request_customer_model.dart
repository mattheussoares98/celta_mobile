import 'dart:convert';

import './sale_request_covenant_model.dart';


class SaleRequestCustomerModel {
  int Code;
  String PersonalizedCode;
  String Name;
  String ReducedName;
  String CpfCnpjNumber;
  String RegistrationNumber;
  String SexType;
  bool selected;
  List<SaleRequestCovenantsModel> Covenants;

  SaleRequestCustomerModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.ReducedName,
    required this.CpfCnpjNumber,
    required this.RegistrationNumber,
    required this.SexType,
    this.selected = false,
    required this.Covenants,
  });

  static responseAsStringToSaleRequestCustomerModel({
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
        SaleRequestCustomerModel.fromJson(data),
      );
    });
  }

  factory SaleRequestCustomerModel.fromJson(Map<String, dynamic> json) {
    List<SaleRequestCovenantsModel> CovenantsList = json['Covenants'] != null
        ? List<SaleRequestCovenantsModel>.from(
            json['Covenants'].map((x) => SaleRequestCovenantsModel.fromJson(x)))
        : [];

    return SaleRequestCustomerModel(
      Code: json['Code'],
      PersonalizedCode: json['PersonalizedCode'],
      Name: json['Name'],
      ReducedName: json['ReducedName'],
      CpfCnpjNumber: json['CpfCnpjNumber'],
      RegistrationNumber: json['RegistrationNumber'],
      SexType: json['SexType'],
      Covenants: CovenantsList,
      selected: json['selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': Code,
      'PersonalizedCode': PersonalizedCode,
      'Name': Name,
      'ReducedName': ReducedName,
      'CpfCnpjNumber': CpfCnpjNumber,
      'RegistrationNumber': RegistrationNumber,
      'SexType': SexType,
      'Covenants': Covenants.isNotEmpty
          ? List<dynamic>.from(Covenants.map((x) => x.toJson()))
          : null,
      "selected": selected,
    };
  }
}

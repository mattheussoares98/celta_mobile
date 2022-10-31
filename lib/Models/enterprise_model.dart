import 'dart:convert';

class EnterpriseModel {
  final int codigoInternoEmpresa;
  final String codigoEmpresa;
  final String nomeEmpresa;
  final String cnpj;
  bool isMarked;

  EnterpriseModel({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    required this.cnpj,
    this.isMarked = false,
  });

  static resultAsStringToEnterpriseModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        EnterpriseModel(
          codigoInternoEmpresa: data['CodigoInterno_Empresa'],
          codigoEmpresa: data['Codigo_Empresa'],
          nomeEmpresa: data['Nome_Empresa'],
          cnpj: data['Cnpj_Empresa'],
          isMarked: false,
        ),
      );
    });
  }
}

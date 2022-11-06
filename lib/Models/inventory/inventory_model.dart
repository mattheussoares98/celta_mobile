import 'dart:convert';

class InventoryModel {
  final int codigoInternoInventario;
  final DateTime dataCriacaoInventario;
  final DateTime dataCongelamentoInventario;
  final int codigoInternoEmpresa;
  final String nomeTipoEstoque;
  final String obsInventario;
  final String nomefuncionario;
  final String nomeempresa;
  final String codigoEmpresa;

  InventoryModel({
    required this.codigoInternoInventario,
    required this.dataCriacaoInventario,
    required this.dataCongelamentoInventario,
    required this.nomeTipoEstoque,
    required this.obsInventario,
    required this.nomefuncionario,
    required this.nomeempresa,
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
  });

  static void responseAsStringToInventoryModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        InventoryModel(
          codigoInternoInventario: data['CodigoInterno_Inventario'],
          dataCriacaoInventario: DateTime.parse(data['DataCriacao_Inventario']),
          dataCongelamentoInventario:
              DateTime.parse(data['DataCongelamento_Inventario']),
          nomeTipoEstoque: data['Nome_TipoEstoque'],
          obsInventario: data['Obs_Inventario'] ?? '',
          nomefuncionario: data['Nome_Funcionario'],
          nomeempresa: data['Nome_Empresa'],
          codigoInternoEmpresa: data['CodigoInterno_Empresa1'],
          codigoEmpresa: data['Codigo_Empresa'],
        ),
      );
    });
  }
}

//  "CodigoInterno_Inventario": 3,
//   "DataCriacao_Inventario": "2021-12-06T10:50:48",
//   "DataCongelamento_Inventario": "2021-12-06T10:54:00",
//    codigo interno empresa
//    "Nome_TipoEstoque": "Estoque Atual",
//      "Obs_Inventario": null,
//      "Nome_Funcionario": "Willians Junior",
//      "Nome_Empresa": "Deposito de Meias São José",

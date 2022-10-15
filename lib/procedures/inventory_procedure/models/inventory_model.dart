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
}

//  "CodigoInterno_Inventario": 3,
//   "DataCriacao_Inventario": "2021-12-06T10:50:48",
//   "DataCongelamento_Inventario": "2021-12-06T10:54:00",
//    codigo interno empresa
//    "Nome_TipoEstoque": "Estoque Atual",
//      "Obs_Inventario": null,
//      "Nome_Funcionario": "Willians Junior",
//      "Nome_Empresa": "Deposito de Meias São José",

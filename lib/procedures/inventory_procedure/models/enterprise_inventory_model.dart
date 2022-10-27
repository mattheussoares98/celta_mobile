class EnterpriseInventoryModel {
  final int codigoInternoEmpresa;
  final String codigoEmpresa;
  final String nomeEmpresa;
  final String cnpj;
  bool isMarked;

  EnterpriseInventoryModel({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    required this.cnpj,
    this.isMarked = false,
  });
}

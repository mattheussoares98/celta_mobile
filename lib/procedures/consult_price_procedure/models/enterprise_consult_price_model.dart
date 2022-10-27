class EnterpriseConsultPriceModel {
  final int codigoInternoEmpresa;
  final String cnpj;
  final String codigoEmpresa;
  final String nomeEmpresa;
  bool isMarked;

  EnterpriseConsultPriceModel({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    required this.cnpj,
    this.isMarked = false,
  });
}

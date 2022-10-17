class EnterpriseReceiptModel {
  final int codigoInternoEmpresa;
  final String codigoEmpresa;
  final String nomeEmpresa;
  bool isMarked;

  EnterpriseReceiptModel({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    this.isMarked = false,
  });
}

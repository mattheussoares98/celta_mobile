class EnterpriseModel {
  final int codigoInternoEmpresa;
  final String codigoEmpresa;
  final String nomeEmpresa;
  final String cnpj;
  final String CodigoInternoVendaMobile_ModeloPedido;
  final bool useRetailSale;
  final bool useWholeSale;
  final bool useEcommerceSale;
  final bool participateEnterpriseGroup;

  EnterpriseModel({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    required this.cnpj,
    required this.CodigoInternoVendaMobile_ModeloPedido,
    required this.useEcommerceSale,
    required this.useRetailSale,
    required this.useWholeSale,
    required this.participateEnterpriseGroup,
  });

  factory EnterpriseModel.fromJson(Map<String, dynamic> json) =>
      EnterpriseModel(
        codigoInternoEmpresa: int.parse(json['CodigoInterno_Empresa']),
        codigoEmpresa: json['Codigo_Empresa'],
        nomeEmpresa: json['Nome_Empresa'],
        cnpj: json['Cnpj_Empresa'],
        CodigoInternoVendaMobile_ModeloPedido:
            json["CodigoInternoVendaMobile_ModeloPedido"] ?? "-1",
        useEcommerceSale: json["FlagECommerce_Empresa"] == "1",
        useRetailSale: json["FlagVarejo_Empresa"] == "1",
        useWholeSale: json["FlagAtacado_Empresa"] == "1",
        participateEnterpriseGroup:
            json["EnterpriseParticipateEnterpriseGroup"] == "1",
      );
}

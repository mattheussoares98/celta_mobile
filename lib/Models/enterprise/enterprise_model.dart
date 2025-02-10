class EnterpriseModel {
  final int Code;
  final int PersonalizedCode;
  final String Name;
  final int CnpjNumber;
  final int CodigoInternoVendaMobile_ModeloPedido;
  final bool useRetailSale;
  final bool useWholeSale;
  final bool useEcommerceSale;
  final bool? EnterpriseParticipateEnterpriseGroup;
  final int? ProductCodeSizeOfBalanceLabel;
  final bool? ProductCodeWithCheckerDigit;
  final String? InscriptionNumber;

  EnterpriseModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.CodigoInternoVendaMobile_ModeloPedido,
    required this.useEcommerceSale,
    required this.useRetailSale,
    required this.useWholeSale,
    required this.EnterpriseParticipateEnterpriseGroup,
    required this.ProductCodeSizeOfBalanceLabel,
    required this.ProductCodeWithCheckerDigit,
    required this.InscriptionNumber,
  });

  factory EnterpriseModel.fromJson(Map<String, dynamic> json) =>
      EnterpriseModel(
        Code: json["Code"],
        PersonalizedCode: int.parse(json['PersonalizedCode']),
        Name: json['Name'],
        CnpjNumber: int.parse(json['CnpjNumber']),
        useEcommerceSale: json['SaleTypeECommerce'],
        useRetailSale: json['SaleTypeRetail'],
        useWholeSale: json['SaleTypeWholeSale'],
        CodigoInternoVendaMobile_ModeloPedido: json["SaleRequestTypeCode"],
        EnterpriseParticipateEnterpriseGroup:
            json["EnterpriseParticipateEnterpriseGroup"],
        ProductCodeSizeOfBalanceLabel: json["ProductCodeSizeOfBalanceLabel"],
        ProductCodeWithCheckerDigit: json["ProductCodeWithCheckerDigit"],
        InscriptionNumber: json["InscriptionNumber"],
      );
}

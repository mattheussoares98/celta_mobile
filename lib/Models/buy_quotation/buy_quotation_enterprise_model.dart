class BuyQuotationEnterpriseModel {
  final int? Code;
  final BuyQuotationEnterprise enterprise;

  const BuyQuotationEnterpriseModel({
    required this.Code,
    required this.enterprise,
  });

  factory BuyQuotationEnterpriseModel.fromJson(Map data) =>
      BuyQuotationEnterpriseModel(
        Code: data["Code"],
        enterprise: BuyQuotationEnterprise.fromJson(data["Enterprise"]),
      );

  Map<String, dynamic> toJson({required bool isInserting}) => {
        "Code": isInserting ? 0 : Code,
        "Enterprise": enterprise.toJson(),
      };
}

class BuyQuotationEnterprise {
  final String? PersonalizedCode;
  final String? Name;
  final String? CnpjNumber;
  final String? InscriptionNumber;
  final int? Code;

  const BuyQuotationEnterprise({
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.InscriptionNumber,
    required this.Code,
  });

  factory BuyQuotationEnterprise.fromJson(Map data) => BuyQuotationEnterprise(
        PersonalizedCode: data["PersonalizedCode"],
        Name: data["Name"],
        CnpjNumber: data["CnpjNumber"],
        InscriptionNumber: data["InscriptionNumber"],
        Code: data["Code"],
      );

  Map<String, dynamic> toJson() => {
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "CnpjNumber": CnpjNumber,
        "InscriptionNumber": InscriptionNumber,
        "Code": Code,
      };
}

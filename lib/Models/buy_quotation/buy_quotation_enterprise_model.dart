class BuyQuotationEnterpriseModel {
  final int? Code;
  final _EnterpriseModel enterprise;

  const BuyQuotationEnterpriseModel({
    required this.Code,
    required this.enterprise,
  });

  factory BuyQuotationEnterpriseModel.fromJson(Map data) =>
      BuyQuotationEnterpriseModel(
        Code: data["Code"],
        enterprise: _EnterpriseModel.fromJson(data["Enterprise"]),
      );

  Map<String, dynamic> toJson({required bool isInserting}) => {
        "Code": isInserting ? 0 : Code,
        "Enterprise": enterprise.toJson(),
      };
}

class _EnterpriseModel {
  final String? PersonalizedCode;
  final String? Name;
  final String? CnpjNumber;
  final String? InscriptionNumber;
  final int? Code;

  const _EnterpriseModel({
    required this.PersonalizedCode,
    required this.Name,
    required this.CnpjNumber,
    required this.InscriptionNumber,
    required this.Code,
  });

  factory _EnterpriseModel.fromJson(Map data) => _EnterpriseModel(
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

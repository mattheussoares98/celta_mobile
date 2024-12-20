class BuyQuotationIncompleteModel {
  final int? Code;
  final String? DateOfCreation;
  final String? DateOfLimit;
  final String? PersonalizedCode;
  final String? Observations;

  const BuyQuotationIncompleteModel({
    required this.Code,
    required this.DateOfCreation,
    required this.DateOfLimit,
    required this.PersonalizedCode,
    required this.Observations,
  });

  factory BuyQuotationIncompleteModel.fromJson(Map data) =>
      BuyQuotationIncompleteModel(
        Code: data["Code"],
        DateOfCreation: data["DateOfCreation"],
        DateOfLimit: data["DateOfLimit"],
        PersonalizedCode: data["PersonalizedCode"],
        Observations: data["Observations"],
      );

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "DateOfCreation": DateOfCreation,
        "DateOfLimit": DateOfLimit,
        "PersonalizedCode": PersonalizedCode,
        "Observations": Observations,
      };
}

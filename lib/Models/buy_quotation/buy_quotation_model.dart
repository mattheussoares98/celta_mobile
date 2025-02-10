import '../models.dart';

class BuyQuotationModel {
  final String? CrossIdentity;
  final int? Code;
  final String? DateOfCreation;
  final String? DateOfLimit;
  final String? PersonalizedCode;
  final String? Observations;
  final BuyerModel? Buyer;
  final List<BuyQuotationEnterpriseModel>? Enterprises;
  final List<BuyQuotationProductsModel>? Products;

  const BuyQuotationModel({
    required this.CrossIdentity,
    required this.Code,
    required this.DateOfCreation,
    required this.DateOfLimit,
    required this.PersonalizedCode,
    required this.Observations,
    required this.Buyer,
    required this.Enterprises,
    required this.Products,
  });

  factory BuyQuotationModel.fromJson(Map data) => BuyQuotationModel(
        CrossIdentity: data["CrossIdentity"],
        Code: data["Code"],
        DateOfCreation: data["DateOfCreation"],
        DateOfLimit: data["DateOfLimit"],
        PersonalizedCode: data["PersonalizedCode"],
        Observations: data["Observations"],
        Buyer:
            data["Buyer"] == null ? null : BuyerModel.fromJson(data["Buyer"]),
        Enterprises: data["Enterprises"] == null
            ? null
            : (data["Enterprises"] as List)
                .map((e) => BuyQuotationEnterpriseModel.fromJson(e))
                .toList(),
        Products: data["Products"] == null
            ? null
            : (data["Products"] as List)
                .map((e) => BuyQuotationProductsModel.fromJson(e))
                .toList(),
      );

  Map<String, dynamic> toJson({required bool isInserting}) => {
        "CrossIdentity": CrossIdentity,
        "Code": isInserting ? 0 : Code,
        "DateOfCreation": DateOfCreation,
        "DateOfLimit": DateOfLimit,
        "PersonalizedCode": PersonalizedCode,
        "Observations": Observations,
        "Buyer": Buyer?.toJson(isInserting: isInserting),
        "Enterprises":
            Enterprises?.map((e) => e.toJson(isInserting: isInserting))
                .toList(),
        "Products":
            Products?.map((e) => e.toJson(isInserting: isInserting)).toList(),
      };
}

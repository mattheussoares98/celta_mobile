class BuyQuotationBuyerModel {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;
  final String? NameReduced;
  final String? CpfNumber;
  final String? RgNumber;
  final bool Seller;
  final bool Buyer;

  const BuyQuotationBuyerModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.NameReduced,
    required this.CpfNumber,
    required this.RgNumber,
    required this.Seller,
    required this.Buyer,
  });

  factory BuyQuotationBuyerModel.fromJson(Map data) => BuyQuotationBuyerModel(
        Code: data["Code"],
        PersonalizedCode: data["PersonalizedCode"],
        Name: data["Name"],
        NameReduced: data["NameReduced"],
        CpfNumber: data["CpfNumber"],
        RgNumber: data["RgNumber"],
        Seller: data["Seller"],
        Buyer: data["Buyer"],
      );

  Map<String, dynamic> toJson({required bool isInserting}) => {
        "Code": isInserting ? 0 : Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "NameReduced": NameReduced,
        "CpfNumber": CpfNumber,
        "RgNumber": RgNumber,
        "Seller": Seller,
        "Buyer": Buyer,
      };
}

class BuyerModel {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final String NameReduced;
  final String CpfNumber;
  final String RgNumber;
  final bool Seller;
  final bool Buyer;

  BuyerModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.NameReduced,
    required this.CpfNumber,
    required this.RgNumber,
    required this.Seller,
    required this.Buyer,
  });

  factory BuyerModel.fromJson(Map json) => BuyerModel(
        Code: json["Code"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
        NameReduced: json["NameReduced"],
        CpfNumber: json["CpfNumber"],
        RgNumber: json["RgNumber"],
        Seller: json["Seller"],
        Buyer: json["Buyer"],
      );

  Map<String, dynamic> toJson({bool? isInserting = false}) => {
        "Code": isInserting == true ? 0 : Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
        "NameReduced": NameReduced,
        "CpfNumber": CpfNumber,
        "RgNumber": RgNumber,
        "Seller": Seller,
        "Buyer": Buyer,
      };
}

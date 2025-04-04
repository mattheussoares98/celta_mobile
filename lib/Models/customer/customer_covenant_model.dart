class CustomerCovenantModel {
  final CovenantModel? covenant;
  final String? Matriculate;
  final double? LimitOfPurchase;
  bool isSelected;

  CustomerCovenantModel({
    required this.covenant,
    required this.Matriculate,
    required this.LimitOfPurchase,
    required this.isSelected,
  });

  factory CustomerCovenantModel.fromJson(Map json) => CustomerCovenantModel(
        covenant: json["Covenant"] == null
            ? null
            : CovenantModel.fromJson(json["Covenant"]),
        Matriculate: json["Matriculate"],
        LimitOfPurchase: json["LimitOfPurchase"],
        isSelected: json["isSelected"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "Covenant": covenant?.toJson(),
        "Matriculate": Matriculate,
        "LimitOfPurchase": LimitOfPurchase,
        "isSelected": isSelected,
      };
}

class CovenantModel {
  final int? Code;
  final String? PersonalizedCode;
  final String? Name;

  CovenantModel({
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
  });

  factory CovenantModel.fromJson(Map json) => CovenantModel(
        Code: json["Code"],
        PersonalizedCode: json["PersonalizedCode"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "PersonalizedCode": PersonalizedCode,
        "Name": Name,
      };
}

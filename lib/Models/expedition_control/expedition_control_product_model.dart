class ExpeditionControlProductModel {
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final double Quantity;
  final String PriceLookUp;
  final String Name;
  final String Packing;

  ExpeditionControlProductModel({
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.Quantity,
    required this.PriceLookUp,
    required this.Name,
    required this.Packing,
  });

  factory ExpeditionControlProductModel.fromJson(Map<String, dynamic> json) =>
      ExpeditionControlProductModel(
        EnterpriseCode: json["EnterpriseCode"],
        ProductCode: json["ProductCode"],
        ProductPackingCode: json["ProductPackingCode"],
        Quantity: json["Quantity"],
        PriceLookUp: json["PriceLookUp"],
        Name: json["Name"],
        Packing: json["Packing"],
      );

  Map<String, dynamic> toJson() => {
        "EnterpriseCode": EnterpriseCode,
        "ProductCode": ProductCode,
        "ProductPackingCode": ProductPackingCode,
        "Quantity": Quantity,
        "PriceLookUp": PriceLookUp,
        "Name": Name,
        "Packing": Packing,
      };
}

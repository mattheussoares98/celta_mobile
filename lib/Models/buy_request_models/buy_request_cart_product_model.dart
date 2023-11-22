class BuyRequestCartProductModel {
  final int EnterpriseCode;
  final int ProductPackingCode;
  final double Value;
  final double Quantity;
  final String IncrementPercentageOrValue;
  final double IncrementValue;
  final String DiscountPercentageOrValue;
  final double DiscountValue;

  BuyRequestCartProductModel({
    required this.EnterpriseCode,
    required this.ProductPackingCode,
    required this.Value,
    required this.Quantity,
    required this.IncrementPercentageOrValue,
    required this.IncrementValue,
    required this.DiscountPercentageOrValue,
    required this.DiscountValue,
  });

  toJson() => {
        "EnterpriseCode": EnterpriseCode,
        "ProductPackingCode": ProductPackingCode,
        "Value": Value,
        "Quantity": Quantity,
        "IncrementPercentageOrValue": IncrementPercentageOrValue,
        "IncrementValue": IncrementValue,
        "DiscountPercentageOrValue": DiscountPercentageOrValue,
        "DiscountValue": DiscountValue,
      };
}

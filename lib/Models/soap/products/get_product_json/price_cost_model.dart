class PriceCostModel {
  final double? RetailPracticedPrice;
  final double? RetailSalePrice;
  final double? RetailOfferPrice;
  final double? RetailSuggestionPrice;
  final double? RetailMinimumPrice;
  final double? WholePracticedPrice;
  final double? WholeSalePrice;
  final double? WholeOfferPrice;
  final double? WholeSuggestionPrice;
  final double? WholeMinimumPrice;
  final double? ECommercePracticedPrice;
  final double? ECommerceSalePrice;
  final double? ECommerceOfferPrice;
  final double? ECommerceSuggestionPrice;
  final double? ECommerceMinimumPrice;
  final double? MinimumWholeQuantity;
  final double? OperationalCost;
  final double? ReplacementCost;
  final double? ReplacementCostMidle;
  final double? LiquidCost;
  final double? LiquidCostMidle;
  final double? RealCost;
  final double? RealLiquidCost;
  final double? FiscalCost;
  final double? FiscalLiquidCost;
  final double? RetailMargin;
  final double? RetailOfferMargin;
  final double? RetailMinimumMargin;
  final double? WholeMargin;
  final double? WholeOfferMargin;
  final double? WholeMinimumMargin;
  final double? ECommerceMargin;
  final double? ECommerceOfferMargin;
  final double? ECommerceMinimumMargin;

  PriceCostModel({
    required this.RetailPracticedPrice,
    required this.RetailSalePrice,
    required this.RetailOfferPrice,
    required this.RetailSuggestionPrice,
    required this.RetailMinimumPrice,
    required this.WholePracticedPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.WholeSuggestionPrice,
    required this.WholeMinimumPrice,
    required this.ECommercePracticedPrice,
    required this.ECommerceSalePrice,
    required this.ECommerceOfferPrice,
    required this.ECommerceSuggestionPrice,
    required this.ECommerceMinimumPrice,
    required this.MinimumWholeQuantity,
    required this.OperationalCost,
    required this.ReplacementCost,
    required this.ReplacementCostMidle,
    required this.LiquidCost,
    required this.LiquidCostMidle,
    required this.RealCost,
    required this.RealLiquidCost,
    required this.FiscalCost,
    required this.FiscalLiquidCost,
    required this.RetailMargin,
    required this.RetailOfferMargin,
    required this.RetailMinimumMargin,
    required this.WholeMargin,
    required this.WholeOfferMargin,
    required this.WholeMinimumMargin,
    required this.ECommerceMargin,
    required this.ECommerceOfferMargin,
    required this.ECommerceMinimumMargin,
  });

  factory PriceCostModel.fromJson(Map<String, dynamic> json) => PriceCostModel(
        RetailPracticedPrice: json["RetailPracticedPrice"],
        RetailSalePrice: json["RetailSalePrice"],
        RetailOfferPrice: json["RetailOfferPrice"],
        RetailSuggestionPrice: json["RetailSuggestionPrice"],
        RetailMinimumPrice: json["RetailMinimumPrice"],
        WholePracticedPrice: json["WholePracticedPrice"],
        WholeSalePrice: json["WholeSalePrice"],
        WholeOfferPrice: json["WholeOfferPrice"],
        WholeSuggestionPrice: json["WholeSuggestionPrice"],
        WholeMinimumPrice: json["WholeMinimumPrice"],
        ECommercePracticedPrice: json["ECommercePracticedPrice"],
        ECommerceSalePrice: json["ECommerceSalePrice"],
        ECommerceOfferPrice: json["ECommerceOfferPrice"],
        ECommerceSuggestionPrice: json["ECommerceSuggestionPrice"],
        ECommerceMinimumPrice: json["ECommerceMinimumPrice"],
        MinimumWholeQuantity: json["MinimumWholeQuantity"],
        OperationalCost: json["OperationalCost"],
        ReplacementCost: json["ReplacementCost"],
        ReplacementCostMidle: json["ReplacementCostMidle"],
        LiquidCost: json["LiquidCost"],
        LiquidCostMidle: json["LiquidCostMidle"],
        RealCost: json["RealCost"],
        RealLiquidCost: json["RealLiquidCost"],
        FiscalCost: json["FiscalCost"],
        FiscalLiquidCost: json["FiscalLiquidCost"],
        RetailMargin: json["RetailMargin"],
        RetailOfferMargin: json["RetailOfferMargin"],
        RetailMinimumMargin: json["RetailMinimumMargin"],
        WholeMargin: json["WholeMargin"],
        WholeOfferMargin: json["WholeOfferMargin"],
        WholeMinimumMargin: json["WholeMinimumMargin"],
        ECommerceMargin: json["ECommerceMargin"],
        ECommerceOfferMargin: json["ECommerceOfferMargin"],
        ECommerceMinimumMargin: json["ECommerceMinimumMargin"],
      );

  Map<String, dynamic> toJson() => {
        "RetailPracticedPrice": RetailPracticedPrice,
        "RetailSalePrice": RetailSalePrice,
        "RetailOfferPrice": RetailOfferPrice,
        "RetailSuggestionPrice": RetailSuggestionPrice,
        "RetailMinimumPrice": RetailMinimumPrice,
        "WholePracticedPrice": WholePracticedPrice,
        "WholeSalePrice": WholeSalePrice,
        "WholeOfferPrice": WholeOfferPrice,
        "WholeSuggestionPrice": WholeSuggestionPrice,
        "WholeMinimumPrice": WholeMinimumPrice,
        "ECommercePracticedPrice": ECommercePracticedPrice,
        "ECommerceSalePrice": ECommerceSalePrice,
        "ECommerceOfferPrice": ECommerceOfferPrice,
        "ECommerceSuggestionPrice": ECommerceSuggestionPrice,
        "ECommerceMinimumPrice": ECommerceMinimumPrice,
        "MinimumWholeQuantity": MinimumWholeQuantity,
        "OperationalCost": OperationalCost,
        "ReplacementCost": ReplacementCost,
        "ReplacementCostMidle": ReplacementCostMidle,
        "LiquidCost": LiquidCost,
        "LiquidCostMidle": LiquidCostMidle,
        "RealCost": RealCost,
        "RealLiquidCost": RealLiquidCost,
        "FiscalCost": FiscalCost,
        "FiscalLiquidCost": FiscalLiquidCost,
        "RetailMargin": RetailMargin,
        "RetailOfferMargin": RetailOfferMargin,
        "RetailMinimumMargin": RetailMinimumMargin,
        "WholeMargin": WholeMargin,
        "WholeOfferMargin": WholeOfferMargin,
        "WholeMinimumMargin": WholeMinimumMargin,
        "ECommerceMargin": ECommerceMargin,
        "ECommerceOfferMargin": ECommerceOfferMargin,
        "ECommerceMinimumMargin": ECommerceMinimumMargin,
      };
}

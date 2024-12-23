import 'dart:convert';

class BuyQuotationProductsModel {
  final int? Code;
  final _Product? Product;
  final List<_ProductEnterprise>? ProductEnterprises;

  BuyQuotationProductsModel({
    required this.Code,
    required this.Product,
    required this.ProductEnterprises,
  });

  factory BuyQuotationProductsModel.fromJson(Map data) =>
      BuyQuotationProductsModel(
        Code: data["Code"],
        Product: _Product.fromJson(data["Product"]),
        ProductEnterprises: data["ProductEnterprises"] == null
            ? null
            : (json.decode(data["ProductEnterprises"]) as List)
                .map((e) => _ProductEnterprise.fromJson(e))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "Product": Product?.toJson(),
        "ProductEnterprises":
            ProductEnterprises?.map((e) => e.toJson()).toList(),
      };
}

class _Product {
  final int? EnterpriseCode;
  final int? ProductCode;
  final int? ProductPackingCode;
  final String? PLU;
  final String? Name;
  final String? PackingQuantity;
  final bool? PendantPrintLabel;
  final bool? AlterationPriceForAllPackings;
  final bool? IsFatherOfGrate;
  final bool? IsChildOfGrate;
  final bool? InClass;
  final bool? MarkUpdateClassInAdjustSalePriceIndividual;
  final double? Value;
  final double? BalanceLabelQuantity;
  final double? RetailPracticedPrice;
  final double? RetailSalePrice;
  final double? RetailOfferPrice;
  final double? WholePracticedPrice;
  final double? WholeSalePrice;
  final double? WholeOfferPrice;
  final double? ECommercePracticedPrice;
  final double? ECommerceSalePrice;
  final double? ECommerceOfferPrice;
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
  final double? PriceCost;
  //  "StockByEnterpriseAssociateds":null,
  //  "Stocks":null,
  //  "LastBuyEntrance":null,
  //  "StorageAreaAddress":null,
  //  "BalanceLabelType":null,

  const _Product({
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.PLU,
    required this.Name,
    required this.PackingQuantity,
    required this.PendantPrintLabel,
    required this.AlterationPriceForAllPackings,
    required this.IsFatherOfGrate,
    required this.IsChildOfGrate,
    required this.InClass,
    required this.MarkUpdateClassInAdjustSalePriceIndividual,
    required this.Value,
    required this.BalanceLabelQuantity,
    required this.RetailPracticedPrice,
    required this.RetailSalePrice,
    required this.RetailOfferPrice,
    required this.WholePracticedPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.ECommercePracticedPrice,
    required this.ECommerceSalePrice,
    required this.ECommerceOfferPrice,
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
    required this.PriceCost,
  });

  factory _Product.fromJson(Map data) => _Product(
        EnterpriseCode: data["EnterpriseCode"],
        ProductCode: data["ProductCode"],
        ProductPackingCode: data["ProductPackingCode"],
        PLU: data["PLU"],
        Name: data["Name"],
        PackingQuantity: data["PackingQuantity"],
        PendantPrintLabel: data["PendantPrintLabel"],
        AlterationPriceForAllPackings: data["AlterationPriceForAllPackings"],
        IsFatherOfGrate: data["IsFatherOfGrate"],
        IsChildOfGrate: data["IsChildOfGrate"],
        InClass: data["InClass"],
        MarkUpdateClassInAdjustSalePriceIndividual:
            data["MarkUpdateClassInAdjustSalePriceIndividual"],
        Value: data["Value"],
        BalanceLabelQuantity: data["BalanceLabelQuantity"],
        RetailPracticedPrice: data["RetailPracticedPrice"],
        RetailSalePrice: data["RetailSalePrice"],
        RetailOfferPrice: data["RetailOfferPrice"],
        WholePracticedPrice: data["WholePracticedPrice"],
        WholeSalePrice: data["WholeSalePrice"],
        WholeOfferPrice: data["WholeOfferPrice"],
        ECommercePracticedPrice: data["ECommercePracticedPrice"],
        ECommerceSalePrice: data["ECommerceSalePrice"],
        ECommerceOfferPrice: data["ECommerceOfferPrice"],
        MinimumWholeQuantity: data["MinimumWholeQuantity"],
        OperationalCost: data["OperationalCost"],
        ReplacementCost: data["ReplacementCost"],
        ReplacementCostMidle: data["ReplacementCostMidle"],
        LiquidCost: data["LiquidCost"],
        LiquidCostMidle: data["LiquidCostMidle"],
        RealCost: data["RealCost"],
        RealLiquidCost: data["RealLiquidCost"],
        FiscalCost: data["FiscalCost"],
        FiscalLiquidCost: data["FiscalLiquidCost"],
        PriceCost: data["PriceCost"],
      );

  Map<String, dynamic> toJson() => {
        "EnterpriseCode": EnterpriseCode,
        "ProductCode": ProductCode,
        "ProductPackingCode": ProductPackingCode,
        "PLU": PLU,
        "Name": Name,
        "PackingQuantity": PackingQuantity,
        "PendantPrintLabel": PendantPrintLabel,
        "AlterationPriceForAllPackings": AlterationPriceForAllPackings,
        "IsFatherOfGrate": IsFatherOfGrate,
        "IsChildOfGrate": IsChildOfGrate,
        "InClass": InClass,
        "MarkUpdateClassInAdjustSalePriceIndividual":
            MarkUpdateClassInAdjustSalePriceIndividual,
        "Value": Value,
        "BalanceLabelQuantity": BalanceLabelQuantity,
        "RetailPracticedPrice": RetailPracticedPrice,
        "RetailSalePrice": RetailSalePrice,
        "RetailOfferPrice": RetailOfferPrice,
        "WholePracticedPrice": WholePracticedPrice,
        "WholeSalePrice": WholeSalePrice,
        "WholeOfferPrice": WholeOfferPrice,
        "ECommercePracticedPrice": ECommercePracticedPrice,
        "ECommerceSalePrice": ECommerceSalePrice,
        "ECommerceOfferPrice": ECommerceOfferPrice,
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
        "PriceCost": PriceCost,
      };
}

class _ProductEnterprise {
  final int? Code;
  final int? EnterpriseCode;
  final double? Quantity;

  const _ProductEnterprise({
    required this.Code,
    required this.EnterpriseCode,
    required this.Quantity,
  });

  factory _ProductEnterprise.fromJson(Map data) => _ProductEnterprise(
        Code: data["Code"],
        EnterpriseCode: data["EnterpriseCode"],
        Quantity: data["Quantity"],
      );

  Map<String, dynamic> toJson() => {
        "Code": Code,
        "EnterpriseCode": EnterpriseCode,
        "Quantity": Quantity,
      };
}

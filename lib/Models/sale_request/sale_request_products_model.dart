import 'dart:convert';

class SaleRequestProductsModel {
  final String PLU;
  final String Name;
  final String PackingQuantity;
  final String BalanceLabelType;
  final int EnterpriseCode;
  final int ProductCode;
  final int ProductPackingCode;
  final double RetailPracticedPrice;
  final double RetailSalePrice;
  final double RetailOfferPrice;
  final double WholePracticedPrice;
  final double WholeSalePrice;
  final double WholeOfferPrice;
  final double ECommercePracticedPrice;
  final double ECommerceSalePrice;
  final double ECommerceOfferPrice;
  final double MinimumWholeQuantity;
  final double BalanceStockSale;
  final double BalanceLabelQuantity;
  final double OperationalCost;
  final double ReplacementCost;
  final double ReplacementCostMidle;
  final double LiquidCost;
  final double LiquidCostMidle;
  final double RealCost;
  final double RealLiquidCost;
  final double FiscalCost;
  final double FiscalLiquidCost;
  final List<dynamic>? StockByEnterpriseAssociateds;
  final String? StorageAreaAddress;
  final List<dynamic>? Stocks;
  final double Value;
  double ValueTyped;
  double quantity;

  SaleRequestProductsModel({
    required this.PLU,
    required this.Name,
    required this.PackingQuantity,
    required this.EnterpriseCode,
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.Value,
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
    required this.BalanceStockSale,
    required this.BalanceLabelType,
    required this.BalanceLabelQuantity,
    required this.OperationalCost,
    required this.ReplacementCost,
    required this.ReplacementCostMidle,
    required this.LiquidCost,
    required this.LiquidCostMidle,
    required this.RealCost,
    required this.RealLiquidCost,
    required this.FiscalCost,
    required this.FiscalLiquidCost,
    required this.Stocks,
    this.StockByEnterpriseAssociateds,
    this.StorageAreaAddress,
    this.quantity = 0,
    this.ValueTyped = 0,
  });

  static responseAsStringToSaleRequestProductsModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        SaleRequestProductsModel.fromJson(data),
      );
    });
  }

  static fromJson(Map json) => SaleRequestProductsModel(
        PLU: json["PLU"],
        Name: json["Name"],
        PackingQuantity: json["PackingQuantity"],
        EnterpriseCode: json["EnterpriseCode"],
        ProductCode: json["ProductCode"],
        ProductPackingCode: json["ProductPackingCode"],
        Value:
            json["Value"] == 0 ? json["RetailPracticedPrice"] : json["Value"],
        ValueTyped: json["ValueTyped"] ?? 0,
        RetailPracticedPrice: json["RetailPracticedPrice"],
        RetailSalePrice: json["RetailSalePrice"],
        RetailOfferPrice: json["RetailOfferPrice"],
        WholePracticedPrice: json["WholePracticedPrice"],
        WholeSalePrice: json["WholeSalePrice"],
        WholeOfferPrice: json["WholeOfferPrice"],
        ECommercePracticedPrice: json["ECommercePracticedPrice"],
        ECommerceSalePrice: json["ECommerceSalePrice"],
        ECommerceOfferPrice: json["ECommerceOfferPrice"],
        MinimumWholeQuantity: json["MinimumWholeQuantity"],
        BalanceStockSale: json["BalanceStockSale"],
        BalanceLabelType: json["BalanceLabelType"],
        BalanceLabelQuantity: json["BalanceLabelQuantity"],
        OperationalCost: json["OperationalCost"],
        ReplacementCost: json["ReplacementCost"],
        ReplacementCostMidle: json["ReplacementCostMidle"],
        LiquidCost: json["LiquidCost"],
        LiquidCostMidle: json["LiquidCostMidle"],
        RealCost: json["RealCost"],
        RealLiquidCost: json["RealLiquidCost"],
        FiscalCost: json["FiscalCost"],
        FiscalLiquidCost: json["FiscalLiquidCost"],
        Stocks: json["Stocks"],
        StockByEnterpriseAssociateds: json["StockByEnterpriseAssociateds"],
        StorageAreaAddress: json["StorageAreaAddress"],
        quantity: json["quantity"] ?? 0,
      );

  Map toJson() => {
        "PLU": PLU,
        "Name": Name,
        "PackingQuantity": PackingQuantity,
        "EnterpriseCode": EnterpriseCode,
        "ProductCode": ProductCode,
        "ProductPackingCode": ProductPackingCode,
        "Value": Value,
        "ValueTyped": ValueTyped,
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
        "BalanceStockSale": BalanceStockSale,
        "BalanceLabelType": BalanceLabelType,
        "BalanceLabelQuantity": BalanceLabelQuantity,
        "OperationalCost": OperationalCost,
        "ReplacementCost": ReplacementCost,
        "ReplacementCostMidle": ReplacementCostMidle,
        "LiquidCost": LiquidCost,
        "LiquidCostMidle": LiquidCostMidle,
        "RealCost": RealCost,
        "RealLiquidCost": RealLiquidCost,
        "FiscalCost": FiscalCost,
        "FiscalLiquidCost": FiscalLiquidCost,
        "Stocks": Stocks,
        "StockByEnterpriseAssociateds": StockByEnterpriseAssociateds,
        "StorageAreaAddress": StorageAreaAddress,
        "quantity": quantity,
      };
}

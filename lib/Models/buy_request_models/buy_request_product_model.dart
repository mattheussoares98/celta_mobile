import 'dart:convert';

class BuyRequestProductsModel {
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
  final List<Map<dynamic, dynamic>>? StockByEnterpriseAssociateds;
  final List<Map<dynamic, dynamic>>? StorageAreaAddress;
  final List<dynamic>? Stocks;
  final double Value;
  double ValueTyped;
  double quantity;

  BuyRequestProductsModel({
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

  static responseAsStringToBuyRequestProductsModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    if (responseAsString.contains("\\")) {
      //foi corrigido para não ficar mandando "\", "\n" e sinal de " a mais nos retornos. Somente quando estiver desatualido o CMX que vai enviar dessa forma
      responseAsString = responseAsString
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceFirst(RegExp(r'"'), '');

      int lastIndex = responseAsString.lastIndexOf('"');
      responseAsString =
          responseAsString.replaceRange(lastIndex, lastIndex + 1, "");
    }

    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        BuyRequestProductsModel(
          PLU: data["PLU"],
          Name: data["Name"],
          PackingQuantity: data["PackingQuantity"],
          EnterpriseCode: data["EnterpriseCode"],
          ProductCode: data["ProductCode"],
          ProductPackingCode: data["ProductPackingCode"],
          Value: data["Value"],
          ValueTyped: data["Value"] == 0.0 ? data["RealCost"] : data["Value"],
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
          BalanceStockSale: data["BalanceStockSale"],
          BalanceLabelType: data["BalanceLabelType"],
          BalanceLabelQuantity: data["BalanceLabelQuantity"],
          OperationalCost: data["OperationalCost"],
          ReplacementCost: data["ReplacementCost"],
          ReplacementCostMidle: data["ReplacementCostMidle"],
          LiquidCost: data["LiquidCost"],
          LiquidCostMidle: data["LiquidCostMidle"],
          RealCost: data["RealCost"],
          RealLiquidCost: data["RealLiquidCost"],
          FiscalCost: data["FiscalCost"],
          FiscalLiquidCost: data["FiscalLiquidCost"],
          Stocks: data["Stocks"],
          StockByEnterpriseAssociateds: data["StockByEnterpriseAssociateds"],
          StorageAreaAddress: data["StorageAreaAddress"],
        ),
      );
    });
  }

  static fromJson(Map json) => BuyRequestProductsModel(
        PLU: json["PLU"],
        Name: json["Name"],
        PackingQuantity: json["PackingQuantity"],
        EnterpriseCode: json["EnterpriseCode"],
        ProductCode: json["ProductCode"],
        ProductPackingCode: json["ProductPackingCode"],
        Value: json["Value"],
        ValueTyped: json["ValueTyped"],
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
        StockByEnterpriseAssociateds:
            json.containsKey("StockByEnterpriseAssociateds")
                ? json["StockByEnterpriseAssociateds"]
                : null,
        StorageAreaAddress: json.containsKey("StorageAreaAddress")
            ? json["StorageAreaAddress"]
            : null,
        quantity: json.containsKey("quantity") ? json["quantity"] : null,
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

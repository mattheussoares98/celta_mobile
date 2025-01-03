import '../../../models/models.dart';

import 'get_product_json.dart';

class GetProductJsonModel {
  int? enterpriseCode;
  int? productCode;
  int? productPackingCode;
  String? plu;
  String? name;
  String? packingQuantity;
  double? value;
  double? retailPracticedPrice;
  double? retailSalePrice;
  double? retailOfferPrice;
  double? wholePracticedPrice;
  double? wholeSalePrice;
  double? wholeOfferPrice;
  double? eCommercePracticedPrice;
  double? eCommerceSalePrice;
  double? eCommerceOfferPrice;
  double? minimumWholeQuantity;
  String? storageAreaAddress;
  String? balanceLabelType;
  double? balanceLabelQuantity;
  late bool pendantPrintLabel;
  double? operationalCost;
  double? replacementCost;
  double? replacementCostMidle;
  double? liquidCost;
  double? liquidCostMidle;
  double? realCost;
  double? realLiquidCost;
  double? fiscalCost;
  double? fiscalLiquidCost;
  bool? markUpdateClassInAdjustSalePriceIndividual;
  bool? inClass;
  bool? isFatherOfGrate;
  bool? alterationPriceForAllPackings;
  bool? isChildOfGrate;
  List<StockByEnterpriseAssociatedsModel>? stockByEnterpriseAssociateds;
  List<StocksModel>? stocks;
  LastBuyEntranceModel? lastBuyEntrance;
  PriceCostModel? priceCost;
  double? valueTyped = 0;
  double quantity = 0;

  String? IncrementPercentageOrValue; //vem somente quando processa o carrinho
  double? IncrementValue; //vem somente quando processa o carrinho
  String? DiscountPercentageOrValue; //vem somente quando processa o carrinho
  double? DiscountValue; //vem somente quando processa o carrinho
  String?
      AutomaticDiscountPercentageOrValue; //vem somente quando processa o carrinho
  double? AutomaticDiscountValue; //vem somente quando processa o carrinho
  double? TotalLiquid; //vem somente quando processa o carrinho

  GetProductJsonModel({
    required this.enterpriseCode,
    required this.productCode,
    required this.productPackingCode,
    required this.plu,
    required this.name,
    required this.packingQuantity,
    required this.value,
    required this.retailPracticedPrice,
    required this.retailSalePrice,
    required this.retailOfferPrice,
    required this.wholePracticedPrice,
    required this.wholeSalePrice,
    required this.wholeOfferPrice,
    required this.eCommercePracticedPrice,
    required this.eCommerceSalePrice,
    required this.eCommerceOfferPrice,
    required this.minimumWholeQuantity,
    required this.storageAreaAddress,
    required this.balanceLabelType,
    required this.balanceLabelQuantity,
    required this.pendantPrintLabel,
    required this.operationalCost,
    required this.replacementCost,
    required this.replacementCostMidle,
    required this.liquidCost,
    required this.liquidCostMidle,
    required this.realCost,
    required this.realLiquidCost,
    required this.fiscalCost,
    required this.fiscalLiquidCost,
    required this.stockByEnterpriseAssociateds,
    required this.stocks,
    required this.lastBuyEntrance,
    required this.markUpdateClassInAdjustSalePriceIndividual,
    required this.inClass,
    required this.isFatherOfGrate,
    required this.alterationPriceForAllPackings,
    required this.isChildOfGrate,
    required this.priceCost,
    required this.quantity,
    this.valueTyped,
    this.IncrementPercentageOrValue,
    this.IncrementValue,
    this.DiscountPercentageOrValue,
    this.DiscountValue,
    this.AutomaticDiscountPercentageOrValue,
    this.AutomaticDiscountValue,
    this.TotalLiquid,
  });

  GetProductJsonModel.fromJson(Map<String, dynamic> json) {
    isChildOfGrate = json['IsChildOfGrate'];
    priceCost = json['PriceCost'] == null
        ? null
        : PriceCostModel.fromJson(json['PriceCost']);
    enterpriseCode = json['EnterpriseCode'];
    productCode = json['ProductCode'];
    productPackingCode = json['ProductPackingCode'];
    plu = json['PLU'];
    name = json['Name'];
    packingQuantity = json['PackingQuantity'];
    value = json['Value'];
    retailPracticedPrice = json['RetailPracticedPrice'];
    retailSalePrice = json['RetailSalePrice'];
    retailOfferPrice = json['RetailOfferPrice'];
    wholePracticedPrice = json['WholePracticedPrice'];
    wholeSalePrice = json['WholeSalePrice'];
    wholeOfferPrice = json['WholeOfferPrice'];
    eCommercePracticedPrice = json['ECommercePracticedPrice'];
    eCommerceSalePrice = json['ECommerceSalePrice'];
    eCommerceOfferPrice = json['ECommerceOfferPrice'];
    minimumWholeQuantity = json['MinimumWholeQuantity'];
    storageAreaAddress = json['StorageAreaAddress'];
    balanceLabelType = json['BalanceLabelType'];
    balanceLabelQuantity = json['BalanceLabelQuantity'];
    pendantPrintLabel = json['PendantPrintLabel'] ?? false;
    operationalCost = json['OperationalCost'];
    replacementCost = json['ReplacementCost'];
    replacementCostMidle = json['ReplacementCostMidle'];
    liquidCost = json['LiquidCost'];
    liquidCostMidle = json['LiquidCostMidle'];
    realCost = json['RealCost'];
    realLiquidCost = json['RealLiquidCost'];
    fiscalCost = json['FiscalCost'];
    fiscalLiquidCost = json['FiscalLiquidCost'];
    markUpdateClassInAdjustSalePriceIndividual =
        json["MarkUpdateClassInAdjustSalePriceIndividual"] ?? false;
    inClass = json["InClass"] ?? false;
    isFatherOfGrate = json["IsFatherOfGrate"] ?? false;

    alterationPriceForAllPackings =
        json["AlterationPriceForAllPackings"] ?? false;

    valueTyped = json["valueTyped"] ?? 0;
    quantity = json["quantity"] ?? 0;

    IncrementPercentageOrValue = json["IncrementPercentageOrValue"];
    IncrementValue = json["IncrementValue"];
    DiscountPercentageOrValue = json["DiscountPercentageOrValue"];
    DiscountValue = json["DiscountValue"];
    AutomaticDiscountPercentageOrValue =
        json["AutomaticDiscountPercentageOrValue"];
    AutomaticDiscountValue = json["AutomaticDiscountValue"];
    TotalLiquid = json["TotalLiquid"];

    if (json['StockByEnterpriseAssociateds'] != null) {
      stockByEnterpriseAssociateds = <StockByEnterpriseAssociatedsModel>[];
      json['StockByEnterpriseAssociateds'].forEach((v) {
        stockByEnterpriseAssociateds!
            .add(new StockByEnterpriseAssociatedsModel.fromJson(v));
      });
    }
    if (json['Stocks'] != null) {
      stocks = <StocksModel>[];
      json['Stocks'].forEach((v) {
        stocks!.add(new StocksModel.fromJson(v));
      });
    }

    if (json["LastBuyEntrance"] != null) {
      lastBuyEntrance = LastBuyEntranceModel.fromJson(json['LastBuyEntrance']);
    } else {
      lastBuyEntrance = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EnterpriseCode'] = this.enterpriseCode;
    data['PriceCost'] = this.priceCost;
    data['IsChildOfGrate'] = this.isChildOfGrate;
    data['ProductCode'] = this.productCode;
    data['ProductPackingCode'] = this.productPackingCode;
    data['PLU'] = this.plu;
    data['Name'] = this.name;
    data['PackingQuantity'] = this.packingQuantity;
    data['Value'] = this.value;
    data['RetailPracticedPrice'] = this.retailPracticedPrice;
    data['RetailSalePrice'] = this.retailSalePrice;
    data['RetailOfferPrice'] = this.retailOfferPrice;
    data['WholePracticedPrice'] = this.wholePracticedPrice;
    data['WholeSalePrice'] = this.wholeSalePrice;
    data['WholeOfferPrice'] = this.wholeOfferPrice;
    data['ECommercePracticedPrice'] = this.eCommercePracticedPrice;
    data['ECommerceSalePrice'] = this.eCommerceSalePrice;
    data['ECommerceOfferPrice'] = this.eCommerceOfferPrice;
    data['MinimumWholeQuantity'] = this.minimumWholeQuantity;
    data['StorageAreaAddress'] = this.storageAreaAddress;
    data['BalanceLabelType'] = this.balanceLabelType;
    data['BalanceLabelQuantity'] = this.balanceLabelQuantity;
    data['PendantPrintLabel'] = this.pendantPrintLabel;
    data['OperationalCost'] = this.operationalCost;
    data['ReplacementCost'] = this.replacementCost;
    data['ReplacementCostMidle'] = this.replacementCostMidle;
    data['LiquidCost'] = this.liquidCost;
    data['LiquidCostMidle'] = this.liquidCostMidle;
    data['RealCost'] = this.realCost;
    data['RealLiquidCost'] = this.realLiquidCost;
    data['FiscalCost'] = this.fiscalCost;
    data['FiscalLiquidCost'] = this.fiscalLiquidCost;
    data['valueTyped'] = this.valueTyped;
    data['quantity'] = this.quantity;
    data["markUpdateClassInAdjustSalePriceIndividual"] =
        this.markUpdateClassInAdjustSalePriceIndividual;
    data["inClass"] = this.inClass;
    data["isFatherOfGrate"] = this.isFatherOfGrate;
    data["alterationPriceForAllPackings"] = this.alterationPriceForAllPackings;
    if (this.stockByEnterpriseAssociateds != null) {
      data['StockByEnterpriseAssociateds'] =
          this.stockByEnterpriseAssociateds!.map((v) => v.toJson()).toList();
    }
    if (this.stocks != null) {
      data['Stocks'] = this.stocks!.map((v) => v.toJson()).toList();
    }
    data['LastBuyEntrance'] = this.lastBuyEntrance;
    data["IncrementPercentageOrValue"] = this.IncrementPercentageOrValue;
    data["IncrementValue"] = this.IncrementValue;
    data["DiscountPercentageOrValue"] = this.DiscountPercentageOrValue;
    data["DiscountValue"] = this.DiscountValue;
    data["AutomaticDiscountPercentageOrValue"] =
        this.AutomaticDiscountPercentageOrValue;
    data["AutomaticDiscountValue"] = this.AutomaticDiscountValue;
    data["TotalLiquid"] = this.TotalLiquid;
    return data;
  }
}

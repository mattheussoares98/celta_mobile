import '../../../models/models.dart';

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
  String? DiscountDescription; //vem somente quando processa o carrinho
  String? ExpectedDeliveryDate; //vem somente quando processa o carrinho
  String? Observations; //vem somente quando processa o carrinho

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
    this.DiscountDescription,
    this.ExpectedDeliveryDate,
    this.Observations,
  });

  factory GetProductJsonModel.fromJson(Map json) => GetProductJsonModel(
        isChildOfGrate: json['IsChildOfGrate'],
        priceCost: json['PriceCost'] == null
            ? null
            : PriceCostModel.fromJson(json['PriceCost']),
        enterpriseCode: json['EnterpriseCode'],
        productCode: json['ProductCode'],
        productPackingCode: json['ProductPackingCode'],
        plu: json['PLU'],
        name: json['Name'],
        packingQuantity: json['PackingQuantity'],
        value: json['Value'],
        retailPracticedPrice: json['RetailPracticedPrice'],
        retailSalePrice: json['RetailSalePrice'],
        retailOfferPrice: json['RetailOfferPrice'],
        wholePracticedPrice: json['WholePracticedPrice'],
        wholeSalePrice: json['WholeSalePrice'],
        wholeOfferPrice: json['WholeOfferPrice'],
        eCommercePracticedPrice: json['ECommercePracticedPrice'],
        eCommerceSalePrice: json['ECommerceSalePrice'],
        eCommerceOfferPrice: json['ECommerceOfferPrice'],
        minimumWholeQuantity: json['MinimumWholeQuantity'],
        storageAreaAddress: json['StorageAreaAddress'],
        balanceLabelType: json['BalanceLabelType'],
        balanceLabelQuantity: json['BalanceLabelQuantity'],
        pendantPrintLabel: json['PendantPrintLabel'] ?? false,
        operationalCost: json['OperationalCost'],
        replacementCost: json['ReplacementCost'],
        replacementCostMidle: json['ReplacementCostMidle'],
        liquidCost: json['LiquidCost'],
        liquidCostMidle: json['LiquidCostMidle'],
        realCost: json['RealCost'],
        realLiquidCost: json['RealLiquidCost'],
        fiscalCost: json['FiscalCost'],
        fiscalLiquidCost: json['FiscalLiquidCost'],
        markUpdateClassInAdjustSalePriceIndividual:
            json["MarkUpdateClassInAdjustSalePriceIndividual"] ?? false,
        inClass: json["InClass"] ?? false,
        isFatherOfGrate: json["IsFatherOfGrate"] ?? false,
        alterationPriceForAllPackings:
            json["AlterationPriceForAllPackings"] ?? false,
        valueTyped: json["valueTyped"] ?? 0,
        quantity: json["quantity"] ?? 0,
        IncrementPercentageOrValue: json["IncrementPercentageOrValue"],
        IncrementValue: json["IncrementValue"],
        DiscountPercentageOrValue: json["DiscountPercentageOrValue"],
        DiscountValue: json["DiscountValue"],
        ExpectedDeliveryDate: json["ExpectedDeliveryDate"],
        Observations: json["Observations"],
        AutomaticDiscountPercentageOrValue:
            json["AutomaticDiscountPercentageOrValue"],
        AutomaticDiscountValue: json["AutomaticDiscountValue"],
        TotalLiquid: json["TotalLiquid"],
        DiscountDescription: json["DiscountDescription"],
        stockByEnterpriseAssociateds: json['StockByEnterpriseAssociateds']
            ?.map<StockByEnterpriseAssociatedsModel>(
                (e) => StockByEnterpriseAssociatedsModel.fromJson(e))
            .toList(),
        stocks: json['Stocks']
            ?.map<StocksModel>((e) => StocksModel.fromJson(e))
            .toList(),
        lastBuyEntrance: json['LastBuyEntrance'] != null
            ? LastBuyEntranceModel.fromJson(json['LastBuyEntrance'])
            : null,
      );

  factory GetProductJsonModel.fromProcessedCart({
    required GetProductJsonModel oldProduct,
    required SaleRequestProductProcessCartModel processedProductCart,
  }) =>
      GetProductJsonModel(
        AutomaticDiscountPercentageOrValue:
            processedProductCart.AutomaticDiscountPercentageOrValue,
        AutomaticDiscountValue: processedProductCart.AutomaticDiscountValue,
        DiscountPercentageOrValue:
            processedProductCart.DiscountPercentageOrValue,
        DiscountValue: processedProductCart.DiscountValue,
        IncrementPercentageOrValue:
            processedProductCart.IncrementPercentageOrValue,
        IncrementValue: processedProductCart.IncrementValue,
        TotalLiquid: processedProductCart.TotalLiquid,
        quantity: processedProductCart.Quantity ?? 1,
        value: processedProductCart.Value,
        DiscountDescription: processedProductCart.DiscountDescription,
        ExpectedDeliveryDate: processedProductCart.ExpectedDeliveryDate,
        Observations: processedProductCart.Observations,
        enterpriseCode: oldProduct.enterpriseCode,
        productCode: oldProduct.productCode,
        productPackingCode: oldProduct.productPackingCode,
        valueTyped: oldProduct.valueTyped,
        plu: oldProduct.plu,
        name: oldProduct.name,
        packingQuantity: oldProduct.packingQuantity,
        retailPracticedPrice: oldProduct.retailPracticedPrice,
        retailSalePrice: oldProduct.retailSalePrice,
        retailOfferPrice: oldProduct.retailOfferPrice,
        wholePracticedPrice: oldProduct.wholePracticedPrice,
        wholeSalePrice: oldProduct.wholeSalePrice,
        wholeOfferPrice: oldProduct.wholeOfferPrice,
        eCommercePracticedPrice: oldProduct.eCommercePracticedPrice,
        eCommerceSalePrice: oldProduct.eCommerceSalePrice,
        eCommerceOfferPrice: oldProduct.eCommerceOfferPrice,
        minimumWholeQuantity: oldProduct.minimumWholeQuantity,
        storageAreaAddress: oldProduct.storageAreaAddress,
        balanceLabelType: oldProduct.balanceLabelType,
        balanceLabelQuantity: oldProduct.balanceLabelQuantity,
        pendantPrintLabel: oldProduct.pendantPrintLabel,
        operationalCost: oldProduct.operationalCost,
        replacementCost: oldProduct.replacementCost,
        replacementCostMidle: oldProduct.replacementCostMidle,
        liquidCost: oldProduct.liquidCost,
        liquidCostMidle: oldProduct.liquidCostMidle,
        realCost: oldProduct.realCost,
        realLiquidCost: oldProduct.realLiquidCost,
        fiscalCost: oldProduct.fiscalCost,
        fiscalLiquidCost: oldProduct.fiscalLiquidCost,
        stockByEnterpriseAssociateds: oldProduct.stockByEnterpriseAssociateds,
        stocks: oldProduct.stocks,
        lastBuyEntrance: oldProduct.lastBuyEntrance,
        markUpdateClassInAdjustSalePriceIndividual:
            oldProduct.markUpdateClassInAdjustSalePriceIndividual,
        inClass: oldProduct.inClass,
        isFatherOfGrate: oldProduct.isFatherOfGrate,
        alterationPriceForAllPackings: oldProduct.alterationPriceForAllPackings,
        isChildOfGrate: oldProduct.isChildOfGrate,
        priceCost: oldProduct.priceCost,
      );

  Map<String, dynamic> toJson() => {
        'EnterpriseCode': this.enterpriseCode,
        'PriceCost': this.priceCost,
        'IsChildOfGrate': this.isChildOfGrate,
        'ProductCode': this.productCode,
        'ProductPackingCode': this.productPackingCode,
        'PLU': this.plu,
        'Name': this.name,
        'PackingQuantity': this.packingQuantity,
        'Value': this.value,
        'RetailPracticedPrice': this.retailPracticedPrice,
        'RetailSalePrice': this.retailSalePrice,
        'RetailOfferPrice': this.retailOfferPrice,
        'WholePracticedPrice': this.wholePracticedPrice,
        'WholeSalePrice': this.wholeSalePrice,
        'WholeOfferPrice': this.wholeOfferPrice,
        'ECommercePracticedPrice': this.eCommercePracticedPrice,
        'ECommerceSalePrice': this.eCommerceSalePrice,
        'ECommerceOfferPrice': this.eCommerceOfferPrice,
        'MinimumWholeQuantity': this.minimumWholeQuantity,
        'StorageAreaAddress': this.storageAreaAddress,
        'BalanceLabelType': this.balanceLabelType,
        'BalanceLabelQuantity': this.balanceLabelQuantity,
        'PendantPrintLabel': this.pendantPrintLabel,
        'OperationalCost': this.operationalCost,
        'ReplacementCost': this.replacementCost,
        'ReplacementCostMidle': this.replacementCostMidle,
        'LiquidCost': this.liquidCost,
        'LiquidCostMidle': this.liquidCostMidle,
        'RealCost': this.realCost,
        'RealLiquidCost': this.realLiquidCost,
        'FiscalCost': this.fiscalCost,
        'FiscalLiquidCost': this.fiscalLiquidCost,
        'valueTyped': this.valueTyped,
        'quantity': this.quantity,
        "markUpdateClassInAdjustSalePriceIndividual":
            this.markUpdateClassInAdjustSalePriceIndividual,
        "inClass": this.inClass,
        "isFatherOfGrate": this.isFatherOfGrate,
        "alterationPriceForAllPackings": this.alterationPriceForAllPackings,
        'StockByEnterpriseAssociateds':
            this.stockByEnterpriseAssociateds?.map((v) => v.toJson()).toList(),
        'Stocks': this.stocks?.map((v) => v.toJson()).toList(),
        'LastBuyEntrance': this.lastBuyEntrance,
        "IncrementPercentageOrValue": this.IncrementPercentageOrValue,
        "IncrementValue": this.IncrementValue,
        "DiscountPercentageOrValue": this.DiscountPercentageOrValue,
        "DiscountValue": this.DiscountValue,
        "AutomaticDiscountPercentageOrValue":
            this.AutomaticDiscountPercentageOrValue,
        "AutomaticDiscountValue": this.AutomaticDiscountValue,
        "TotalLiquid": this.TotalLiquid,
        "DiscountDescription": this.DiscountDescription,
        "ExpectedDeliveryDate": this.ExpectedDeliveryDate,
        "Observations": this.Observations,
      };
}

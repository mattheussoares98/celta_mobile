import 'dart:convert';

import 'get_product_json.dart';

class GetProductJsonModel {
  int? enterpriseCode;
  int? productCode;
  int? productPackingCode;
  String? pLU;
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
  double? balanceStockSale;
  String? storageAreaAddress;
  String? balanceLabelType;
  double? balanceLabelQuantity;
  bool? pendantPrintLabel;
  double? operationalCost;
  double? replacementCost;
  double? replacementCostMidle;
  double? liquidCost;
  double? liquidCostMidle;
  double? realCost;
  double? realLiquidCost;
  double? fiscalCost;
  double? fiscalLiquidCost;
  List<StockByEnterpriseAssociatedsModel>? stockByEnterpriseAssociateds;
  List<StocksModel>? stocks;
  dynamic lastBuyEntrance;

  GetProductJsonModel({
    this.enterpriseCode,
    this.productCode,
    this.productPackingCode,
    this.pLU,
    this.name,
    this.packingQuantity,
    this.value,
    this.retailPracticedPrice,
    this.retailSalePrice,
    this.retailOfferPrice,
    this.wholePracticedPrice,
    this.wholeSalePrice,
    this.wholeOfferPrice,
    this.eCommercePracticedPrice,
    this.eCommerceSalePrice,
    this.eCommerceOfferPrice,
    this.minimumWholeQuantity,
    this.balanceStockSale,
    this.storageAreaAddress,
    this.balanceLabelType,
    this.balanceLabelQuantity,
    this.pendantPrintLabel,
    this.operationalCost,
    this.replacementCost,
    this.replacementCostMidle,
    this.liquidCost,
    this.liquidCostMidle,
    this.realCost,
    this.realLiquidCost,
    this.fiscalCost,
    this.fiscalLiquidCost,
    this.stockByEnterpriseAssociateds,
    this.stocks,
    this.lastBuyEntrance,
  });

  GetProductJsonModel.fromJson(Map<String, dynamic> json) {
    enterpriseCode = json['EnterpriseCode'];
    productCode = json['ProductCode'];
    productPackingCode = json['ProductPackingCode'];
    pLU = json['PLU'];
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
    balanceStockSale = json['BalanceStockSale'];
    storageAreaAddress = json['StorageAreaAddress'];
    balanceLabelType = json['BalanceLabelType'];
    balanceLabelQuantity = json['BalanceLabelQuantity'];
    pendantPrintLabel = json['PendantPrintLabel'];
    operationalCost = json['OperationalCost'];
    replacementCost = json['ReplacementCost'];
    replacementCostMidle = json['ReplacementCostMidle'];
    liquidCost = json['LiquidCost'];
    liquidCostMidle = json['LiquidCostMidle'];
    realCost = json['RealCost'];
    realLiquidCost = json['RealLiquidCost'];
    fiscalCost = json['FiscalCost'];
    fiscalLiquidCost = json['FiscalLiquidCost'];
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
    lastBuyEntrance = json['LastBuyEntrance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EnterpriseCode'] = this.enterpriseCode;
    data['ProductCode'] = this.productCode;
    data['ProductPackingCode'] = this.productPackingCode;
    data['PLU'] = this.pLU;
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
    data['BalanceStockSale'] = this.balanceStockSale;
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
    if (this.stockByEnterpriseAssociateds != null) {
      data['StockByEnterpriseAssociateds'] =
          this.stockByEnterpriseAssociateds!.map((v) => v.toJson()).toList();
    }
    if (this.stocks != null) {
      data['Stocks'] = this.stocks!.map((v) => v.toJson()).toList();
    }
    data['LastBuyEntrance'] = this.lastBuyEntrance;
    return data;
  }

  static responseAsStringToGetProductJsonModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        GetProductJsonModel.fromJson(data),
      );
    });
  }
}

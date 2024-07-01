import 'dart:convert';

import '../../../../models/soap/soap.dart';

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
  double? balanceStockSale;
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
  List<StockByEnterpriseAssociatedsModel>? stockByEnterpriseAssociateds;
  List<StocksModel>? stocks;
  LastBuyEntranceModel? lastBuyEntrance;

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
    required this.balanceStockSale,
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
  });

  GetProductJsonModel.fromJson(Map<String, dynamic> json) {
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
    balanceStockSale = json['BalanceStockSale'];
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

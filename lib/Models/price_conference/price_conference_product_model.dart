import 'price_conference_stock_model.dart';

class PriceConferenceProductsModel {
  final String PriceLookUp;
  final String ProductName;
  final String Packing;
  final String PackingQuantity;
  final String Name;
  final String ReducedName;
  final int ProductPackingCode;
  final bool AllowTransfer;
  final bool AllowSale;
  final bool AllowBuy;
  final double MinimumWholeQuantity;
  final String SalePracticedWholeSale;
  final String OperationalCost;
  final String ReplacementCost;
  final String ReplacementCostMidle;
  final String LiquidCost;
  final String LiquidCostMidle;
  final String RealCost;
  final String RealLiquidCost;
  final String FiscalCost;
  final String FiscalLiquidCost;
  final String SaldoEstoqueVenda;
  dynamic //quando filtra os produtos por preço, precisa converter para double para conseguir ordenar corretamente. Como estava por string, não estava organizando corretamente
      SalePracticedRetail; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  String
      CurrentStock; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  bool
      EtiquetaPendente; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  final List<PriceConferenceStockModel> stocks;

  PriceConferenceProductsModel({
    required this.PriceLookUp,
    required this.ProductName,
    required this.Packing,
    required this.PackingQuantity,
    required this.Name,
    required this.ReducedName,
    required this.ProductPackingCode,
    required this.AllowTransfer,
    required this.AllowSale,
    required this.AllowBuy,
    required this.MinimumWholeQuantity,
    required this.SalePracticedRetail,
    required this.SalePracticedWholeSale,
    required this.OperationalCost,
    required this.ReplacementCost,
    required this.ReplacementCostMidle,
    required this.LiquidCost,
    required this.LiquidCostMidle,
    required this.RealCost,
    required this.RealLiquidCost,
    required this.FiscalCost,
    required this.FiscalLiquidCost,
    required this.CurrentStock,
    required this.SaldoEstoqueVenda,
    required this.EtiquetaPendente,
    required this.stocks,
  });

  factory PriceConferenceProductsModel.fromJson(Map map) =>
      PriceConferenceProductsModel(
        PriceLookUp: map["Produtos"]["PriceLookUp"],
        ProductName: map["Produtos"]["ProductName"],
        Packing: map["Produtos"]["Packing"],
        PackingQuantity: map["Produtos"]["PackingQuantity"],
        Name: map["Produtos"]["Name"],
        ReducedName: map["Produtos"]["ReducedName"],
        ProductPackingCode: int.parse(map["Produtos"]["ProductPackingCode"]),
        AllowTransfer: map["Produtos"]["AllowTransfer"] == "1" ? true : false,
        AllowSale: map["Produtos"]["AllowSale"] == "1" ? true : false,
        AllowBuy: map["Produtos"]["AllowBuy"] == "1" ? true : false,
        MinimumWholeQuantity:
            double.parse(map["Produtos"]["MinimumWholeQuantity"]),
        SalePracticedRetail: map["Produtos"]["SalePracticedRetail"],
        SalePracticedWholeSale: map["Produtos"]["SalePracticedWholeSale"],
        OperationalCost: map["Produtos"]["OperationalCost"],
        ReplacementCost: map["Produtos"]["ReplacementCost"],
        ReplacementCostMidle: map["Produtos"]["ReplacementCostMidle"],
        LiquidCost: map["Produtos"]["LiquidCost"],
        LiquidCostMidle: map["Produtos"]["LiquidCostMidle"],
        RealCost: map["Produtos"]["RealCost"],
        RealLiquidCost: map["Produtos"]["RealLiquidCost"],
        FiscalCost: map["Produtos"]["FiscalCost"],
        FiscalLiquidCost: map["Produtos"]["FiscalLiquidCost"],
        CurrentStock: map["Produtos"]["CurrentStock"],
        SaldoEstoqueVenda: map["Produtos"]["SaldoEstoqueVenda"],
        EtiquetaPendente:
            map["Produtos"]["EtiquetaPendente"] == "true" ? true : false,
        stocks: map["Stocks"]
            .map<PriceConferenceStockModel>(
                (element) => PriceConferenceStockModel.fromJson(element))
            .toList(),
      );

  static resultAsStringToConsultPriceModel({
    required dynamic data,
    required List listToAdd,
  }) {
    if (data == null) {
      return;
    }
    List dataList = [];
    if (data is Map) {
      dataList.add(data);
    } else {
      dataList = data;
    }

    listToAdd.addAll(dataList
        .map((element) => PriceConferenceProductsModel.fromJson(element))
        .toList());
  }
}

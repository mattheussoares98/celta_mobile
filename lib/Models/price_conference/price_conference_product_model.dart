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
  });

  factory PriceConferenceProductsModel.fromJson(Map map) =>
      PriceConferenceProductsModel(
        PriceLookUp: map["PriceLookUp"],
        ProductName: map["ProductName"],
        Packing: map["Packing"],
        PackingQuantity: map["PackingQuantity"],
        Name: map["Name"],
        ReducedName: map["ReducedName"],
        ProductPackingCode: int.parse(map["ProductPackingCode"]),
        AllowTransfer: map["AllowTransfer"] == "1" ? true : false,
        AllowSale: map["AllowSale"] == "1" ? true : false,
        AllowBuy: map["AllowBuy"] == "1" ? true : false,
        MinimumWholeQuantity: double.parse(map["MinimumWholeQuantity"]),
        SalePracticedRetail: map["SalePracticedRetail"],
        SalePracticedWholeSale: map["SalePracticedWholeSale"],
        OperationalCost: map["OperationalCost"],
        ReplacementCost: map["ReplacementCost"],
        ReplacementCostMidle: map["ReplacementCostMidle"],
        LiquidCost: map["LiquidCost"],
        LiquidCostMidle: map["LiquidCostMidle"],
        RealCost: map["RealCost"],
        RealLiquidCost: map["RealLiquidCost"],
        FiscalCost: map["FiscalCost"],
        FiscalLiquidCost: map["FiscalLiquidCost"],
        CurrentStock: map["CurrentStock"],
        SaldoEstoqueVenda: map["SaldoEstoqueVenda"],
        EtiquetaPendente: map["EtiquetaPendente"] == "true" ? true : false,
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

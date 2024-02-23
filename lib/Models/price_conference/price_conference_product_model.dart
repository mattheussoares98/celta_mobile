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

    dataList.forEach((element) {
      listToAdd.add(
        PriceConferenceProductsModel(
          PriceLookUp: element["PriceLookUp"],
          ProductName: element["ProductName"],
          Packing: element["Packing"],
          PackingQuantity: element["PackingQuantity"],
          Name: element["Name"],
          ReducedName: element["ReducedName"],
          ProductPackingCode: int.parse(element["ProductPackingCode"]),
          AllowTransfer: element["AllowTransfer"] == "1" ? true : false,
          AllowSale: element["AllowSale"] == "1" ? true : false,
          AllowBuy: element["AllowBuy"] == "1" ? true : false,
          MinimumWholeQuantity: double.parse(element["MinimumWholeQuantity"]),
          SalePracticedRetail: element["SalePracticedRetail"],
          SalePracticedWholeSale: element["SalePracticedWholeSale"],
          OperationalCost: element["OperationalCost"],
          ReplacementCost: element["ReplacementCost"],
          ReplacementCostMidle: element["ReplacementCostMidle"],
          LiquidCost: element["LiquidCost"],
          LiquidCostMidle: element["LiquidCostMidle"],
          RealCost: element["RealCost"],
          RealLiquidCost: element["RealLiquidCost"],
          FiscalCost: element["FiscalCost"],
          FiscalLiquidCost: element["FiscalLiquidCost"],
          CurrentStock: element["CurrentStock"],
          SaldoEstoqueVenda: element["SaldoEstoqueVenda"],
          EtiquetaPendente:
              element["EtiquetaPendente"] == "true" ? true : false,
        ),
      );
    });
  }
}

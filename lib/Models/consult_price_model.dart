import 'dart:convert';

class ConsultPriceProductsModel {
  final String PriceLookUp;
  final String ProductName;
  final String Packing;
  final String PackingQuantity;
  final String Name;
  final String ReducedName;
  final String PersonalizedCode;
  final int ProductPackingCode;
  final int AllowTransfer;
  final int AllowSale;
  final int AllowBuy;
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
  String
      SalePracticedRetail; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  String
      CurrentStock; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  bool
      EtiquetaPendente; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  String
      EtiquetaPendenteDescricao; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta

  ConsultPriceProductsModel({
    required this.PriceLookUp,
    required this.ProductName,
    required this.Packing,
    required this.PackingQuantity,
    required this.Name,
    required this.ReducedName,
    required this.ProductPackingCode,
    required this.PersonalizedCode,
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
    required this.EtiquetaPendenteDescricao,
  });

  static resultAsStringToConsultPriceModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        ConsultPriceProductsModel(
          PriceLookUp: data["PriceLookUp"],
          ProductName: data["ProductName"],
          Packing: data["Packing"],
          PackingQuantity: data["PackingQuantity"],
          Name: data["Name"],
          ReducedName: data["ReducedName"],
          ProductPackingCode: data["ProductPackingCode"],
          PersonalizedCode: data["PersonalizedCode"],
          AllowTransfer: data["AllowTransfer"],
          AllowSale: data["AllowSale"],
          AllowBuy: data["AllowBuy"],
          MinimumWholeQuantity: data["MinimumWholeQuantity"],
          SalePracticedRetail: data["SalePracticedRetail"],
          SalePracticedWholeSale: data["SalePracticedWholeSale"],
          OperationalCost: data["OperationalCost"],
          ReplacementCost: data["ReplacementCost"],
          ReplacementCostMidle: data["ReplacementCostMidle"],
          LiquidCost: data["LiquidCost"],
          LiquidCostMidle: data["LiquidCostMidle"],
          RealCost: data["RealCost"],
          RealLiquidCost: data["RealLiquidCost"],
          FiscalCost: data["FiscalCost"],
          FiscalLiquidCost: data["FiscalLiquidCost"],
          CurrentStock: data["CurrentStock"],
          SaldoEstoqueVenda: data["SaldoEstoqueVenda"],
          EtiquetaPendente: data["EtiquetaPendente"],
          EtiquetaPendenteDescricao: data["EtiquetaPendenteDescricao"],
        ),
      );
    });
  }
}

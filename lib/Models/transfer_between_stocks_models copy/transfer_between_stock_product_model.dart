import 'dart:convert';

class TransferBetweenStocksProductModel {
  final String PriceLookUp; /* ": "00002-4", */
  final String ProductName; /* ": "Isento", */
  final String CodigoPlu_ProEmb; /* ": "00002-4", */
  final String Nome_Produto; /* ": "Isento", */
  final String Packing; /* ": "UN", */
  final String PackingQuantity; /* ": "UN 1", */
  final String Name; /* ": "Isento (UN 1.000)", */
  final String ReducedName; /* ": "Isento (UN 1.000)", */
  final String PersonalizedCode; /* ": "00002-4", */
  final String SalePracticedRetail; /* ": "0,99", */
  final String SalePracticedWholeSale; /* ": "0,88", */
  final String OperationalCost; /* ": "110,1900", */
  final String ReplacementCost; /* ": "100,0000", */
  final String ReplacementCostMidle; /* ": "100,0000", */
  final String LiquidCost; /* ": "100,0000", */
  final String LiquidCostMidle; /* ": "100,0000", */
  final String RealCost; /* ": "100,0000", */
  final String RealLiquidCost; /* ": "100,0000", */
  final String FiscalCost; /* ": "100,0000", */
  final String FiscalLiquidCost; /* ": "100,0000", */
  final String CurrentStockString; /* ": "Estoque atual: -19,000", */
  final String EtiquetaPendenteDescricao; /* ": "Sim" */
  final bool EtiquetaPendente; /* ": true, */
  final int AllowTransfer; /* ": 1, */
  final int AllowSale; /* ": 1, */
  final int AllowBuy; /* ": 1, */
  final double MinimumWholeQuantity; /* ": 3.000, */
  final int ProductCode; /* ": 4, */
  final int ProductPackingCode; /* ": 3, */
  String CurrentStock; /* ": "-19,000", */
  String SaldoEstoqueVenda; /* ": "-20,000", */
  final List Stocks;

  TransferBetweenStocksProductModel({
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.PriceLookUp,
    required this.ProductName,
    required this.CodigoPlu_ProEmb,
    required this.Nome_Produto,
    required this.Packing,
    required this.PackingQuantity,
    required this.Name,
    required this.ReducedName,
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
    required this.CurrentStockString,
    required this.SaldoEstoqueVenda,
    required this.EtiquetaPendente,
    required this.EtiquetaPendenteDescricao,
    required this.Stocks,
  });

  static resultAsStringToTransferBetweenStocksProductModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        TransferBetweenStocksProductModel(
          ProductCode: data["ProductCode"],
          ProductPackingCode: data["ProductPackingCode"],
          PriceLookUp: data["PriceLookUp"],
          ProductName: data["ProductName"],
          CodigoPlu_ProEmb: data["CodigoPlu_ProEmb"],
          Nome_Produto: data["Nome_Produto"],
          Packing: data["Packing"],
          PackingQuantity: data["PackingQuantity"],
          Name: data["Name"],
          ReducedName: data["ReducedName"],
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
          CurrentStockString: data["CurrentStockString"] == null
              ? "null"
              : data["CurrentStockString"],
          SaldoEstoqueVenda: data["SaldoEstoqueVenda"],
          EtiquetaPendente: data["EtiquetaPendente"],
          EtiquetaPendenteDescricao: data["EtiquetaPendenteDescricao"],
          Stocks: data["Stocks"] == null ? [] : data["Stocks"],
        ),
      );
    });
  }
}

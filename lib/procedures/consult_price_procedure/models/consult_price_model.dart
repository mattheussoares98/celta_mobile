class ConsultPriceModel {
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

  ConsultPriceModel({
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
}

import '../products.dart';

class GetProductCmxJson {
  final String PriceLookUp;
  final String CodigoPlu_ProEmb;
  final String Nome_Produto;
  final String Packing;
  final String PackingQuantity;
  final String Name;
  final String ReducedName;
  final String PersonalizedCode;
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
  final String CurrentStockString;
  final bool AllowTransfer;
  final bool AllowSale;
  final bool AllowBuy;
  final double MinimumWholeQuantity;
  final int ProductCode;
  final int ProductPackingCode;
  String SaldoEstoqueVenda;
  dynamic //quando filtra os produtos por preço, precisa converter para double para conseguir ordenar corretamente. Como estava por string, não estava organizando corretamente
      SalePracticedRetail; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  String
      CurrentStock; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  bool
      EtiquetaPendente; //não deixei como "final" também porque precisei fazer alterações neles depois da consulta
  final List<GetProductCmxJsonStockAllStocksModel> Stocks;

  GetProductCmxJson({
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.PriceLookUp,
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
    required this.Stocks,
  });

  static dataToGetProductCmxJson({
    required Map data,
    required List listToAdd,
  }) {
    List dataList = [];
    dataList.add(data);

    dataList.forEach((element) {
      //percorrer os produtos aqui para fazer isso abaixo
      _treatStocks(element);
      _treatProducts(element: element, listToAdd: listToAdd);
    });
  }

  static Map<String, List<GetProductCmxJsonStockAllStocksModel>> _stocks = {};
  static _treatStocks(dynamic element) {
    _stocks = {};
    element["Stocks"].forEach((stockElement) {
      String stockKey = stockElement["CodigoInterno_ProEmpEmb"];
      if (_stocks.containsKey(stockKey)) {
        _stocks[stockKey]!.add(
          GetProductCmxJsonStockAllStocksModel(
            CodigoInterno_ProEmpEmb: int.parse(stockKey),
            StockName: stockElement["StockName"],
            StockQuantity: double.parse(stockElement["StockQuantity"]),
          ),
        );
      } else {
        _stocks[stockKey] = [
          GetProductCmxJsonStockAllStocksModel(
            CodigoInterno_ProEmpEmb:
                int.parse(stockElement["CodigoInterno_ProEmpEmb"]),
            StockName: stockElement["StockName"],
            StockQuantity: double.parse(stockElement["StockQuantity"]),
          ),
        ];
      }
    });
  }

  static _treatProducts({
    required dynamic element,
    required List listToAdd,
  }) {
    List products = [];
    if (element["Produtos"] is Map) {
      products.add(element["Produtos"]);
    } else {
      products = element["Produtos"];
    }
    products.forEach((productElement) {
      listToAdd.add(
        GetProductCmxJson(
          ProductCode: int.parse(productElement["ProductCode"]),
          ProductPackingCode: int.parse(productElement["ProductPackingCode"]),
          PriceLookUp: productElement["PriceLookUp"],
          CodigoPlu_ProEmb: productElement["CodigoPlu_ProEmb"] ?? "",
          Nome_Produto: productElement["Name"],
          Packing: productElement["Packing"],
          PackingQuantity: productElement["PackingQuantity"],
          Name: productElement["Name"],
          ReducedName: productElement["ReducedName"],
          PersonalizedCode: productElement["PersonalizedCode"] ?? "",
          AllowTransfer: productElement["AllowTransfer"] == "1",
          AllowSale: productElement["AllowSale"] == "1",
          AllowBuy: productElement["AllowBuy"] == "1",
          MinimumWholeQuantity:
              double.parse(productElement["MinimumWholeQuantity"]),
          SalePracticedRetail: productElement["SalePracticedRetail"],
          SalePracticedWholeSale: productElement["SalePracticedWholeSale"],
          OperationalCost: productElement["OperationalCost"],
          ReplacementCost: productElement["ReplacementCost"],
          ReplacementCostMidle: productElement["ReplacementCostMidle"],
          LiquidCost: productElement["LiquidCost"],
          LiquidCostMidle: productElement["LiquidCostMidle"],
          RealCost: productElement["RealCost"],
          RealLiquidCost: productElement["RealLiquidCost"],
          FiscalCost: productElement["FiscalCost"],
          FiscalLiquidCost: productElement["FiscalLiquidCost"],
          CurrentStock: productElement["CurrentStock"],
          CurrentStockString: productElement["CurrentStockString"] == null
              ? "null"
              : productElement["CurrentStockString"],
          SaldoEstoqueVenda: productElement["SaldoEstoqueVenda"],
          EtiquetaPendente: productElement["EtiquetaPendente"] == "true",
          Stocks: _stocks[productElement["CodigoInterno_ProEmpEmb"]]!,
        ),
      );
    });
  }
}

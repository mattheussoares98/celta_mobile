import 'dart:convert';

class AdjustStockAllStocksModel {
  final int CodigoInterno_ProEmpEmb;
  final String StockName;
  final double StockQuantity;

  AdjustStockAllStocksModel({
    required this.CodigoInterno_ProEmpEmb,
    required this.StockName,
    required this.StockQuantity,
  });

  static dataToAdjustStockAllStocksModel({
    required String data,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(data);
    resultAsList.forEach((element) {
      listToAdd.add(
        AdjustStockAllStocksModel(
          CodigoInterno_ProEmpEmb: element["CodigoInterno_ProEmpEmb"],
          StockName: element["StockName"],
          StockQuantity: element["StockQuantity"],
        ),
      );
    });
  }
}

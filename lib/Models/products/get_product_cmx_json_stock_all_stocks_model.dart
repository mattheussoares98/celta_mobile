import 'dart:convert';

class GetProductCmxJsonStockAllStocksModel {
  final int CodigoInterno_ProEmpEmb;
  final String StockName;
  final double StockQuantity;

  GetProductCmxJsonStockAllStocksModel({
    required this.CodigoInterno_ProEmpEmb,
    required this.StockName,
    required this.StockQuantity,
  });

  static dataToGetProductCmxJsonStockAllStocksModel({
    required String data,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(data);
    resultAsList.forEach((element) {
      listToAdd.add(
        GetProductCmxJsonStockAllStocksModel(
          CodigoInterno_ProEmpEmb: element["CodigoInterno_ProEmpEmb"],
          StockName: element["StockName"],
          StockQuantity: element["StockQuantity"],
        ),
      );
    });
  }
}

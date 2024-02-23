import 'dart:convert';

class TransferBetweenPackageAllStocksModel {
  final int CodigoInterno_ProEmpEmb;
  final String StockName;
  final double StockQuantity;

  TransferBetweenPackageAllStocksModel({
    required this.CodigoInterno_ProEmpEmb,
    required this.StockName,
    required this.StockQuantity,
  });

  static dataToTransferBetweenStockAllStocksModel({
    required String data,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(data);
    resultAsList.forEach((element) {
      listToAdd.add(
        TransferBetweenPackageAllStocksModel(
          CodigoInterno_ProEmpEmb: element["CodigoInterno_ProEmpEmb"],
          StockName: element["StockName"],
          StockQuantity: element["StockQuantity"],
        ),
      );
    });
  }
}

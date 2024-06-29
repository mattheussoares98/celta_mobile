class PriceConferenceStockModel {
  final String CodigoInterno_ProEmpEmb;
  final String StockName;
  final String StockQuantity;

  PriceConferenceStockModel({
    required this.CodigoInterno_ProEmpEmb,
    required this.StockName,
    required this.StockQuantity,
  });

  factory PriceConferenceStockModel.fromJson(Map map) =>
      PriceConferenceStockModel(
        CodigoInterno_ProEmpEmb: map["CodigoInterno_ProEmpEmb"],
        StockName: map["StockName"],
        StockQuantity: map["StockQuantity"],
      );

  static resultAsStringToPriceConferenceStocks({
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
        .map((element) => PriceConferenceStockModel.fromJson(element))
        .toList());
  }
}

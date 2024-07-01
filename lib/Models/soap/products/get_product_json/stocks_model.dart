class StocksModel {
  String? stockName;
  double? stockQuantity;

  StocksModel({this.stockName, this.stockQuantity});

  StocksModel.fromJson(Map<String, dynamic> json) {
    stockName = json['StockName'];
    stockQuantity = json['StockQuantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StockName'] = this.stockName;
    data['StockQuantity'] = this.stockQuantity;
    return data;
  }
}

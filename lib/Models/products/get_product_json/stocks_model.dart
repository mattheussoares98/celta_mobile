class StocksModel {
  String? stockName;
  double? stockQuantity;
  String? enterprise;
  int? enterpriseCode;

  StocksModel({
    required this.stockName,
    required this.stockQuantity,
    required this.enterprise,
    required this.enterpriseCode,
  });

  StocksModel.fromJson(Map<String, dynamic> json) {
    stockName = json['StockName'];
    stockQuantity = json['StockQuantity'];
    enterprise = json['Enterprise'];
    enterpriseCode = json['EnterpriseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StockName'] = this.stockName;
    data['StockQuantity'] = this.stockQuantity;
    data['Enterprise'] = this.enterprise;
    data['EnterpriseCode'] = this.enterpriseCode;
    return data;
  }
}

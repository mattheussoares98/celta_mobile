class StockByEnterpriseAssociatedsModel {
  String? enterprise;
  double? stockBalanceForSale;
  dynamic storageAreaAddress;

  StockByEnterpriseAssociatedsModel({
    this.enterprise,
    this.stockBalanceForSale,
    this.storageAreaAddress,
  });

  StockByEnterpriseAssociatedsModel.fromJson(Map<String, dynamic> json) {
    enterprise = json['Enterprise'];
    stockBalanceForSale = json['StockBalanceForSale'];
    storageAreaAddress = json['StorageAreaAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Enterprise'] = this.enterprise;
    data['StockBalanceForSale'] = this.stockBalanceForSale;
    data['StorageAreaAddress'] = this.storageAreaAddress;
    return data;
  }
}

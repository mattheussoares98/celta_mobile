class LastBuyEntranceModel {
  String? number;
  String? entranceDate;
  String? supplier;
  double? quantity;
  String? fiscalCode;

  LastBuyEntranceModel({
    required this.number,
    required this.entranceDate,
    required this.supplier,
    required this.quantity,
    required this.fiscalCode,
  });

  LastBuyEntranceModel.fromJson(Map<String, dynamic> json) {
    number = json['Number'];
    entranceDate = json['EntranceDate'];
    supplier = json['Supplier'];
    quantity = json['Quantity'];
    fiscalCode = json['FiscalCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Number'] = this.number;
    data['EntranceDate'] = this.entranceDate;
    data['Supplier'] = this.supplier;
    data['Quantity'] = this.quantity;
    data['FiscalCode'] = this.fiscalCode;
    return data;
  }
}

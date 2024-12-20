class LastBuyEntranceModel {
  String? number;
  String? entranceDate;
  String? supplier;
  double? quantity;

  LastBuyEntranceModel({
    required this.number,
    required this.entranceDate,
    required this.supplier,
    required this.quantity,
  });

  LastBuyEntranceModel.fromJson(Map<String, dynamic> json) {
    number = json['Number'];
    entranceDate = json['EntranceDate'];
    supplier = json['Supplier'];
    quantity = json['Quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Number'] = this.number;
    data['EntranceDate'] = this.entranceDate;
    data['Supplier'] = this.supplier;
    data['Quantity'] = this.quantity;
    return data;
  }
}

class SoapActionsModel {
  final String documentId;
  final List<dynamic>? datesUsed;
  final List<dynamic>? users;
  final Map<String, dynamic>? adjustStockConfirmQuantity;
  final Map<String, dynamic>? priceConferenceGetProductOrSendToPrint;
  final Map<String, dynamic>? inventoryEntryQuantity;
  final Map<String, dynamic>? receiptEntryQuantity;
  final Map<String, dynamic>? receiptLiberate;
  final Map<String, dynamic>? saleRequestSave;
  final Map<String, dynamic>? transferBetweenStocksConfirmAdjust;
  final Map<String, dynamic>? transferBetweenPackageConfirmAdjust;
  final Map<String, dynamic>? transferRequestSave;
  final Map<String, dynamic>? customerRegister;
  final Map<String, dynamic>? buyRequestSave;
  final Map<String, dynamic>? researchPricesInsertPrice;

  SoapActionsModel({
    required this.documentId,
    required this.datesUsed,
    required this.users,
    required this.adjustStockConfirmQuantity,
    required this.priceConferenceGetProductOrSendToPrint,
    required this.inventoryEntryQuantity,
    required this.receiptEntryQuantity,
    required this.receiptLiberate,
    required this.saleRequestSave,
    required this.transferBetweenStocksConfirmAdjust,
    required this.transferBetweenPackageConfirmAdjust,
    required this.transferRequestSave,
    required this.customerRegister,
    required this.buyRequestSave,
    required this.researchPricesInsertPrice,
  });

  Map<String, dynamic> toJson() => {
        "documentId": documentId,
        "datesUsed": datesUsed,
        "users": users,
        "adjustStockConfirmQuantity": adjustStockConfirmQuantity,
        "priceConferenceGetProductOrSendToPrint":
            priceConferenceGetProductOrSendToPrint,
        "inventoryEntryQuantity": inventoryEntryQuantity,
        "receiptEntryQuantity": receiptEntryQuantity,
        "receiptLiberate": receiptLiberate,
        "saleRequestSave": saleRequestSave,
        "transferBetweenStocksConfirmAdjust":
            transferBetweenStocksConfirmAdjust,
        "transferBetweenPackageConfirmAdjust":
            transferBetweenPackageConfirmAdjust,
        "transferRequestSave": transferRequestSave,
        "customerRegister": customerRegister,
        "buyRequestSave": buyRequestSave,
        "researchPricesInsertPrice": researchPricesInsertPrice,
      };

  factory SoapActionsModel.fromJson({
    required String documentId,
    required Map json,
  }) =>
      SoapActionsModel(
        documentId: documentId,
        datesUsed: json["datesUsed"],
        users: json["users"],
        adjustStockConfirmQuantity: json["adjustStockConfirmQuantity"],
        priceConferenceGetProductOrSendToPrint:
            json["priceConferenceGetProductOrSendToPrint"],
        inventoryEntryQuantity: json["inventoryEntryQuantity"],
        receiptEntryQuantity: json["receiptEntryQuantity"],
        receiptLiberate: json["receiptLiberate"],
        saleRequestSave: json["saleRequestSave"],
        transferBetweenStocksConfirmAdjust:
            json["transferBetweenStocksConfirmAdjust"],
        transferBetweenPackageConfirmAdjust:
            json["transferBetweenPackageConfirmAdjust"],
        transferRequestSave: json["transferRequestSave"],
        customerRegister: json["customerRegister"],
        buyRequestSave: json["buyRequestSave"],
        researchPricesInsertPrice: json["researchPricesInsertPrice"],
      );
}

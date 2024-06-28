class SoapActionsModel {
  final String documentId;
  final List<String>? datesUsed;
  final List<String>? users;
  final String? adjustStockConfirmQuantity;
  final String? priceConferenceGetProductOrSendToPrint;
  final String? inventoryEntryQuantity;
  final String? receiptEntryQuantity;
  final String? receiptLiberate;
  final String? saleRequestSave;
  final String? transferBetweenStocksConfirmAdjust;
  final String? transferBetweenPackageConfirmAdjust;
  final String? transferRequestSave;
  final String? customerRegister;
  final String? buyRequestSave;
  final String? researchPricesInsertPrice;

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

  factory SoapActionsModel.fromJson(Map json) => SoapActionsModel(
        documentId: json["documentId"],
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

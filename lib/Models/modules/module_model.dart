class ModuleModel {
  final bool adjustSalePrice;
  final bool adjustStock;
  final bool buyRequest;
  final bool customerRegister;
  final bool inventory;
  final bool priceConference;
  final bool productsConference;
  final bool receipt;
  final bool researchPrices;
  final bool saleRequest;
  final bool transferBetweenStocks;
  final bool transferRequest;

  ModuleModel({
    required this.adjustSalePrice,
    required this.adjustStock,
    required this.buyRequest,
    required this.customerRegister,
    required this.inventory,
    required this.priceConference,
    required this.productsConference,
    required this.receipt,
    required this.researchPrices,
    required this.saleRequest,
    required this.transferBetweenStocks,
    required this.transferRequest,
  });

  Map<String, dynamic> toJson() => {
        "adjustSalePrice": adjustSalePrice,
        "adjustStock": adjustStock,
        "buyRequest": buyRequest,
        "customerRegister": customerRegister,
        "inventory": inventory,
        "priceConference": priceConference,
        "productsConference": productsConference,
        "receipt": receipt,
        "researchPrices": researchPrices,
        "saleRequest": saleRequest,
        "transferBetweenStocks": transferBetweenStocks,
        "transferRequest": transferRequest,
      };

  factory ModuleModel.fromJson(Map data) => ModuleModel(
        adjustSalePrice: data["adjustSalePrice"],
        adjustStock: data["adjustStock"],
        buyRequest: data["buyRequest"],
        customerRegister: data["customerRegister"],
        inventory: data["inventory"],
        priceConference: data["priceConference"],
        productsConference: data["productsConference"],
        receipt: data["receipt"],
        researchPrices: data["researchPrices"],
        saleRequest: data["saleRequest"],
        transferBetweenStocks: data["transferBetweenStocks"],
        transferRequest: data["transferRequest"],
      );
}

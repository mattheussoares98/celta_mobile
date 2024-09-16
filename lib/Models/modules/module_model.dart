enum Modules {
  adjustSalePrice,
  adjustStock,
  buyRequest,
  customerRegister,
  inventory,
  priceConference,
  productsConference,
  receipt,
  researchPrices,
  saleRequest,
  transferBetweenStocks,
  transferRequest,
}

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
        Modules.adjustSalePrice.name: adjustSalePrice,
        Modules.adjustStock.name: adjustStock,
        Modules.buyRequest.name: buyRequest,
        Modules.customerRegister.name: customerRegister,
        Modules.inventory.name: inventory,
        Modules.priceConference.name: priceConference,
        Modules.productsConference.name: productsConference,
        Modules.receipt.name: receipt,
        Modules.researchPrices.name: researchPrices,
        Modules.saleRequest.name: saleRequest,
        Modules.transferBetweenStocks.name: transferBetweenStocks,
        Modules.transferRequest.name: transferRequest,
      };

  factory ModuleModel.fromJson(Map data) => ModuleModel(
        adjustSalePrice: data["adjustSalePrice"] ?? false,
        adjustStock: data["adjustStock"] ?? false,
        buyRequest: data["buyRequest"] ?? false,
        customerRegister: data["customerRegister"] ?? false,
        inventory: data["inventory"] ?? false,
        priceConference: data["priceConference"] ?? false,
        productsConference: data["productsConference"] ?? false,
        receipt: data["receipt"] ?? false,
        researchPrices: data["researchPrices"] ?? false,
        saleRequest: data["saleRequest"] ?? false,
        transferBetweenStocks: data["transferBetweenStocks"] ?? false,
        transferRequest: data["transferRequest"] ?? false,
      );
}

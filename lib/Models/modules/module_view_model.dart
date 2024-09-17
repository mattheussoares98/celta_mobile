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

class ModuleViewModel {
  final String name;
  final bool enabled;
  final Modules module;

  ModuleViewModel({
    required this.name,
    required this.enabled,
    required this.module,
  });

  factory ModuleViewModel.fromJson(Map data) => ModuleViewModel(
        name: data["name"],
        enabled: data["enabled"],
        module: data["module"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "enabled": enabled,
        "module": module.name,
      };
}

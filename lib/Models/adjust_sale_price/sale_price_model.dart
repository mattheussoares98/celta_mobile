class SaleTypeModel {
  final SaleTypeName saleTypeName;
  bool selected = false;
  final int priceTypeInt;

  SaleTypeModel._({
    required this.saleTypeName,
    required this.selected,
    required this.priceTypeInt,
  });

  factory SaleTypeModel.fromSaleTypeName(SaleTypeName saleTypeName) {
    int priceTypeInt = _getPriceTypeInt(saleTypeName);
    return SaleTypeModel._(
      saleTypeName: saleTypeName,
      priceTypeInt: priceTypeInt,
      selected: false,
    );
  }
}

enum SaleTypeName {
  Varejo,
  Atacado,
  Ecommerce,
}

extension SaleTypeModelExtension on SaleTypeName {
  String get description {
    switch (this) {
      case SaleTypeName.Varejo:
        return "Varejo";
      case SaleTypeName.Atacado:
        return "Atacado";
      case SaleTypeName.Ecommerce:
        return "Ecommerce";
    }
  }
}

int _getPriceTypeInt(SaleTypeName priceTypes) {
  switch (priceTypes) {
    case SaleTypeName.Varejo:
      return 1;
    case SaleTypeName.Atacado:
      return 2;
    case SaleTypeName.Ecommerce:
      return 3;
  }
}

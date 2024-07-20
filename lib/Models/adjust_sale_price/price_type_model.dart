class PriceTypeModel {
  final PriceTypeNames priceTypeName;
  bool selected = false;
  final int priceTypeInt;

  PriceTypeModel._({
    required this.priceTypeName,
    required this.selected,
    required this.priceTypeInt,
  });

  factory PriceTypeModel.fromPriceTypeName(PriceTypeNames priceTypeName) {
    int priceTypeInt = _getPriceTypeInt(priceTypeName);
    return PriceTypeModel._(
      priceTypeName: priceTypeName,
      priceTypeInt: priceTypeInt,
      selected: false,
    );
  }
}

enum PriceTypeNames {
  Varejo,
  Atacado,
  Ecommerce,
}

extension PriceTypeModelExtension on PriceTypeNames {
  String get description {
    switch (this) {
      case PriceTypeNames.Varejo:
        return "Varejo";
      case PriceTypeNames.Atacado:
        return "Atacado";
      case PriceTypeNames.Ecommerce:
        return "Ecommerce";
    }
  }
}

int _getPriceTypeInt(PriceTypeNames priceTypes) {
  switch (priceTypes) {
    case PriceTypeNames.Varejo:
      return 1;
    case PriceTypeNames.Atacado:
      return 2;
    case PriceTypeNames.Ecommerce:
      return 3;
  }
}

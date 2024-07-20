class PriceTypeModel {
  final PriceTypeNames priceTypeName;

  PriceTypeModel._({
    required this.priceTypeName,
    required int priceTypeInt,
  });

  factory PriceTypeModel.fromPriceTypeName(PriceTypeNames priceTypeName) {
    int priceTypeInt = _getPriceTypeInt(priceTypeName);
    return PriceTypeModel._(
      priceTypeName: priceTypeName,
      priceTypeInt: priceTypeInt,
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

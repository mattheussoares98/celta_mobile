class PriceTypeModel {
  final PriceTypeName priceTypeName;
  bool selected;

  PriceTypeModel({
    required this.priceTypeName,
    this.selected = false,
  });
}

enum PriceTypeName {
  Venda,
  Oferta,
}

extension SaleTypeNameExtension on PriceTypeName {
  String get description {
    switch (this) {
      case PriceTypeName.Venda:
        return "Venda";
      case PriceTypeName.Oferta:
        return "Oferta";
    }
  }
}

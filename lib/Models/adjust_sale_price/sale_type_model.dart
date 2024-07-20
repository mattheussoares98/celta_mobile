class SaleTypeModel {
  final SaleTypeName saleTypeName;
  bool selected;

  SaleTypeModel({
    required this.saleTypeName,
    this.selected = false,
  });
}

enum SaleTypeName {
  Venda,
  Oferta,
}

extension SaleTypeNameExtension on SaleTypeName {
  String get description {
    switch (this) {
      case SaleTypeName.Venda:
        return "Venda";
      case SaleTypeName.Oferta:
        return "Oferta";
    }
  }
}

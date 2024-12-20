class ProductWithoutCadasterModel {
  final int CodigoInterno_ProcRecebProNaoIden;
  final double Quantidade_ProcRecebProNaoIden;
  final String Ean_ProcRecebProNaoIden;
  final String Obs_ProcRecebProNaoIden;

  const ProductWithoutCadasterModel({
    required this.CodigoInterno_ProcRecebProNaoIden,
    required this.Quantidade_ProcRecebProNaoIden,
    required this.Ean_ProcRecebProNaoIden,
    required this.Obs_ProcRecebProNaoIden,
  });

  factory ProductWithoutCadasterModel.fromJson(Map json) =>
      ProductWithoutCadasterModel(
        CodigoInterno_ProcRecebProNaoIden:
            int.parse(json["CodigoInterno_ProcRecebProNaoIden"]),
        Quantidade_ProcRecebProNaoIden:
            double.parse(json["Quantidade_ProcRecebProNaoIden"]),
        Ean_ProcRecebProNaoIden: json["Ean_ProcRecebProNaoIden"],
        Obs_ProcRecebProNaoIden: json["Obs_ProcRecebProNaoIden"],
      );
}

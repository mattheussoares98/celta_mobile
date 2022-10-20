class ConferenceProductModel {
  final String Nome_Produto;
  final String FormatedProduct;
  final int CodigoInterno_Produto;
  final int CodigoInterno_ProEmb;
  final String CodigoPlu_ProEmb;
  final String Codigo_ProEmb;
  final String PackingQuantity;
  final dynamic Quantidade_ProcRecebDocProEmb;
  final dynamic ReferenciaXml_ProcRecebDocProEmb;
  final String AllEans;

  ConferenceProductModel({
    required this.Nome_Produto,
    required this.FormatedProduct,
    required this.CodigoInterno_Produto,
    required this.CodigoInterno_ProEmb,
    required this.CodigoPlu_ProEmb,
    required this.Codigo_ProEmb,
    required this.PackingQuantity,
    required this.Quantidade_ProcRecebDocProEmb,
    required this.ReferenciaXml_ProcRecebDocProEmb,
    required this.AllEans,
  });
}

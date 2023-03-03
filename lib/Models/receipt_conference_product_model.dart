import 'dart:convert';

class ReceiptConferenceProductModel {
  final String Nome_Produto;
  final String FormatedProduct;
  final int CodigoInterno_Produto;
  final int CodigoInterno_ProEmb;
  final String CodigoPlu_ProEmb;
  final String Codigo_ProEmb;
  final String PackingQuantity;
  final dynamic Quantidade_ProcRecebDocProEmb; //pode vir como nulo ou double
  final dynamic ReferenciaXml_ProcRecebDocProEmb;
  final String AllEans;
  String DataValidade_ProcRecebDocProEmb;

  ReceiptConferenceProductModel({
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
    required this.DataValidade_ProcRecebDocProEmb,
  });

  static resultAsStringToReceiptConferenceModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        ReceiptConferenceProductModel(
          Nome_Produto: data["Nome_Produto"],
          FormatedProduct: data["FormatedProduct"],
          CodigoInterno_Produto: data["CodigoInterno_Produto"],
          CodigoInterno_ProEmb: data["CodigoInterno_ProEmb"],
          CodigoPlu_ProEmb: data["CodigoPlu_ProEmb"],
          Codigo_ProEmb: data["Codigo_ProEmb"],
          PackingQuantity: data["PackingQuantity"],
          Quantidade_ProcRecebDocProEmb: data["Quantidade_ProcRecebDocProEmb"],
          ReferenciaXml_ProcRecebDocProEmb:
              data["ReferenciaXml_ProcRecebDocProEmb"],
          AllEans: data["AllEans"],
          DataValidade_ProcRecebDocProEmb:
              data["DataValidade_ProcRecebDocProEmb"] == null
                  ? ""
                  : data["DataValidade_ProcRecebDocProEmb"],
        ),
      );
    });
  }
}

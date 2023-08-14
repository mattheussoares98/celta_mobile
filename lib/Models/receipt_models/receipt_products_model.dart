class ReceiptProductsModel {
  final String Nome_Produto;
  final String FormatedProduct;
  final int CodigoInterno_Produto;
  final int CodigoInterno_ProEmb;
  final String CodigoPlu_ProEmb;
  final String Codigo_ProEmb;
  final String PackingQuantity;
  double Quantidade_ProcRecebDocProEmb; //pode vir como nulo ou double
  final dynamic ReferenciaXml_ProcRecebDocProEmb;
  final String AllEans;
  String DataValidade_ProcRecebDocProEmb;

  ReceiptProductsModel({
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

  static dataToReceiptConferenceModel({
    required dynamic data,
    required List listToAdd,
  }) {
    if (data == null) {
      return;
    }
    List dataList = [];
    if (data is Map) {
      dataList.add(data);
    } else {
      dataList = data;
    }

    dataList.forEach((element) {
      listToAdd.add(
        ReceiptProductsModel(
          Nome_Produto: element["Nome_Produto"],
          FormatedProduct: element["FormatedProduct"],
          CodigoInterno_Produto: int.parse(element["CodigoInterno_Produto"]),
          CodigoInterno_ProEmb: int.parse(element["CodigoInterno_ProEmb"]),
          CodigoPlu_ProEmb: element["CodigoPlu_ProEmb"],
          Codigo_ProEmb: element["Codigo_ProEmb"] ?? "",
          PackingQuantity: element["PackingQuantity"],
          Quantidade_ProcRecebDocProEmb:
              element["Quantidade_ProcRecebDocProEmb"] != null
                  ? double.tryParse(element["Quantidade_ProcRecebDocProEmb"]) ??
                      -1
                  : -1,
          ReferenciaXml_ProcRecebDocProEmb:
              element["ReferenciaXml_ProcRecebDocProEmb"],
          AllEans: element["AllEans"] ?? "",
          DataValidade_ProcRecebDocProEmb:
              element["DataValidade_ProcRecebDocProEmb"] == null
                  ? ""
                  : element["DataValidade_ProcRecebDocProEmb"],
        ),
      );
    });
  }
}

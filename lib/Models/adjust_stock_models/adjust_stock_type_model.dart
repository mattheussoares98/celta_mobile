import 'dart:convert';

class AdjustStockTypeModel {
  final int CodigoInterno_JustMov; /* : 1, */
  final String Nome_TipoEstoque; /* : "Estoque Atual", */
  final bool IsInternal; /* : true */

  AdjustStockTypeModel({
    required this.CodigoInterno_JustMov,
    required this.Nome_TipoEstoque,
    required this.IsInternal,
  });

  static dataToAdjustStockTypeModel({
    required String data,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(data);
    resultAsList.forEach((element) {
      listToAdd.add(
        AdjustStockTypeModel(
          CodigoInterno_JustMov: element["Code"],
          Nome_TipoEstoque: element["Name"],
          IsInternal: element["IsInternal"],
        ),
      );
    });
  }
}

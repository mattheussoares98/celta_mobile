import 'dart:convert';

class AdjustStockTypeModel {
  final int CodigoInterno_TipoEstoque; /* : 1, */
  final String Nome_TipoEstoque; /* : "Estoque Atual", */
  final bool FlagInterno_TipoEstoque; /* : true */

  AdjustStockTypeModel({
    required this.CodigoInterno_TipoEstoque,
    required this.Nome_TipoEstoque,
    required this.FlagInterno_TipoEstoque,
  });

  static resultAsStringToAdjustStockTypeModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    resultAsList.forEach((element) {
      listToAdd.add(
        AdjustStockTypeModel(
          CodigoInterno_TipoEstoque: element["CodigoInterno_TipoEstoque"] ?? -1,
          Nome_TipoEstoque: element["Nome_TipoEstoque"],
          FlagInterno_TipoEstoque: element["FlagInterno_TipoEstoque"],
        ),
      );
    });
  }
}

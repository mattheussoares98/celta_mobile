import 'dart:convert';

class TransferBetweenStockTypeModel {
  final int CodigoInterno_TipoEstoque; /* : 1, */
  final String Nome_TipoEstoque; /* : "Estoque Atual", */
  final bool FlagInterno_TipoEstoque; /* : true */

  TransferBetweenStockTypeModel({
    required this.CodigoInterno_TipoEstoque,
    required this.Nome_TipoEstoque,
    required this.FlagInterno_TipoEstoque,
  });

  static resultAsStringToTransferBetweenStockTypeModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    resultAsList.forEach((element) {
      listToAdd.add(
        TransferBetweenStockTypeModel(
          CodigoInterno_TipoEstoque: element["CodigoInterno_TipoEstoque"] ?? -1,
          Nome_TipoEstoque: element["Nome_TipoEstoque"],
          FlagInterno_TipoEstoque: element["FlagInterno_TipoEstoque"],
        ),
      );
    });
  }
}

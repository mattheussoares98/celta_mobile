import 'dart:convert';

class TransferBetweenStockTypeModel {
  final int CodigoInterno_JustMov; /* : 1, */
  final String Nome_TipoEstoque; /* : "Estoque Atual", */
  final bool IsInternal; /* : true */

  TransferBetweenStockTypeModel({
    required this.CodigoInterno_JustMov,
    required this.Nome_TipoEstoque,
    required this.IsInternal,
  });

  static resultAsStringToTransferBetweenStockTypeModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    resultAsList.forEach((element) {
      listToAdd.add(
        TransferBetweenStockTypeModel(
          CodigoInterno_JustMov: element["Code"],
          Nome_TipoEstoque: element["Name"],
          IsInternal: element["IsInternal"],
        ),
      );
    });
  }
}

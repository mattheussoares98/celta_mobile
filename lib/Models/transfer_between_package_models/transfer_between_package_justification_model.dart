import 'dart:convert';

import 'package:celta_inventario/Models/transfer_between_stocks_models/transfer_between_stock_type_model.dart';

class TransferBetweenPackageJustificationsModel {
  final int CodigoInterno_JustMov; /*  37, */
  final String Descricao_JustMov; /*  "SUBTRAIR", */
  final String FlagTipo_JustMov; /*  "Saída", */
  final String TypeOperator; /*  "(-)", */
  final String Nome_TipoEstoque; /*  "", */
  final TransferBetweenStockTypeModel CodigoInterno_TipoEstoque;

  TransferBetweenPackageJustificationsModel({
    required this.CodigoInterno_JustMov,
    required this.Descricao_JustMov,
    required this.FlagTipo_JustMov,
    required this.TypeOperator,
    required this.Nome_TipoEstoque,
    required this.CodigoInterno_TipoEstoque,
  });

  static resultAsStringToTransferBetweenPackageJustificationsModel({
    required String resultAsString,
    required List listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);

// Code = o["CodigoInterno_JustMov"],
// Description = o["Descricao_JustMov"],
// Type = Convert.ToInt32(o["FlagTipo_JustMov"]) == 1 ? "Entrada" : "Saída",
// TypeOperator = Convert.ToInt32(o["FlagTipo_JustMov"]) == 1 ? "(+)" : "(-)",
// StockTypeString = !Convert.IsDBNull(o["Nome_TipoEstoque"]) ? Convert.ToString(o["Nome_TipoEstoque"]) : "",
// StockType = new
// {
//     Code = o["CodigoInterno_TipoEstoque"],
//     Name = o["Nome_TipoEstoque"],
//     IsInternal = o["FlagInterno_TipoEstoque"]
// }
    resultAsList.forEach((element) {
      listToAdd.add(
        TransferBetweenPackageJustificationsModel(
          CodigoInterno_JustMov: element["CodigoInterno_JustMov"],
          Descricao_JustMov: element["Descricao_JustMov"],
          FlagTipo_JustMov:
              element["FlagTipo_JustMov"] == 1 ? "Entrada" : "Saída",
          TypeOperator: element["FlagTipo_JustMov"] == 1 ? "(+)" : "(-)",
          Nome_TipoEstoque: element["Nome_TipoEstoque"] ?? "",
          CodigoInterno_TipoEstoque: element["CodigoInterno_TipoEstoque"] ==
                  null
              ? TransferBetweenStockTypeModel(
                  CodigoInterno_TipoEstoque: -1,
                  Nome_TipoEstoque: "",
                  FlagInterno_TipoEstoque: false,
                )
              : TransferBetweenStockTypeModel(
                  CodigoInterno_TipoEstoque:
                      element["CodigoInterno_TipoEstoque"],
                  Nome_TipoEstoque: element["Nome_TipoEstoque"],
                  FlagInterno_TipoEstoque: element["FlagInterno_TipoEstoque"],
                ),
        ),
      );
    });
  }
}
import 'dart:convert';

import 'adjust_stock_type_model.dart';

class AdjustStockJustificationModel {
  final int CodigoInterno_JustMov;
  final String Descricao_JustMov;
  final String FlagTipo_JustMov;
  final String TypeOperator;
  final String Nome_TipoEstoque;
  final AdjustStockTypeModel CodigoInterno_TipoEstoque;

  AdjustStockJustificationModel({
    required this.CodigoInterno_JustMov,
    required this.Descricao_JustMov,
    required this.FlagTipo_JustMov,
    required this.TypeOperator,
    required this.Nome_TipoEstoque,
    required this.CodigoInterno_TipoEstoque,
  });

  static resultAsStringToAdjustStockJustificationModel({
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
        AdjustStockJustificationModel(
          CodigoInterno_JustMov: element["CodigoInterno_JustMov"],
          Descricao_JustMov: element["Descricao_JustMov"],
          FlagTipo_JustMov:
              element["FlagTipo_JustMov"] == 1 ? "Entrada" : "Saída",
          TypeOperator: element["FlagTipo_JustMov"] == 1 ? "(+)" : "(-)",
          Nome_TipoEstoque: element["Nome_TipoEstoque"] ?? "",
          CodigoInterno_TipoEstoque: element["CodigoInterno_TipoEstoque"] ==
                  null
              ? AdjustStockTypeModel(
                  CodigoInterno_TipoEstoque: -1,
                  Nome_TipoEstoque: "",
                  FlagInterno_TipoEstoque: false,
                )
              : AdjustStockTypeModel(
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

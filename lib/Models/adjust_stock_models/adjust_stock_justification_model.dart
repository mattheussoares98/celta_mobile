import 'dart:convert';

class AdjustStockJustificationModel {
  final int Code; /*  37, */
  final String Description; /*  "SUBTRAIR", */
  final String Type; /*  "Saída", */
  final String TypeOperator; /*  "(-)", */
  final String StockTypeString; /*  "", */
  final dynamic StockType;
  //  {
  //       {"Code": null},
  //       {"Name": null},
  //       {"IsInternal": null},
  //                  }

  AdjustStockJustificationModel({
    required this.Code,
    required this.Description,
    required this.Type,
    required this.TypeOperator,
    required this.StockTypeString,
    required this.StockType,
  });

  static resultAsStringToAdjustStockJustificationModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        AdjustStockJustificationModel(
          Code: data["Code"],
          Description: data["Description"],
          Type: data["Type"],
          TypeOperator: data["TypeOperator"],
          StockTypeString: data["StockTypeString"],
          StockType: data["StockType"],
        ),
      );
    });
  }
}

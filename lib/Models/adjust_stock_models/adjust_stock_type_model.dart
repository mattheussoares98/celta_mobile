import 'dart:convert';

class AdjustStockTypeModel {
  final int Code; /* : 1, */
  final String Name; /* : "Estoque Atual", */
  final bool IsInternal; /* : true */

  AdjustStockTypeModel({
    required this.Code,
    required this.Name,
    required this.IsInternal,
  });

  static resultAsStringToAdjustStockTypeModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        AdjustStockTypeModel(
          Code: data["Code"],
          Name: data["Name"],
          IsInternal: data["IsInternal"],
        ),
      );
    });
  }
}

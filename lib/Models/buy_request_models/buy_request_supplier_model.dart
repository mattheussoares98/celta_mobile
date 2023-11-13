import 'dart:convert';

class BuyRequestSupplierModel {
  final String CrossIdentity;
  final String SearchValue;
  final int RoutineInt;
  final int Routine;

  BuyRequestSupplierModel({
    required this.CrossIdentity,
    required this.SearchValue,
    required this.RoutineInt,
    required this.Routine,
  });

  static responseAsStringToBuyRequestSupplierModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    if (responseAsString.contains("\\")) {
      //foi corrigido para não ficar mandando "\", "\n" e sinal de " a mais nos retornos. Somente quando estiver desatualido o CMX que vai enviar dessa forma
      responseAsString = responseAsString
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceFirst(RegExp(r'"'), '');

      int lastIndex = responseAsString.lastIndexOf('"');
      responseAsString =
          responseAsString.replaceRange(lastIndex, lastIndex + 1, "");
    }

    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        BuyRequestSupplierModel(
          CrossIdentity: data["CrossIdentity"],
          SearchValue: data["SearchValue"],
          RoutineInt: data["RoutineInt"],
          Routine: data["Routine"],
        ),
      );
    });
  }
}

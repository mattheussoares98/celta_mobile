import 'dart:convert';

class InventoryProductModel {
  final String productName;
  final int codigoInternoProEmb;
  final String plu;
  final String codigoProEmb;
  double quantidadeInvContProEmb;

  InventoryProductModel({
    required this.productName,
    required this.codigoInternoProEmb,
    required this.plu,
    required this.codigoProEmb,
    required this.quantidadeInvContProEmb,
  });

  static responseInStringToInventoryProductModel({
    required String responseInString,
    required List listToAdd,
  }) {
    List responseInList = json.decode(responseInString);
    Map responseInMap = responseInList.asMap();

    responseInMap.forEach((key, value) {
      listToAdd.add(
        InventoryProductModel(
          productName: value['Nome_Produto'],
          codigoInternoProEmb: value['CodigoInterno_ProEmb'],
          plu: value['CodigoPlu_ProEmb'],
          codigoProEmb: value['Codigo_ProEmb'],
          quantidadeInvContProEmb: value['Quantidade_InvContProEmb'] == null
              ? -1
              : value['Quantidade_InvContProEmb'],
          //quando o valor está igual a "null", deixo igual a -1 e trato dessa forma pra não ocorrer erro na soma/subtração
        ),
      );
    });
  }
}

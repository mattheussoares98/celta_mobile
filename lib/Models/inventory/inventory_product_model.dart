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
    required dynamic data,
    required List listToAdd,
  }) {
    if (data == null) {
      return;
    }
    List dataList = [];
    if (data is Map) {
      dataList.add(data);
    } else {
      dataList = data;
    }

    dataList.forEach((element) {
      listToAdd.add(
        InventoryProductModel(
          productName: element['Nome_Produto'],
          codigoInternoProEmb: int.parse(element['CodigoInterno_ProEmb']),
          plu: element['CodigoPlu_ProEmb'],
          codigoProEmb: element['Codigo_ProEmb'] ?? "",
          quantidadeInvContProEmb: element['Quantidade_InvContProEmb'] == null
              ? -1
              : double.parse(element['Quantidade_InvContProEmb']),

          //quando o valor está igual a "null", deixo igual a -1 e trato dessa forma pra não ocorrer erro na soma/subtração
        ),
      );
    });
  }
}

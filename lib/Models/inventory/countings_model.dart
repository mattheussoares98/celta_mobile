class InventoryCountingsModel {
  final int codigoInternoInvCont;
  final int numeroContagemInvCont;
  final int flagTipoContagemInvCont;
  final int codigoInternoInventario;
  final String obsInvCont;

  InventoryCountingsModel({
    required this.codigoInternoInvCont,
    required this.flagTipoContagemInvCont,
    required this.codigoInternoInventario,
    required this.numeroContagemInvCont,
    required this.obsInvCont,
  });

  static responseInStringToInventoryCountingsModel({
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
        InventoryCountingsModel(
          codigoInternoInvCont: int.parse(element['CodigoInterno_InvCont']),
          flagTipoContagemInvCont:
              int.parse(element['FlagTipoContagem_InvCont']),
          codigoInternoInventario:
              int.parse(element['CodigoInterno_Inventario']),
          numeroContagemInvCont: int.parse(element['NumeroContagem_InvCont']),
          obsInvCont: element['Obs_InvCont'] == null
              ? 'Não há observações'
              : element['Obs_InvCont'],
          //as vezes a observação vem nula e se não faz isso, gera erro no app
        ),
      );
    });
  }
}

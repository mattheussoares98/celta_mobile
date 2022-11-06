import 'dart:convert';

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
    required String responseInString,
    required List listToAdd,
  }) {
    final List responseInList = json.decode(responseInString);
    final Map responseInMap = responseInList.asMap();

    responseInMap.forEach((id, data) {
      listToAdd.add(
        InventoryCountingsModel(
          codigoInternoInvCont: data['CodigoInterno_InvCont'],
          flagTipoContagemInvCont: data['FlagTipoContagem_InvCont'],
          codigoInternoInventario: data['CodigoInterno_Inventario'],
          numeroContagemInvCont: data['NumeroContagem_InvCont'],
          obsInvCont: data['Obs_InvCont'] == null
              ? 'Não há observações'
              : data['Obs_InvCont'],
          //as vezes a observação vem nula e se não faz isso, gera erro no app
        ),
      );
    });
  }
}

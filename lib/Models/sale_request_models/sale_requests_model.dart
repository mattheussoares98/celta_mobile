class SaleRequestsModel {
  final String Nome_ModeloPedido;
  final String Codigo_ModeloPedido;
  final String FlagTipoValor_ModeloPedidoString;
  final int CodigoInterno_ModeloPedido;
  final int FlagTipoOperacao_ModeloPedido;
  final int FlagTipoUsoPrecoAtacado_ModeloPedido;
  final int FlagTipoValor_ModeloPedido;
  final int FlagTipoValorTransferencia_ModeloPedido;
  /* 
No Json, a tag do valor unitário é "UnitValueType".
SalePracticedRetail = 1, "Venda praticada varejo"
SalePracticedWholeSale = 2, "Venda praticada atacado"
OperationalCost = 3, "Custo operacional"
ReplacementCost = 4, "Custo de reposição"
ReplacementCostMidle = 5, "Custo de reposição médio"
LiquidCost = 6, "Custo líquido"
LiquidCostMidle = 7, "Custo líquido médio"
DefinedBySystem = 8, "Definido pelo sistema"
RealCost = 9, "Custo de reposição real"
RealLiquidCost = 10, "Custo líquido real"
FiscalCost = 11, "Custo de reposição fiscal"
FiscalLiquidCost = 12, "Custo líquido fiscal"
SalePracticedECommerce = 13, "Venda praticada ECommerce" */

  SaleRequestsModel({
    required this.Nome_ModeloPedido,
    required this.Codigo_ModeloPedido,
    required this.CodigoInterno_ModeloPedido,
    required this.FlagTipoOperacao_ModeloPedido,
    required this.FlagTipoUsoPrecoAtacado_ModeloPedido,
    required this.FlagTipoValor_ModeloPedido,
    required this.FlagTipoValorTransferencia_ModeloPedido,
    required this.FlagTipoValor_ModeloPedidoString,
  });

  static dataToSaleRequestsModel({
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
        SaleRequestsModel(
          Nome_ModeloPedido: element["Nome_ModeloPedido"],
          Codigo_ModeloPedido: element["Codigo_ModeloPedido"],
          CodigoInterno_ModeloPedido:
              int.parse(element["CodigoInterno_ModeloPedido"]),
          FlagTipoOperacao_ModeloPedido:
              int.parse(element["FlagTipoOperacao_ModeloPedido"]),
          FlagTipoUsoPrecoAtacado_ModeloPedido:
              int.parse(element["FlagTipoUsoPrecoAtacado_ModeloPedido"]),
          FlagTipoValor_ModeloPedido:
              int.parse(element["FlagTipoValor_ModeloPedido"]),
          FlagTipoValorTransferencia_ModeloPedido:
              int.parse(element["FlagTipoValorTransferencia_ModeloPedido"]),
          FlagTipoValor_ModeloPedidoString:
              _treatFlagTipoValor_ModeloPedidoString(
                  int.parse(element["FlagTipoValor_ModeloPedido"])),
        ),
      );
    });
  }

  static String _treatFlagTipoValor_ModeloPedidoString(
      int FlagTipoValor_ModeloPedido) {
    if (FlagTipoValor_ModeloPedido == 1)
      return "Varejo";
    else if (FlagTipoValor_ModeloPedido == 2)
      return "Atacado";
    else if (FlagTipoValor_ModeloPedido == 3)
      return "Custo operacional";
    else if (FlagTipoValor_ModeloPedido == 4)
      return "Custo de reposição";
    else if (FlagTipoValor_ModeloPedido == 5)
      return "Custo de reposição médio";
    else if (FlagTipoValor_ModeloPedido == 6)
      return "Custo líquido";
    else if (FlagTipoValor_ModeloPedido == 7)
      return "Custo líquido médio";
    else if (FlagTipoValor_ModeloPedido == 8)
      return "Definido pelo sistema";
    else if (FlagTipoValor_ModeloPedido == 9)
      return "Custo de reposição real";
    else if (FlagTipoValor_ModeloPedido == 10)
      return "Custo líquido real";
    else if (FlagTipoValor_ModeloPedido == 11)
      return "Custo de reposição fiscal";
    else if (FlagTipoValor_ModeloPedido == 12)
      return "Custo líquido fiscal";
    else if (FlagTipoValor_ModeloPedido == 13)
      return "ECommerce";
    else {
      return "Preço não identificado. Avise o suporte";
    }
  }
}

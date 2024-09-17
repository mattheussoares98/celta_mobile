class EnterpriseModel {
  final int codigoInternoEmpresa;
  final String codigoEmpresa;
  final String nomeEmpresa;
  final String cnpj;
  final String CodigoInternoVendaMobile_ModeloPedido;
  final bool useRetailSale;
  final bool useWholeSale;
  final bool useEcommerceSale;
  final bool participateEnterpriseGroup;

  EnterpriseModel({
    required this.codigoInternoEmpresa,
    required this.codigoEmpresa,
    required this.nomeEmpresa,
    required this.cnpj,
    required this.CodigoInternoVendaMobile_ModeloPedido,
    required this.useEcommerceSale,
    required this.useRetailSale,
    required this.useWholeSale,
    required this.participateEnterpriseGroup,
  });

  static resultAsStringToEnterpriseModel({
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
        EnterpriseModel(
          codigoInternoEmpresa: int.parse(element['CodigoInterno_Empresa']),
          codigoEmpresa: element['Codigo_Empresa'],
          nomeEmpresa: element['Nome_Empresa'],
          cnpj: element['Cnpj_Empresa'],
          CodigoInternoVendaMobile_ModeloPedido:
              element["CodigoInternoVendaMobile_ModeloPedido"] ?? "-1",
          useEcommerceSale: element["FlagECommerce_Empresa"] == "1",
          useRetailSale: element["FlagVarejo_Empresa"] == "1",
          useWholeSale: element["FlagAtacado_Empresa"] == "1",
          participateEnterpriseGroup: element["FlagAtacado_Empresa"] == "1",
        ),
      );
    });
  }
}

import 'dart:convert';

class SaleRequestsModel {
  final int Code;
  final String PersonalizedCode;
  final String Name;
  final String OperationTypeString;
  final String UseWholePriceString;
  final int OperationType;
  final int UseWholePrice;
  final int UnitValueType;
  final String UnitValueTypeString;
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
    required this.Code,
    required this.PersonalizedCode,
    required this.Name,
    required this.OperationType,
    required this.UseWholePrice,
    required this.UnitValueType,
    required this.OperationTypeString,
    required this.UseWholePriceString,
    required this.UnitValueTypeString,
  });

  static responseAsStringToSaleRequestsModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        SaleRequestsModel(
          UseWholePriceString: data["UseWholePriceString"],
          UnitValueTypeString: data["UnitValueTypeString"],
          OperationTypeString: data["OperationTypeString"],
          Code: data["Code"],
          PersonalizedCode: data["PersonalizedCode"],
          Name: data["Name"],
          OperationType: data["OperationType"],
          UseWholePrice: data["UseWholePrice"],
          UnitValueType: data["UnitValueType"],
        ),
      );
    });
  }
}

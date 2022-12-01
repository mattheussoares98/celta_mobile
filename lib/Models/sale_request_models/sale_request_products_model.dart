import 'dart:convert';

class SaleRequestProductsModel {
  final int ProductCode;
  final int ProductPackingCode;
  final String PLU;
  final String Name;
  final String PackingQuantity;
  final double RetailPracticedPrice;
  final double RetailSalePrice;
  final double RetailOfferPrice;
  final double WholePracticedPrice;
  final double WholeSalePrice;
  final double WholeOfferPrice;
  final double ECommercePracticedPrice;
  final double ECommerceSalePrice;
  final double ECommerceOfferPrice;
  final double MinimumWholeQuantity;
  final double BalanceStockSale;

  SaleRequestProductsModel({
    required this.ProductCode,
    required this.ProductPackingCode,
    required this.PLU,
    required this.Name,
    required this.PackingQuantity,
    required this.RetailPracticedPrice,
    required this.RetailSalePrice,
    required this.RetailOfferPrice,
    required this.WholePracticedPrice,
    required this.WholeSalePrice,
    required this.WholeOfferPrice,
    required this.ECommercePracticedPrice,
    required this.ECommerceSalePrice,
    required this.ECommerceOfferPrice,
    required this.MinimumWholeQuantity,
    required this.BalanceStockSale,
  });

  static responseAsStringToSaleRequestProductsModel({
    required String responseAsString,
    required List listToAdd,
  }) {
    responseAsString = responseAsString
        .replaceAll(RegExp(r'\\'), '')
        .replaceAll(RegExp(r'\n'), '')
        .replaceFirst(RegExp(r'"'), '');

    int lastIndex = responseAsString.lastIndexOf('"');
    responseAsString =
        responseAsString.replaceRange(lastIndex, lastIndex + 1, "");
    //precisei fazer esse tratamento acima porque o estava retornando "\", "\n"
    //e sinal de " a mais, causando erro no decode

    List responseAsList = json.decode(responseAsString.toString());
    Map responseAsMap = responseAsList.asMap();

    responseAsMap.forEach((id, data) {
      listToAdd.add(
        SaleRequestProductsModel(
          ProductCode: data["ProductCode"],
          ProductPackingCode: data["ProductPackingCode"],
          PLU: data["PLU"],
          Name: data["Name"],
          PackingQuantity: data["PackingQuantity"],
          RetailPracticedPrice: data["RetailPracticedPrice"],
          RetailSalePrice: data["RetailSalePrice"],
          RetailOfferPrice: data["RetailOfferPrice"],
          WholePracticedPrice: data["WholePracticedPrice"],
          WholeSalePrice: data["WholeSalePrice"],
          WholeOfferPrice: data["WholeOfferPrice"],
          ECommercePracticedPrice: data["ECommercePracticedPrice"],
          ECommerceSalePrice: data["ECommerceSalePrice"],
          ECommerceOfferPrice: data["ECommerceOfferPrice"],
          MinimumWholeQuantity: data["MinimumWholeQuantity"],
          BalanceStockSale: data["BalanceStockSale"],
        ),
      );
    });
  }
}

import 'dart:convert';

import '../../api/api.dart';

class ResearchPricesProductsModel {
  final int ResearchOfPriceCode; /* 1014 */
  final int ConcurrentCode; /* 1006 */
  final int ProductPackingCode; /* 82 */
  final String PriceLookUp; /* "0 0017-8" */
  final String ProductName; /* "Teste Estoque (UN 0.500)" */
  double PriceRetail; /* 0.00 */
  double OfferRetail; /* 0.00 */
  double PriceWhole; /* 0.00 */
  double OfferWhole; /* 0.00 */
  double PriceECommerce; /* 0.00 */
  double OfferECommerce; /* 0.0 */

  ResearchPricesProductsModel({
    required this.ResearchOfPriceCode,
    required this.ConcurrentCode,
    required this.ProductPackingCode,
    required this.PriceLookUp,
    required this.ProductName,
    required this.PriceRetail,
    required this.OfferRetail,
    required this.PriceWhole,
    required this.OfferWhole,
    required this.PriceECommerce,
    required this.OfferECommerce,
  });

  static List<ResearchPricesProductsModel> resultAsStringToProductsModel() {
    List responseAsList = json.decode(
      SoapRequestResponse.responseAsString,
    );

    return responseAsList
        .map((json) => ResearchPricesProductsModel.fromJson(json))
        .toList();
  }

  factory ResearchPricesProductsModel.fromJson(Map json) =>
      ResearchPricesProductsModel(
        ResearchOfPriceCode: json["ResearchOfPriceCode"],
        ConcurrentCode: json["ConcurrentCode"],
        ProductPackingCode: json["ProductPackingCode"],
        PriceLookUp: json["PriceLookUp"],
        ProductName: json["ProductName"],
        PriceRetail: json["PriceRetail"],
        OfferRetail: json["OfferRetail"],
        PriceWhole: json["PriceWhole"],
        OfferWhole: json["OfferWhole"],
        PriceECommerce: json["PriceECommerce"],
        OfferECommerce: json["OfferECommerce"],
      );

  Map toJson() => {
        "ResearchOfPriceCode": ResearchOfPriceCode,
        "ConcurrentCode": ConcurrentCode,
        "ProductPackingCode": ProductPackingCode,
        "PriceLookUp": PriceLookUp,
        "ProductName": ProductName,
        "PriceRetail": PriceRetail,
        "OfferRetail": OfferRetail,
        "PriceWhole": PriceWhole,
        "OfferWhole": OfferWhole,
        "PriceECommerce": PriceECommerce,
        "OfferECommerce": OfferECommerce,
      };
}

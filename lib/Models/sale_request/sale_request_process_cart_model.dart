import 'dart:convert';

import '../../models/models.dart';

class SaleRequestProcessCartModel {
  int? ProductPackingCode;
  double? Quantity;
  double? Value;
  double? TotalLiquid;
  String? IncrementPercentageOrValue; //"R$"" ou "%"
  double? IncrementValue;
  String? DiscountPercentageOrValue; //"R$"" ou "%"
  double? DiscountValue;
  String? DiscountDescription;
  String? AutomaticDiscountPercentageOrValue; //"R$"" ou "%"
  double? AutomaticDiscountValue;
  String? ExpectedDeliveryDate;
  String? Observations;

  SaleRequestProcessCartModel({
    required this.ProductPackingCode,
    required this.AutomaticDiscountPercentageOrValue,
    required this.AutomaticDiscountValue,
    required this.TotalLiquid,
    required this.Quantity,
    required this.Value,
    required this.IncrementPercentageOrValue,
    required this.IncrementValue,
    required this.DiscountPercentageOrValue,
    required this.DiscountValue,
    required this.DiscountDescription,
    required this.ExpectedDeliveryDate,
    required this.Observations,
  });

  static List<Map<String, dynamic>> cartProductsToProcessCart(
    List<GetProductJsonModel> cartProducts,
  ) {
    List<Map<String, dynamic>> processCartProducts = [];

    cartProducts.forEach((element) {
      processCartProducts.add({
        "ProductPackingCode": element.productPackingCode,
        "Quantity": element.quantity,
        "value": element.value,
        // "IncrementPercentageOrValue": element.IncrementPercentageOrValue,
        "IncrementValue": element.IncrementValue,
        // "DiscountPercentageOrValue": element.DiscountPercentageOrValue,
        "DiscountValue": element.DiscountValue,
      });
    });

    return processCartProducts;
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductPackingCode': ProductPackingCode,
      'Quantity': Quantity,
      'value': Value,
      // 'IncrementPercentageOrValue': IncrementPercentageOrValue,
      'IncrementValue': IncrementValue,
      // // 'DiscountPercentageOrValue': DiscountPercentageOrValue,
      'DiscountValue': DiscountValue,
      // "AutomaticDiscountPercentageOrValue": AutomaticDiscountPercentageOrValue,
      "AutomaticDiscountValue": AutomaticDiscountValue,
      "TotalLiquid": TotalLiquid,
      // 'ExpectedDeliveryDate': ExpectedDeliveryDate,
    };
  }

  factory SaleRequestProcessCartModel.fromJson(Map<String, dynamic> json) {
    return SaleRequestProcessCartModel(
      ProductPackingCode: json['ProductPackingCode'],
      Quantity: json['Quantity'],
      Value: json['Value'],
      IncrementValue: json['IncrementValue'],
      DiscountValue: json['DiscountValue'],
      DiscountDescription: json["DiscountDescription"] ?? "",
      AutomaticDiscountValue: json["AutomaticDiscountValue"] ?? 0,
      TotalLiquid: json["TotalLiquid"],
      ExpectedDeliveryDate: json['ExpectedDeliveryDate'],
      Observations: json["Observations"],
      IncrementPercentageOrValue: json["IncrementPercentageOrValue"],
      DiscountPercentageOrValue: json["DiscountPercentageOrValue"],
      AutomaticDiscountPercentageOrValue:
          json["AutomaticDiscountPercentageOrValue"],
    );
  }

  static void updateCartWithProcessCartResponse({
    required Map<String, dynamic> jsonSaleRequest,
    required String apiItemsResponse,
    required String enterpriseCode,
    required List<GetProductJsonModel> cartProducts,
  }) {
    Map<String, dynamic> jsonData = json.decode(apiItemsResponse);

    jsonSaleRequest["Products"].clear();
    jsonSaleRequest["EnterpriseCode"] = jsonData["EnterpriseCode"];
    jsonSaleRequest["RequestTypeCode"] = jsonData["RequestTypeCode"];
    jsonSaleRequest["SellerCode"] = jsonData["SellerCode"];
    jsonSaleRequest["CustomerCode"] = jsonData["CustomerCode"];
    jsonSaleRequest["CovenantCode"] = jsonData["CovenantCode"];

    jsonData["Products"].forEach((x) {
      jsonSaleRequest["Products"].add(
        SaleRequestProcessCartModel.fromJson(x),
      );

      cartProducts.forEach((element) {
        if (x["ProductPackingCode"] == element.productPackingCode) {
          element.productPackingCode = x["ProductPackingCode"];
          element.quantity = x["Quantity"];
          element.value = x["Value"];
          element.IncrementPercentageOrValue =
              x["IncrementPercentageOrValue"] ?? "";
          element.IncrementValue = x["IncrementValue"];
          element.DiscountPercentageOrValue =
              x["DiscountPercentageOrValue"].toString();
          element.DiscountValue = x["DiscountValue"];
          // element.ExpectedDeliveryDate = x["ExpectedDeliveryDate"];
          element.AutomaticDiscountPercentageOrValue =
              x["AutomaticDiscountPercentageOrValue"] ?? "";
          element.AutomaticDiscountValue = x["AutomaticDiscountValue"];
          element.TotalLiquid = x["TotalLiquid"];
          element.AutomaticDiscountPercentageOrValue =
              x["AutomaticDiscountPercentageOrValue"] ?? "";
          element.AutomaticDiscountValue = x["AutomaticDiscountValue"];
          element.TotalLiquid = x["TotalLiquid"];
        }
      });
    });
  }
}

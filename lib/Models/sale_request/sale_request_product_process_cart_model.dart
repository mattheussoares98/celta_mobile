import 'dart:convert';

import '../../models/models.dart';

class SaleRequestProductProcessCartModel {
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

  SaleRequestProductProcessCartModel({
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
    return cartProducts
        .map((e) => {
              "ProductPackingCode": e.plu,
              "Quantity": e.quantity,
              "Value": e.value,
              "TotalLiquid": e.TotalLiquid,
              "IncrementPercentageOrValue": e.IncrementPercentageOrValue,
              "IncrementValue": e.IncrementValue,
              "DiscountPercentageOrValue": e.DiscountPercentageOrValue,
              "DiscountValue": e.DiscountValue,
              "AutomaticDiscountPercentageOrValue":
                  e.AutomaticDiscountPercentageOrValue,
              "AutomaticDiscountValue": e.AutomaticDiscountValue,
            })
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "ProductPackingCode": ProductPackingCode,
      "AutomaticDiscountPercentageOrValue": AutomaticDiscountPercentageOrValue,
      "AutomaticDiscountValue": AutomaticDiscountValue,
      "TotalLiquid": TotalLiquid,
      "Quantity": Quantity,
      "Value": Value,
      "IncrementPercentageOrValue": IncrementPercentageOrValue,
      "IncrementValue": IncrementValue,
      "DiscountPercentageOrValue": DiscountPercentageOrValue,
      "DiscountValue": DiscountValue,
      "DiscountDescription": DiscountDescription,
      "ExpectedDeliveryDate": ExpectedDeliveryDate,
      "Observations": Observations,
    };
  }

  factory SaleRequestProductProcessCartModel.fromJson(
      Map<String, dynamic> json) {
    return SaleRequestProductProcessCartModel(
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
        SaleRequestProductProcessCartModel.fromJson(x),
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

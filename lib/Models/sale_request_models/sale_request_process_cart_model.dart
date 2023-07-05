import 'dart:convert';

import 'package:celta_inventario/Models/sale_request_models/sale_request_cart_products_model.dart';

class SaleRequestProcessCartModel {
  int ProductPackingCode;
  double Quantity;
  double Value;
  double IncrementPercentageOrValue;
  double IncrementValue;
  double DiscountPercentageOrValue;
  double DiscountValue;
  String DiscountDescription;
  // String ExpectedDeliveryDate;

  SaleRequestProcessCartModel({
    required this.ProductPackingCode,
    required this.Quantity,
    required this.Value,
    required this.IncrementPercentageOrValue,
    required this.IncrementValue,
    required this.DiscountPercentageOrValue,
    required this.DiscountValue,
    required this.DiscountDescription,
    // required this.ExpectedDeliveryDate,
  });

  static List<Map<String, dynamic>> cartProductsToProcessCart(
    List<SaleRequestCartProductsModel> cartProducts,
  ) {
    List<Map<String, dynamic>> processCartProducts = [];

    cartProducts.forEach((element) {
      processCartProducts.add({
        "ProductPackingCode": element.ProductPackingCode,
        "Quantity": element.Quantity,
        "value": element.Value,
        "IncrementPercentageOrValue":
            double.tryParse(element.IncrementPercentageOrValue) ?? 0,
        "IncrementValue": element.IncrementValue,
        "DiscountPercentageOrValue":
            double.tryParse(element.DiscountPercentageOrValue) ?? 0,
        "DiscountValue": element.DiscountValue,
        // "ExpectedDeliveryDate": DateTime.now().toString(),
      });
    });

    return processCartProducts;
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductPackingCode': ProductPackingCode,
      'Quantity': Quantity,
      'value': Value,
      'IncrementPercentageOrValue': IncrementPercentageOrValue,
      'IncrementValue': IncrementValue,
      'DiscountPercentageOrValue': DiscountPercentageOrValue,
      'DiscountValue': DiscountValue,
      // 'ExpectedDeliveryDate': ExpectedDeliveryDate,
    };
  }

  factory SaleRequestProcessCartModel.fromJson(Map<String, dynamic> json) {
    return SaleRequestProcessCartModel(
      ProductPackingCode: json['ProductPackingCode'],
      Quantity: json['Quantity'],
      Value: json['Value'],
      IncrementPercentageOrValue:
          double.tryParse(json['IncrementPercentageOrValue'] ?? "0") ?? 0,
      IncrementValue: json['IncrementValue'],
      DiscountPercentageOrValue:
          double.tryParse(json['DiscountPercentageOrValue'] ?? "0") ?? 0,
      DiscountValue: json['DiscountValue'],
      DiscountDescription: json["DiscountDescription"] ?? "",
      // ExpectedDeliveryDate: json['ExpectedDeliveryDate'],
    );
  }

  static updateCartWithProcessCartResponse({
    required Map<String, dynamic> jsonSaleRequest,
    required String apiItemsResponse,
    required String enterpriseCode,
    required List<SaleRequestCartProductsModel> cartProducts,
  }) {
    Map<String, dynamic> jsonData = json.decode(apiItemsResponse);

    jsonSaleRequest["Products"].clear();
    jsonSaleRequest["EnterpriseCode"] = jsonData["EnterpriseCode"];
    jsonSaleRequest["RequestTypeCode"] = jsonData["RequestTypeCode"];
    jsonSaleRequest["SellerCode"] = jsonData["SellerCode"];
    jsonSaleRequest["CustomerCode"] = jsonData["CustomerCode"];

    jsonData["Products"].forEach((x) {
      jsonSaleRequest["Products"].add(
        SaleRequestProcessCartModel.fromJson(x),
      );

      cartProducts.forEach((element) {
        if (x["ProductPackingCode"] == element.ProductPackingCode) {
          element.ProductPackingCode = x["ProductPackingCode"];
          element.Quantity = x["Quantity"];
          element.Value = x["Value"];
          element.IncrementPercentageOrValue = x["IncrementPercentageOrValue"];
          element.IncrementValue = x["IncrementValue"];
          element.DiscountPercentageOrValue =
              x["DiscountPercentageOrValue"].toString();
          element.DiscountValue = x["DiscountValue"];
          element.ExpectedDeliveryDate = x["ExpectedDeliveryDate"];
        }
      });
    });
  }
}

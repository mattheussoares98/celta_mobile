import 'dart:convert';

import 'package:celta_inventario/Models/sale_request_models/sale_request_cart_products_model.dart';

class SaleRequestProcessCartModel {
  int ProductPackingCode;
  double Quantity;
  double Value;
  String IncrementPercentageOrValue; //"R$"" ou "%"
  String DiscountPercentageOrValue; //"R$"" ou "%"
  double IncrementValue;
  String AutomaticDiscountPercentageOrValue; //"R$"" ou "%"
  double AutomaticDiscountValue;
  double TotalLiquid;
  double DiscountValue;
  String DiscountDescription;
  // String ExpectedDeliveryDate;

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

      IncrementPercentageOrValue:
          '', //na api retorna "R$" de padrão e esse caracter especial está dando problema depois pra calcular o preço dos produtos de novo. Como não está usando essa questão, por enquanto vou deixar dessa forma
      DiscountPercentageOrValue:
          '', //na api retorna "R$" de padrão e esse caracter especial está dando problema depois pra calcular o preço dos produtos de novo. Como não está usando essa questão, por enquanto vou deixar dessa forma
      AutomaticDiscountPercentageOrValue:
          '', //na api retorna "R$" de padrão e esse caracter especial está dando problema depois pra calcular o preço dos produtos de novo. Como não está usando essa questão, por enquanto vou deixar dessa forma
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
    jsonSaleRequest["CovenantCode"] = jsonData["CovenantCode"];

    jsonData["Products"].forEach((x) {
      jsonSaleRequest["Products"].add(
        SaleRequestProcessCartModel.fromJson(x),
      );

      cartProducts.forEach((element) {
        if (x["ProductPackingCode"] == element.ProductPackingCode) {
          element.ProductPackingCode = x["ProductPackingCode"];
          element.Quantity = x["Quantity"];
          element.Value = x["Value"];
          element.IncrementPercentageOrValue =
              x["IncrementPercentageOrValue"] ?? "";
          element.IncrementValue = x["IncrementValue"];
          element.DiscountPercentageOrValue =
              x["DiscountPercentageOrValue"].toString();
          element.DiscountValue = x["DiscountValue"];
          element.ExpectedDeliveryDate = x["ExpectedDeliveryDate"];
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

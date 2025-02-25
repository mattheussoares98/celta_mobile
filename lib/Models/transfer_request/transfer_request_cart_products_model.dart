import '../models.dart';

class TransferRequestCartProductsModel {
  //TODO remove this
  int ProductPackingCode;
  String Name;
  double Quantity;
  double Value;
  String IncrementPercentageOrValue;
  double IncrementValue;
  String DiscountPercentageOrValue;
  double DiscountValue;
  String ExpectedDeliveryDate;
  int ProductCode;
  String PLU;
  String PackingQuantity;
  double RetailPracticedPrice;
  double RetailSalePrice;
  double RetailOfferPrice;
  double WholePracticedPrice;
  double WholeSalePrice;
  double WholeOfferPrice;
  double ECommercePracticedPrice;
  double ECommerceSalePrice;
  double ECommerceOfferPrice;
  double MinimumWholeQuantity;
  double? BalanceStockSale;
  String StorageAreaAddress;
  List<dynamic> StockByEnterpriseAssociateds;

  TransferRequestCartProductsModel({
    required this.ProductPackingCode,
    required this.Name,
    required this.Quantity,
    required this.Value,
    required this.IncrementPercentageOrValue,
    required this.IncrementValue,
    required this.DiscountPercentageOrValue,
    required this.DiscountValue,
    required this.ExpectedDeliveryDate,
    required this.ProductCode,
    required this.PLU,
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
    required this.StorageAreaAddress,
    required this.StockByEnterpriseAssociateds,
  });

  TransferRequestCartProductsModel.fromJson(Map json)
      : ProductPackingCode = json["ProductPackingCode"],
        Name = json["Name"],
        Quantity = json["Quantity"],
        Value = json["Value"],
        IncrementPercentageOrValue = json["IncrementPercentageOrValue"],
        IncrementValue = json["IncrementValue"],
        DiscountPercentageOrValue = json["DiscountPercentageOrValue"],
        DiscountValue = json["DiscountValue"],
        ExpectedDeliveryDate = json["ExpectedDeliveryDate"],
        ProductCode = json["ProductCode"],
        PLU = json["PLU"],
        PackingQuantity = json["PackingQuantity"],
        RetailPracticedPrice = json["RetailPracticedPrice"],
        RetailSalePrice = json["RetailSalePrice"],
        RetailOfferPrice = json["RetailOfferPrice"],
        WholePracticedPrice = json["WholePracticedPrice"],
        WholeSalePrice = json["WholeSalePrice"],
        WholeOfferPrice = json["WholeOfferPrice"],
        ECommercePracticedPrice = json["ECommercePracticedPrice"],
        ECommerceSalePrice = json["ECommerceSalePrice"],
        ECommerceOfferPrice = json["ECommerceOfferPrice"],
        MinimumWholeQuantity = json["MinimumWholeQuantity"],
        BalanceStockSale = json["BalanceStockSale"],
        StorageAreaAddress = json["StorageAreaAddress"],
        StockByEnterpriseAssociateds = json["StockByEnterpriseAssociateds"];

  Map<String, dynamic> toJson() => {
        "ProductPackingCode": ProductPackingCode,
        "Name": Name,
        "Quantity": Quantity,
        "Value": Value,
        "IncrementPercentageOrValue": IncrementPercentageOrValue,
        "IncrementValue": IncrementValue,
        "DiscountPercentageOrValue": DiscountPercentageOrValue,
        "DiscountValue": DiscountValue,
        "ExpectedDeliveryDate": ExpectedDeliveryDate,
        "ProductCode": ProductCode,
        "PLU": PLU,
        "PackingQuantity": PackingQuantity,
        "RetailPracticedPrice": RetailPracticedPrice,
        "RetailSalePrice": RetailSalePrice,
        "RetailOfferPrice": RetailOfferPrice,
        "WholePracticedPrice": WholePracticedPrice,
        "WholeSalePrice": WholeSalePrice,
        "WholeOfferPrice": WholeOfferPrice,
        "ECommercePracticedPrice": ECommercePracticedPrice,
        "ECommerceSalePrice": ECommerceSalePrice,
        "ECommerceOfferPrice": ECommerceOfferPrice,
        "MinimumWholeQuantity": MinimumWholeQuantity,
        "BalanceStockSale": BalanceStockSale,
        "StorageAreaAddress": StorageAreaAddress,
        "StockByEnterpriseAssociateds": StockByEnterpriseAssociateds,
      };
  static updateJsonSaleRequest({
    required List<GetProductJsonModel> products,
    required Map jsonSaleRequest,
    required int enterpriseOriginCode,
    required int enterpriseDestinyCode,
    required int requestTypeCode,
  }) {
    //TODO create a function to update the jsonSaleRequest
    jsonSaleRequest["EnterpriseOriginCode"] = enterpriseOriginCode;
    jsonSaleRequest["EnterpriseDestinyCode"] = enterpriseDestinyCode;
    jsonSaleRequest["RequestTypeCode"] = requestTypeCode;

    List<Map> productsWithUnnecessaryKeys = [];
    products.forEach((element) {
      productsWithUnnecessaryKeys.add({
        "ProductPackingCode": element.productPackingCode,
        "Quantity": element.quantity,
        "Value": element.value,
        // "IncrementPercentageOrValue": element.IncrementPercentageOrValue,
        // "DiscountPercentageOrValue": element.DiscountPercentageOrValue,
        // "DiscountValue": element.DiscountValue,
      });
    });

    jsonSaleRequest["Products"] = productsWithUnnecessaryKeys;
  }
}

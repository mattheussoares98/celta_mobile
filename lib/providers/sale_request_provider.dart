import 'dart:convert';

import 'package:celta_inventario/Models/sale_request_models/sale_request_costumer_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_products_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_request_type_model.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/base_url.dart';
import '../utils/default_error_message_to_find_server.dart';

class SaleRequestProvider with ChangeNotifier {
  bool _isLoadingRequestType = false;
  bool get isLoadingRequestType => _isLoadingRequestType;
  String _errorMessageRequestType = "";
  String get errorMessageRequestType => _errorMessageRequestType;
  List<SaleRequestRequestTypeModel> _requests = [];
  get requests => [..._requests];

  bool _isLoadingCostumer = false;
  bool get isLoadingCostumer => _isLoadingCostumer;
  String _errorMessageCostumer = "";
  String get errorMessageCostumer => _errorMessageCostumer;
  List<SaleRequestCostumerModel> _costumers = [];
  get costumers => [..._costumers];

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageProducts = "";
  String get errorMessageProducts => _errorMessageProducts;
  List<SaleRequestProductsModel> _products = [];
  get products => [..._products];
  get productsCount => _products.length;

  List<Map<String, dynamic>> _cartProducts = [];
  get cartProducts => [..._cartProducts];

  double get totalCartPrice {
    double total = 0;

    _cartProducts.forEach((element) {
      element.forEach((key, value) {
        if (key == "Quantity") {
          print("quantity");
        }
        if (key == "Value") {
          total += value;
        }
      });
    });

    return total;
  }

  Map<String, dynamic> jsonSaleRequest = {
    "crossId": UserIdentity.identity,
    "EnterpriseCode": 0,
    "RequestTypeCode": 0,
    "SellerCode": 0,
    "CustomerCode": 0,
    "Products": [],
  };

  FocusNode searchProductFocusNode = FocusNode();
  FocusNode consultedProductFocusNode = FocusNode();

  changeFocusToConsultedProduct(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(consultedProductFocusNode);
    });
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }

  alreadyContainsProduct(int ProductPackingCode) {
    bool alreadyContainsProduct = false;
    print(ProductPackingCode);

    _cartProducts.forEach((element) {
      if (element.containsValue(ProductPackingCode)) {
        alreadyContainsProduct = true;
      }
    });

    return alreadyContainsProduct;
  }

  dynamic addProductInCart({
    required int ProductPackingCode,
    required double Quantity,
    required double Value,
    required BuildContext context,
    required bool alreadyContaintProduct,
  }) async {
    var value = {
      "ProductPackingCode": ProductPackingCode,
      "Quantity": Quantity,
      "Value": Value,
      "IncrementPercentageOrValue": "0.0",
      "IncrementValue": 0.0,
      "DiscountPercentageOrValue": "0.0",
      "DiscountValue": 0.0,
      "ExpectedDeliveryDate": DateTime.now(),
    };

    if (alreadyContaintProduct) {
      int index = _cartProducts.indexWhere(
          (element) => element["ProductPackingCode"] == ProductPackingCode);
      _cartProducts[index] = value;
    } else {
      _cartProducts.add(value);
    }
    jsonSaleRequest["Products"] = _cartProducts;
    notifyListeners();
  }

  Future<void> getRequestType({
    required int enterpriseCode,
    required BuildContext context,
  }) async {
    _isLoadingRequestType = true;
    _errorMessageRequestType = "";
    _requests.clear();
    // notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'GET',
          Uri.parse(
              '${BaseUrl.url}/SaleRequest/RequestType?enterpriseCode=$enterpriseCode&searchValue=%'));

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para consulta do RequestType = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageRequestType = json.decode(responseInString)["Message"];
        _isLoadingRequestType = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageRequestType,
          context: context,
        );
        notifyListeners();
        return;
      }

      SaleRequestRequestTypeModel.responseAsStringToSaleRequestRequestTypeModel(
        responseAsString: responseInString,
        listToAdd: _requests,
      );
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorMessageRequestType = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageRequestType,
        context: context,
      );
    }

    _isLoadingRequestType = false;
    notifyListeners();
  }

  Future<void> getCostumers({
    required BuildContext context,
    required String searchValueControllerText,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
    int? codeValue = int.tryParse(searchValueControllerText);
    if (codeValue == null) {
      await _getCostumers(
        context: context,
        searchTypeInt: 3, //ApproximateName
        searchValueControllerText: searchValueControllerText,
      );
    } else {
      await _getCostumers(
        context: context,
        searchTypeInt: 2, //exactCode
        searchValueControllerText: searchValueControllerText,
      );

      if (_costumers.isNotEmpty) return;

      await _getCostumers(
        context: context,
        searchTypeInt: 1, //exactCnpjCpfNumber
        searchValueControllerText: searchValueControllerText,
      );
    }
  }

  Future<void> _getCostumers({
    required BuildContext context,
    required int searchTypeInt,
    required String searchValueControllerText,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName

    _costumers.clear();
    _errorMessageCostumer = "";
    _isLoadingCostumer = false;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '${BaseUrl.url}/Customer/Customer?searchTypeInt=$searchTypeInt&searchValue=$searchValueControllerText',
        ),
      );

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para consulta do Costumers = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageRequestType = json.decode(responseInString)["Message"];
        _isLoadingRequestType = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageRequestType,
          context: context,
        );
        notifyListeners();
        return;
      }

      SaleRequestCostumerModel.responseAsStringToSaleRequestCostumerModel(
        responseAsString: responseInString,
        listToAdd: _costumers,
      );
    } catch (e) {
      print("Erro para obter os clientes: $e");
      _errorMessageCostumer = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageCostumer,
        context: context,
      );
    }

    _isLoadingRequestType = false;
    notifyListeners();
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String searchValueControllerText,
    required int searchTypeInt,
    required BuildContext context,
  }) async {
// 2=ExactPriceLookUp
// 4=ExactEan
// 6=ApproximateName
// 11=ApproximateLegacyCode

    _products.clear();
    _errorMessageProducts = "";
    _isLoadingProducts = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '${BaseUrl.url}/SaleRequest/Product?enterpriseCode=$enterpriseCode&searchTypeInt=$searchTypeInt&searchValue=$searchValueControllerText',
        ),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para consulta dos produtos = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageRequestType = json.decode(responseInString)["Message"];
        _isLoadingRequestType = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageRequestType,
          context: context,
        );
        notifyListeners();
        return;
      }

      SaleRequestProductsModel.responseAsStringToSaleRequestProductsModel(
        responseAsString: responseInString,
        listToAdd: _products,
      );
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorMessageProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageProducts,
        context: context,
      );
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> getProducts({
    required BuildContext context,
    required int enterpriseCode,
    required String searchValueControllerText,
  }) async {
// 2=ExactPriceLookUp
// 4=ExactEan
// 6=ApproximateName
// 11=ApproximateLegacyCode

    int? searchTypeInt = int.tryParse(searchValueControllerText);

    if (searchTypeInt == null) {
      //como não conseguiu converter para inteiro, significa que precisa consultar por nome
      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 6, //approximateName
        context: context,
      );
    } else {
      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 4, //ExactEan
        context: context,
      );

      if (_products.isNotEmpty) return;

      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 2, //ExactPriceLookup == PLU
        context: context,
      );
    }
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:celta_inventario/Models/transfer_request/transfer_request_cart_products_model.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_request_products_model.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_destiny_enterprise_model.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_origin_enterprise_model.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_request_model.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/Global_widgets/show_error_message.dart';
import '../utils/base_url.dart';
import '../utils/default_error_message_to_find_server.dart';

class TransferRequestProvider with ChangeNotifier {
  String _errorMessageRequestModel = '';
  String get errorMessageRequestModel => _errorMessageRequestModel;
  bool _isLoadingRequestModel = false;
  bool get isLoadingRequestModel => _isLoadingRequestModel;
  List<TransferRequestModel> _requestModels = [];
  get requestModels => [..._requestModels];
  get requestModelsCount => _requestModels.length;

  void clearRequestModels() {
    _requestModels.clear();
    notifyListeners();
  }

  String _lastSavedTransferRequest = '';
  String get lastSavedTransferRequest => _lastSavedTransferRequest;
  String _errorMessageSaveTransferRequest = '';
  String get errorMessageSaveTransferRequest =>
      _errorMessageSaveTransferRequest;
  bool _isLoadingSaveTransferRequest = false;
  bool get isLoadingSaveTransferRequest => _isLoadingSaveTransferRequest;

  String _errorMessageDestinyEnterprise = '';
  String get errorMessageDestinyEnterprise => _errorMessageDestinyEnterprise;
  bool _isLoadingDestinyEnterprise = false;
  bool get isLoadingDestinyEnterprise => _isLoadingDestinyEnterprise;
  List<TransferDestinyEnterpriseModel> _destinyEnterprises = [];
  get destinyEnterprises => [..._destinyEnterprises];
  get destinyEnterprisesCount => _destinyEnterprises.length;

  void clearDestinyEnterprise() {
    _destinyEnterprises.clear();
    notifyListeners();
  }

  String _errorMessageOriginEnterprise = '';
  String get errorMessageOriginEnterprise => _errorMessageOriginEnterprise;
  bool _isLoadingOriginEnterprise = false;
  bool get isLoadingOriginEnterprise => _isLoadingOriginEnterprise;
  List<TransferOriginEnterpriseModel> _originEnterprises = [];
  get originEnterprises => [..._originEnterprises];
  get originEnterprisesCount => _originEnterprises.length;

  void clearOriginEnterprise() {
    _originEnterprises.clear();
    notifyListeners();
  }

  Map<String, dynamic> _jsonSaleRequest = {
    "crossId": UserIdentity.identity,
    "EnterpriseOriginCode": 0,
    "EnterpriseDestinyCode": 0,
    "RequestTypeCode": 0,
    "Products": [],
  };

  String _errorMessageProducts = '';
  String get errorMessageProducts => _errorMessageProducts;
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  List<TransferRequestProductsModel> _products = [];
  get products => [..._products];
  get productsCount => _products.length;
  FocusNode searchProductFocusNode = FocusNode();
  FocusNode consultedProductFocusNode = FocusNode();
  Map<String, Map<String, Map<String, List<TransferRequestCartProductsModel>>>>
      _cartProducts = {};

  getCartProducts({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    return _cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ??
        [];
  }

  restoreProductRemoved({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .insert(indexOfRemovedProduct!, removedProduct!);

    await _updateCartInDatabase();
    notifyListeners();
  }

  // Map<requestTypeCode, Map<enterpriseOriginCode, Map<enterpriseDestinyCode, List<TransferRequestCartProductsModel>>>>
  int? indexOfRemovedProduct;
  TransferRequestCartProductsModel? removedProduct;

  // getCartProducts({
  //   required String enterpriseOriginCode,
  //   required String enterpriseDestinyCode,
  // }) {
  //   return _cartProducts[enterpriseOriginCode]?[enterpriseDestinyCode] ?? 0;
  // }

  removeProductFromCart({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    // removedProduct = _cartProducts[enterpriseCode]!.firstWhere(
    //     (element) => element.ProductPackingCode == ProductPackingCode);

    indexOfRemovedProduct = _cartProducts[requestTypeCode]![
            enterpriseOriginCode]![enterpriseDestinyCode]!
        .indexWhere(
            (element) => element.ProductPackingCode == ProductPackingCode);

    removedProduct = _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .removeAt(indexOfRemovedProduct!);

    // _cartProducts[enterpriseCode]!.removeWhere(
    //     (element) => element.ProductPackingCode == ProductPackingCode);

    await _updateCartInDatabase();

    notifyListeners();
  }

  _updateCartInDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("transferCart");
    await prefs.setString("transferCart", json.encode(_cartProducts));
  }

  void clearProducts() {
    _products.clear();
    notifyListeners();
  }

  double getTotalItensInCart({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    double atualQuantity = 0;

    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .forEach((element) {
        // print(element["ProductPackingCode"]);
        if (element.ProductPackingCode == ProductPackingCode) {
          atualQuantity = element.Quantity;
        }
      });

      return atualQuantity;
    }
  }

  double tryChangeControllerTextToDouble(
      TextEditingController consultedProductController) {
    if (double.tryParse(
            consultedProductController.text.replaceAll(RegExp(r','), '.')) !=
        null) {
      return double.tryParse(
          consultedProductController.text.replaceAll(RegExp(r','), '.'))!;
    } else {
      return 0;
    }
  }

  _changeCursorToLastIndex(TextEditingController consultedProductController) {
    consultedProductController.selection = TextSelection.collapsed(
      offset: consultedProductController.text.length,
    );
  }

  bool canShowInsertProductQuantityForm({
    required TransferRequestProductsModel product,
    required int selectedIndex,
    required int index,
  }) {
    if (selectedIndex != index &&
        productsCount == 1 &&
        product.WholePracticedPrice > 0)
      return true;
    else {
      return false;
    }
  }

  alreadyContainsProduct({
    required int ProductPackingCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    bool alreadyContainsProduct = false;

    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return false;
    } else {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .forEach((element) {
        if (ProductPackingCode == element.ProductPackingCode) {
          alreadyContainsProduct = true;
        }
      });

      return alreadyContainsProduct;
    }
  }

  dynamic addProductInCart({
    required TransferRequestProductsModel product,
    required TextEditingController consultedProductController,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    double quantity =
        tryChangeControllerTextToDouble(consultedProductController);

    if (quantity == 0) {
      quantity = 1; //quando retornar zero, precisa adicionar uma unidade
    }

    TransferRequestCartProductsModel cartProductsModel =
        TransferRequestCartProductsModel(
      ProductPackingCode: product.ProductPackingCode,
      Name: product.Name,
      Quantity: quantity,
      Value: product.Value,
      IncrementPercentageOrValue: "0.0",
      IncrementValue: 0.0,
      DiscountPercentageOrValue: "0.0",
      DiscountValue: 0.0,
      ExpectedDeliveryDate: "\"${DateTime.now().toString()}\"",
      ProductCode: product.ProductCode,
      PLU: product.PLU,
      PackingQuantity: product.PackingQuantity,
      RetailPracticedPrice: product.RetailPracticedPrice,
      RetailSalePrice: product.RetailSalePrice,
      RetailOfferPrice: product.RetailOfferPrice,
      WholePracticedPrice: product.WholePracticedPrice,
      WholeSalePrice: product.WholeSalePrice,
      WholeOfferPrice: product.WholeOfferPrice,
      ECommercePracticedPrice: product.ECommercePracticedPrice,
      ECommerceSalePrice: product.ECommerceSalePrice,
      ECommerceOfferPrice: product.ECommerceOfferPrice,
      MinimumWholeQuantity: product.MinimumWholeQuantity,
      BalanceStockSale: product.BalanceStockSale,
      StorageAreaAddress: product.StorageAreaAddress,
      StockByEnterpriseAssociateds: product.StockByEnterpriseAssociateds,
    );

    if (alreadyContainsProduct(
        ProductPackingCode: product.ProductPackingCode,
        enterpriseDestinyCode: enterpriseDestinyCode,
        enterpriseOriginCode: enterpriseOriginCode,
        requestTypeCode: requestTypeCode)) {
      int index = _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .indexWhere((element) =>
              element.ProductPackingCode == product.ProductPackingCode);

      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]![index]
          .Quantity += quantity;
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]![index]
          .Value = product.Value;
    } else {
      if (_cartProducts[requestTypeCode] == null) {
        _cartProducts[requestTypeCode] = {};
      }
      if (_cartProducts[requestTypeCode]![enterpriseOriginCode] == null) {
        _cartProducts[requestTypeCode]![enterpriseOriginCode] = {};
      }
      if (_cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode] ==
          null) {
        _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode] = [];
      }

      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .add(cartProductsModel);
    }

    consultedProductController.text = "";

    _changeCursorToLastIndex(consultedProductController);

    await _updateCartInDatabase();
    notifyListeners();
  }

  double getTotalItemValue({
    required TransferRequestProductsModel product,
    required TextEditingController consultedProductController,
  }) {
    double _quantityToAdd =
        tryChangeControllerTextToDouble(consultedProductController);

    if (_quantityToAdd == 0) {
      //quando o campo de quantidade estiver sem dados ou não conseguir
      //converter a informação para inteiro, o aplicativo vai informar que a
      //quanitdade a ser inserida será "1"
      _quantityToAdd = 1;
    }

    double _totalItemValue = _quantityToAdd * product.Value;

    double? controllerInDouble = double.tryParse(
        consultedProductController.text.replaceAll(RegExp(r'\,'), '.'));

    if (controllerInDouble != null) {
      _quantityToAdd = double.tryParse(
        consultedProductController.text.replaceAll(RegExp(r','), '\.'),
      )!;
    }

    _changeCursorToLastIndex(consultedProductController);

    return _totalItemValue;
  }

  restoreProducts({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('transferCart') != "" &&
        prefs.getString('transferCart') != null) {
      var _key = prefs.getString("transferCart")!;
      Map cartProductsInDatabase = jsonDecode(_key);

      List<TransferRequestCartProductsModel> cartProductsTemp = [];

      if (cartProductsInDatabase.isEmpty) {
        return;
      } else if (cartProductsInDatabase[requestTypeCode] == null) {
        return;
      } else if (cartProductsInDatabase[requestTypeCode]
              [enterpriseOriginCode] ==
          null) {
        return;
      } else if (cartProductsInDatabase[requestTypeCode][enterpriseOriginCode]
              [enterpriseDestinyCode] ==
          null) return;

      _cartProducts[requestTypeCode] = {};
      _cartProducts[requestTypeCode]![enterpriseOriginCode] = {};
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
          enterpriseDestinyCode] = [];
      _cartProducts[requestTypeCode]?[enterpriseOriginCode]
          ?[enterpriseDestinyCode] = [];

      //se não fizer essas atribuições, não funciona adicionar os produtos do cartProductsTemp no _cartProducts

      cartProductsInDatabase[requestTypeCode][enterpriseOriginCode]
              [enterpriseDestinyCode]
          .forEach((element) {
        cartProductsTemp
            .add(TransferRequestCartProductsModel.fromJson(element));
        _cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] = cartProductsTemp;
      });

      notifyListeners();
    }
  }

  Future<void> updateProductFromCart({
    required int productPackingCode,
    required double quantity,
    required double value,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
    required int index,
  }) async {
    _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]![index]
        .Quantity = quantity;
    _cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]![index]
        .Value = value;

    await _updateCartInDatabase();
    notifyListeners();
  }

  clearCart({
    required String requestTypeCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
  }) async {
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] !=
        null) {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .clear();
    }

    await _updateCartInDatabase();
    notifyListeners();
  }

  Future<void> getRequestModels() async {
    _errorMessageRequestModel = '';
    _isLoadingRequestModel = true;
    _destinyEnterprises.clear();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET',
          Uri.parse('${BaseUrl.url}/TransferRequest/RequestType?searchValue='));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta dos pedidos: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageRequestModel = json.decode(resultAsString)["Message"];

        _isLoadingRequestModel = false;

        notifyListeners();
        return;
      }
      TransferRequestModel.resultAsStringToConsultPriceModel(
        resultAsString: resultAsString,
        listToAdd: _requestModels,
      );
    } catch (e) {
      print('deu erro para consultar os pedidos: $e');
      _errorMessageRequestModel = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingRequestModel = false;
    notifyListeners();
  }

  Future<void> getOriginEnterprises({
    required int requestTypeCode,
  }) async {
    _errorMessageOriginEnterprise = '';
    _isLoadingOriginEnterprise = true;
    _originEnterprises.clear();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'GET',
          Uri.parse(
              '${BaseUrl.url}/TransferRequest/EnterpriseOrigin?requestTypeCode=$requestTypeCode&searchValue=%'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta das empresas de origem: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageOriginEnterprise = json.decode(resultAsString)["Message"];

        _isLoadingOriginEnterprise = false;

        notifyListeners();
        return;
      }
      TransferOriginEnterpriseModel.resultAsStringToOriginEnterpriseModel(
        resultAsString: resultAsString,
        listToAdd: _originEnterprises,
      );
    } catch (e) {
      print('deu erro para consultar as empresas de origem: $e');
      _errorMessageOriginEnterprise =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingOriginEnterprise = false;
    notifyListeners();
  }

  int cartProductsCount({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else if (_cartProducts[requestTypeCode]![enterpriseOriginCode]![
            enterpriseDestinyCode]!
        .isEmpty) {
      return 0;
    } else {
      return _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .length;
    }
  }

  double getTotalCartPrice({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
  }) {
    double total = 0;
    if (_cartProducts[requestTypeCode]?[enterpriseOriginCode]
            ?[enterpriseDestinyCode] ==
        null) {
      return 0;
    } else {
      _cartProducts[requestTypeCode]![enterpriseOriginCode]![
              enterpriseDestinyCode]!
          .forEach((element) {
        total += (element.Quantity * element.Value) - element.DiscountValue;
      });

      return total;
    }
  }

  Future<void> getDestinyEnterprises({
    required int requestTypeCode,
    required int enterpriseOriginCode,
  }) async {
    _errorMessageDestinyEnterprise = '';
    _isLoadingDestinyEnterprise = true;
    _destinyEnterprises.clear();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '${BaseUrl.url}/TransferRequest/EnterpriseDestiny?requestTypeCode=$requestTypeCode&enterpriseOriginCode=$enterpriseOriginCode&searchValue=%',
        ),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta das empresas de destino: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageDestinyEnterprise = json.decode(resultAsString)["Message"];

        _isLoadingDestinyEnterprise = false;

        notifyListeners();
        return;
      }
      TransferDestinyEnterpriseModel.resultAsStringToDestinyEnterpriseModel(
        resultAsString: resultAsString,
        listToAdd: _destinyEnterprises,
      );
    } catch (e) {
      print('deu erro para consultar as empresas de destino: $e');
      _errorMessageDestinyEnterprise =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingDestinyEnterprise = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required String requestTypeCode,
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String value,
    required bool isLegacyCodeSearch,
  }) async {
    _errorMessageProducts = '';
    _isLoadingProducts = true;
    _products.clear();
    notifyListeners();

    http.Request? request;
    var headers = {'Content-Type': 'application/json'};

    if (isLegacyCodeSearch) {
      request = http.Request(
        'GET',
        Uri.parse(
          '${BaseUrl.url}/TransferRequest/ProductByLegacyCode?enterpriseCode=$enterpriseOriginCode&enterpriseDestinyCode=$enterpriseDestinyCode&requestTypeCode=$requestTypeCode&searchValue=$value',
        ),
      );
    } else {
      request = http.Request(
        'GET',
        Uri.parse(
          '${BaseUrl.url}/TransferRequest/Product?enterpriseCode=$enterpriseOriginCode&enterpriseDestinyCode=$enterpriseDestinyCode&requestTypeCode=$requestTypeCode&searchValue=$value',
        ),
      );
    }

    try {
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta dos produtos: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageProducts = json.decode(resultAsString)["Message"];

        _isLoadingProducts = false;

        notifyListeners();
        return;
      }
      TransferRequestProductsModel
          .responseAsStringToTransferRequestProductsModel(
        responseAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      print('deu erro para consultar os produtos: $e');
      _errorMessageProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> saveTransferRequest({
    required String enterpriseOriginCode,
    required String enterpriseDestinyCode,
    required String requestTypeCode,
    required BuildContext context,
  }) async {
    _jsonSaleRequest["crossId"] = '${UserIdentity.identity}';

    TransferRequestCartProductsModel.updateJsonSaleRequest(
      products: _cartProducts[requestTypeCode]![enterpriseOriginCode]![
          enterpriseDestinyCode]!,
      jsonSaleRequest: _jsonSaleRequest,
      enterpriseOriginCode: int.parse(enterpriseOriginCode),
      enterpriseDestinyCode: int.parse(enterpriseDestinyCode),
      requestTypeCode: int.parse(requestTypeCode),
    );

    var encodeJsonSaleRequest = json.encode(_jsonSaleRequest);
    _jsonSaleRequest.toString();

    _errorMessageSaveTransferRequest = "";
    _isLoadingSaveTransferRequest = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST', Uri.parse('${BaseUrl.url}/TransferRequest/Insert'));
      request.body = json.encode(encodeJsonSaleRequest);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para salvar a transferência = $responseInString');

      if (responseInString.contains("sucesso")) {
        await clearCart(
          requestTypeCode: requestTypeCode,
          enterpriseOriginCode: enterpriseOriginCode,
          enterpriseDestinyCode: enterpriseDestinyCode,
        );

        _lastSavedTransferRequest = json.decode(responseInString)["Message"];
        int index = _lastSavedTransferRequest.indexOf(RegExp(r'\('));
        _lastSavedTransferRequest = "Último pedido salvo: " +
            _lastSavedTransferRequest.replaceRange(0, index + 1, "");
        _lastSavedTransferRequest = _lastSavedTransferRequest
            .replaceAll(RegExp(r'\)'), '')
            .trim()
            .replaceAll(RegExp(r'\n'), '');

        notifyListeners();
        ShowErrorMessage.showErrorMessage(
          error: "O pedido foi salvo com sucesso!",
          context: context,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );
      } else {
        //significa que deu algum erro
        _errorMessageSaveTransferRequest =
            json.decode(responseInString)["Message"];
        _isLoadingSaveTransferRequest = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorMessageSaveTransferRequest,
          context: context,
        );

        notifyListeners();
        return;
      }
    } catch (e) {
      print("Erro para salvar a transferência: $e");
      _errorMessageSaveTransferRequest =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageSaveTransferRequest,
        context: context,
      );
    } finally {
      _isLoadingSaveTransferRequest = false;
      notifyListeners();
    }
  }
}
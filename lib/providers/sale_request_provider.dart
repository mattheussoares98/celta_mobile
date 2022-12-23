import 'dart:convert';

import 'package:celta_inventario/Components/Global_widgets/enterprise_items.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_costumer_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_products_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_request_type_model.dart';
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
  Map<int, List<SaleRequestCostumerModel>> _costumers = {};

  costumers(int enterpriseCode) {
    return _costumers[enterpriseCode];
  }

  int _costumerCode =
      -1; //-1 significa que nenhum foi selecionado ainda, por isso precisa aparecer uma mensagem
  int get costumerCode => _costumerCode;

  void set costumerCode(int value) {
    _costumerCode = value;
  }

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageProducts = "";
  String get errorMessageProducts => _errorMessageProducts;
  List<SaleRequestProductsModel> _products = [];
  get products => [..._products];
  get productsCount => _products.length;
  var removedProduct;
  int? indexOfRemovedProduct;

  Map<int, List<Map<String, dynamic>>> _cartProducts = {};
  getCartProducts(int enterpriseCode) {
    return _cartProducts[enterpriseCode];
  }

  int cartProductsCount(int enterpriseCode) {
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else if (_cartProducts[enterpriseCode]!.isEmpty) {
      return 0;
    } else if (!_cartProducts[enterpriseCode]![0]
        .containsKey("ProductPackingCode")) {
      return 0;
    } else {
      return _cartProducts[enterpriseCode]!.length;
    }
  }

  String _errorMessageSaveSaleRequest = "";
  get errorMessageSaveSaleRequest => _errorMessageSaveSaleRequest;
  bool _isLoadingSaveSaleRequest = false;
  get isLoadingSaveSaleRequest => _isLoadingSaveSaleRequest;

  String _lastSaleRequestSaved = "";
  String get lastSaleRequestSaved => _lastSaleRequestSaved;

  // insertEnterpriseKeyOfCartProducts(int enterpriseCode) {
  //   //precisa inserir o código da empresa como chave do Map dos produtos do
  //   //carrinho quando acessa a página SaleRequestPage para conseguir adicionar,
  //   //remover e alterar produtos no carrinho
  //   _cartProducts.putIfAbsent(enterpriseCode, () => [{}]);
  //   print(_cartProducts);
  // }

  insertDefaultCostumer(int enterpriseCode) {
    //sempre que seleciona a empresa para ir à tela de pedido de vendas, no
    //initstate precisa adicionar o consumidor padrão para os consumidores serem
    //informados por empresa. Assim, se voltar e selecionar outra empresa, os
    //clientes estarão vinculados à essa empresa e não aparecerão nas outras
    _costumers.putIfAbsent(
        enterpriseCode,
        () => [
              SaleRequestCostumerModel(
                Code: 1,
                PersonalizedCode: "1",
                Name: "Consumidor",
                ReducedName: "",
                CpfCnpjNumber: "1",
                RegistrationNumber: "",
                SexType: "M",
                selected: false,
              ),
            ]);
  }

  _clearCostumers(int enterpriseCode) {
    _costumers[enterpriseCode] = [
      SaleRequestCostumerModel(
        Code: 1,
        PersonalizedCode: "1",
        Name: "Consumidor",
        ReducedName: "",
        CpfCnpjNumber: "1",
        RegistrationNumber: "",
        SexType: "M",
        selected: false,
      ),
    ];
    notifyListeners();
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

  double getPraticedPrice({
    required SaleRequestProductsModel product,
    required TextEditingController consultedProductController,
    required int enterpriseCode,
  }) {
    double _quantityToAdd =
        tryChangeControllerTextToDouble(consultedProductController);
    double _totalItensInCart = getTotalItensInCart(
      ProductPackingCode: product.ProductPackingCode,
      enterpriseCode: enterpriseCode,
    );

    if (product.MinimumWholeQuantity == 0) {
      return product.RetailSalePrice;
    } else if ((_quantityToAdd + _totalItensInCart) <
        product.MinimumWholeQuantity) {
      return product.RetailSalePrice;
    } else {
      return product.WholeSalePrice;
    }
  }

  double getTotalItemValue({
    required SaleRequestProductsModel product,
    required TextEditingController consultedProductController,
    required int enterpriseCode,
  }) {
    double _quantityToAdd =
        tryChangeControllerTextToDouble(consultedProductController);

    double _praticedPrice = getPraticedPrice(
      product: product,
      consultedProductController: consultedProductController,
      enterpriseCode: enterpriseCode,
    );

    double _totalItemValue = _quantityToAdd * _praticedPrice;

    double? controllerInDouble = double.tryParse(
        consultedProductController.text.replaceAll(RegExp(r'\,'), '.'));

    if (controllerInDouble == null) {
      _quantityToAdd = 0;
      _totalItemValue = 0;
    } else {
      _quantityToAdd = double.tryParse(
        consultedProductController.text.replaceAll(RegExp(r','), '\.'),
      )!;
    }

    _changeCursorToLastIndex(consultedProductController);

    return _totalItemValue;
  }

  _changeCursorToLastIndex(TextEditingController consultedProductController) {
    consultedProductController.selection = TextSelection.collapsed(
      offset: consultedProductController.text.length,
    );
  }

  _removeNotUsedKeysFromCart(List cartListCopyToRemoveKeys) {
    cartListCopyToRemoveKeys.forEach((element) {
      element.remove("ProductCode");
      element.remove("Name");
      element.remove("PLU");
      element.remove("PackingQuantity");
      element.remove("RetailPracticedPrice");
      element.remove("RetailSalePrice");
      element.remove("RetailOfferPrice");
      element.remove("WholePracticedPrice");
      element.remove("WholeSalePrice");
      element.remove("WholeOfferPrice");
      element.remove("ECommercePracticedPrice");
      element.remove("ECommerceSalePrice");
      element.remove("ECommerceOfferPrice");
      element.remove("MinimumWholeQuantity");
      element.remove("BalanceStockSale");
      element.remove("StorageAreaAddress");
      element.remove("StockByEnterpriseAssociateds");
    });
  }

  dynamic addProductInCart({
    required SaleRequestProductsModel product,
    required TextEditingController consultedProductController,
    required int enterpriseCode,
  }) async {
    double praticedPrice = getPraticedPrice(
      product: product,
      consultedProductController: consultedProductController,
      enterpriseCode: enterpriseCode,
    );
    double quantity =
        tryChangeControllerTextToDouble(consultedProductController);

    //as chaves que estão com o comentário "remove" são removidas para enviar a
    //requisição de salvar o pedido. Salvei todas informações do produto no
    //carrinho porque precisa de várias para conseguir editar a quantidade do
    //produto que já está no carrinho
    Map<String, Object> value = {
      "ProductPackingCode": product.ProductPackingCode,
      "Name": product.Name,
      "Quantity": quantity,
      "Value": praticedPrice,
      "IncrementPercentageOrValue": "0.0",
      "IncrementValue": 0.0,
      "DiscountPercentageOrValue": "0.0",
      "DiscountValue": 0.0,
      "ExpectedDeliveryDate": '\"${DateTime.now()}\"',
      "ProductCode": product.ProductCode, //remove
      "PLU": product.PLU, //remove
      "PackingQuantity": product.PackingQuantity,
      "RetailPracticedPrice": product.RetailPracticedPrice, //remove
      "RetailSalePrice": product.RetailSalePrice, //remove
      "RetailOfferPrice": product.RetailOfferPrice, //remove
      "WholePracticedPrice": product.WholePracticedPrice, //remove
      "WholeSalePrice": product.WholeSalePrice, //remove
      "WholeOfferPrice": product.WholeOfferPrice, //remove
      "ECommercePracticedPrice": product.ECommercePracticedPrice, //remove
      "ECommerceSalePrice": product.ECommerceSalePrice, //remove
      "ECommerceOfferPrice": product.ECommerceOfferPrice, //remove
      "MinimumWholeQuantity": product.MinimumWholeQuantity, //remove
      "BalanceStockSale": product.BalanceStockSale, //remove
      "StorageAreaAddress": product.StorageAreaAddress, //remove
      "StockByEnterpriseAssociateds":
          product.StockByEnterpriseAssociateds, //remove
    };

    if (alreadyContainsProduct(
      ProductPackingCode: product.ProductPackingCode,
      enterpriseCode: enterpriseCode,
    )) {
      int index = _cartProducts[enterpriseCode]!.indexWhere((element) =>
          element["ProductPackingCode"] == product.ProductPackingCode);
      _cartProducts[index]![enterpriseCode]["Quantity"] += quantity;
      _cartProducts[index]![enterpriseCode]["Value"] = praticedPrice;
    } else {
      if (_cartProducts[enterpriseCode] == null) {
        _cartProducts[enterpriseCode] = [{}];
        _cartProducts[enterpriseCode]![0] = value;
      } else {
        _cartProducts[enterpriseCode]!.add(value);
      }
    }

    consultedProductController.text = "";

    _changeCursorToLastIndex(consultedProductController);

    jsonSaleRequest["Products"] = _cartProducts;
    notifyListeners();
  }

  updateProductFromCart({
    required int productPackingCode,
    required double quantity,
    required double value,
    required int enterpriseCode,
  }) {
    _cartProducts[enterpriseCode]!.forEach((element) {
      if (element["ProductPackingCode"] == productPackingCode) {
        element["Quantity"] = quantity;
        element["Value"] = value;
      }
    });
    notifyListeners();
  }

  double getTotalCartPrice(int enterpriseCode) {
    double total = 0;
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        print("element Quantity: ${element["Quantity"]}");
        print("element Value: ${element["Value"]}");

        total += element["Quantity"] * element["Value"];
      });

      return total;
    }
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

  clearCart(int enterpriseCode) {
    if (_cartProducts[enterpriseCode] != null) {
      _cartProducts[enterpriseCode]!.clear();
    }
    notifyListeners();
  }

  removeProductFromCart({
    required int ProductPackingCode,
    required int enterpriseCode,
  }) {
    indexOfRemovedProduct = _cartProducts[enterpriseCode]!.indexWhere(
        (element) => element["ProductPackingCode"] == ProductPackingCode);

    removedProduct =
        _cartProducts[enterpriseCode]!.removeAt(indexOfRemovedProduct!);
    notifyListeners();
  }

  restoreProductRemoved(int enterpriseCode) {
    _cartProducts[enterpriseCode]!
        .insert(indexOfRemovedProduct!, removedProduct);
    notifyListeners();
  }

  alreadyContainsProduct({
    required int ProductPackingCode,
    required int enterpriseCode,
  }) {
    bool alreadyContainsProduct = false;

    if (_cartProducts[enterpriseCode] == null) {
      return false;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        if (ProductPackingCode == element["ProductPackingCode"]) {
          alreadyContainsProduct = true;
        }
      });

      return alreadyContainsProduct;
    }
  }

  double getTotalItensInCart({
    required int ProductPackingCode,
    required int enterpriseCode,
  }) {
    double atualQuantity = 0;
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        // print(element["ProductPackingCode"]);
        if (element["ProductPackingCode"] == ProductPackingCode) {
          atualQuantity = double.tryParse(element["Quantity"].toString())!;
        }
      });

      return atualQuantity;
    }
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

  void updateSelectedCostumer({
    required int index,
    required bool value,
    required int enterpriseCode,
  }) {
    _costumers[enterpriseCode]?.forEach((element) {
      element.selected = false;
    });
    _costumers[enterpriseCode]?[index].selected = value;

    if (_costumers[enterpriseCode]![index].selected) {
      _costumerCode = _costumers[enterpriseCode]![index].Code;
    } else {
      _costumerCode = -1;
    }
    notifyListeners();
  }

  Future<void> getCostumers({
    required BuildContext context,
    required String searchValueControllerText,
    required int enterpriseCode,
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
        enterpriseCode: enterpriseCode,
      );
    } else {
      await _getCostumers(
        context: context,
        searchTypeInt: 2, //exactCode
        searchValueControllerText: searchValueControllerText,
        enterpriseCode: enterpriseCode,
      );

      if (_costumers.isNotEmpty) return;

      await _getCostumers(
        context: context,
        searchTypeInt: 1, //exactCnpjCpfNumber
        searchValueControllerText: searchValueControllerText,
        enterpriseCode: enterpriseCode,
      );
    }
  }

  Future<void> _getCostumers({
    required BuildContext context,
    required int searchTypeInt,
    required String searchValueControllerText,
    required int enterpriseCode,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName

    _costumers[enterpriseCode]?.removeWhere((element) => element.Code != 1);
//não remove o "consumidor"

    _errorMessageCostumer = "";
    _isLoadingCostumer = true;
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

      if (responseInString.contains('\\"Code\\":1,')) {
        return;
      }

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageCostumer = json.decode(responseInString)["Message"];
        _isLoadingCostumer = false;

        notifyListeners();
        return;
      }

      SaleRequestCostumerModel.responseAsStringToSaleRequestCostumerModel(
        responseAsString: responseInString,
        listToAdd: _costumers[enterpriseCode]!,
      );
    } catch (e) {
      print("Erro para obter os clientes: $e");
      _errorMessageCostumer = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingCostumer = false;
      notifyListeners();
    }
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
        _errorMessageProducts = json.decode(responseInString)["Message"];
        _isLoadingRequestType = false;

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
    bool hasSearchByLegacyCode = false,
  }) async {
// 2=ExactPriceLookUp
// 4=ExactEan
// 6=ApproximateName
// 11=ApproximateLegacyCode

    if (hasSearchByLegacyCode) {
      //quando seleciona a opção de código legado precisa pesquisar somente pelo
      //código legado, por isso o sistema já retorna encontrando ou não algum
      //produto
      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 11, //ApproximateLegacyCode
        context: context,
      );
      return;
    }

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

  saveSaleRequest({
    required int enterpriseCode,
    required int requestTypeCode,
    required BuildContext context,
  }) async {
    List cartListCopyToRemoveKeys = [];
    _cartProducts[enterpriseCode]!.forEach((element) {
      cartListCopyToRemoveKeys.add(json.decode(json.encode(
          element))); //fazendo uma cópia da lista _cartProducts. Fazendo cópia por atribuição estava apontando pro mesmo local de memória
    });

    _removeNotUsedKeysFromCart(cartListCopyToRemoveKeys);

    String cartString = cartListCopyToRemoveKeys
        .toString()
        .replaceAll(RegExp(r'ProductPackingCode'), '\"ProductPackingCode\"')
        .replaceAll(RegExp(r', Quantity'), ',\"Quantity\"')
        .replaceAll(RegExp(r', Value'), ',\"value\"')
        .replaceAll(RegExp(r', IncrementPercentageOrValue'),
            ',\"IncrementPercentageOrValue\"')
        .replaceAll(RegExp(r', IncrementValue'), ',\"IncrementValue\"')
        .replaceAll(RegExp(r', DiscountPercentageOrValue'),
            ',\"DiscountPercentageOrValue\"')
        .replaceAll(RegExp(r', DiscountValue'), ',\"DiscountValue\"')
        .replaceAll(
            RegExp(r', ExpectedDeliveryDate'), ',\"ExpectedDeliveryDate\"');

    String saleRequestBodyString =
        "{\"crossId\": \"${UserIdentity.identity}\",\"EnterpriseCode\": $enterpriseCode,\"RequestTypeCode\": $requestTypeCode,\"SellerCode\": 0,\"CustomerCode\": $costumerCode," +
            "\"Products\": $cartString}";

    _errorMessageSaveSaleRequest = "";
    _isLoadingSaveSaleRequest = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('${BaseUrl.url}/SaleRequest/Insert'));
      request.body = json.encode(saleRequestBodyString);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para salvar o pedido = $responseInString');

      if (responseInString.contains("sucesso")) {
        _cartProducts[enterpriseCode]!.clear();
        _clearCostumers(enterpriseCode);
        _lastSaleRequestSaved = json.decode(responseInString)["Message"];
        int index = _lastSaleRequestSaved.indexOf(RegExp(r'\('));
        _lastSaleRequestSaved = "Último pedido salvo: " +
            _lastSaleRequestSaved.replaceRange(0, index + 1, "");
        _lastSaleRequestSaved = _lastSaleRequestSaved
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
        _errorMessageSaveSaleRequest = json.decode(responseInString)["Message"];
        _isLoadingSaveSaleRequest = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorMessageSaveSaleRequest,
          context: context,
        );

        notifyListeners();
        return;
      }
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorMessageSaveSaleRequest =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageSaveSaleRequest,
        context: context,
      );
    } finally {
      _isLoadingSaveSaleRequest = false;
      notifyListeners();
    }
  }
}

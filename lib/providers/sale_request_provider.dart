import 'dart:convert';
import 'package:celta_inventario/Models/sale_request_models/sale_request_cart_products_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_costumer_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_products_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_request_type_model.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, List<SaleRequestCostumerModel>> _costumers = {};

  costumers(String enterpriseCode) {
    return _costumers[enterpriseCode];
  }

  getCostumerCode(String enterpriseCode) {
    int costumerCode = -1;
    if (_costumers[enterpriseCode] != null)
      _costumers[enterpriseCode]!.forEach((element) {
        if (element.selected) {
          costumerCode = element.Code;
        }
      });
    else {
      costumerCode = -1;
    }
    return costumerCode;
  }

  insertDefaultCostumer(String enterpriseCode) {
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

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageProducts = "";
  String get errorMessageProducts => _errorMessageProducts;
  List<SaleRequestProductsModel> _products = [];
  get products => [..._products];
  get productsCount => _products.length;
  var removedProduct;
  int? indexOfRemovedProduct;

  Map<String, List<SaleRequestCartProductsModel>> _cartProducts = {};
  getCartProducts(int enterpriseCode) {
    return _cartProducts[enterpriseCode.toString()] ?? 0;
  }

  int cartProductsCount(String enterpriseCode) {
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else if (_cartProducts[enterpriseCode]!.isEmpty) {
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

  _updateCostumerInDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("costumers");
    await prefs.setString("costumers", json.encode(_costumers));
  }

  restoreCostumers(String enterpriseCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('costumers') != "" &&
        prefs.getString('costumers') != null) {
      var _key = prefs.getString("costumers")!;
      Map costumersInDatabase = jsonDecode(_key);

      List<SaleRequestCostumerModel> costumersTemp = [];
      costumersInDatabase.forEach((key, value) {
        if (key == enterpriseCode) {
          value.forEach((element) {
            costumersTemp.add(SaleRequestCostumerModel.fromJson(element));
          });
        }
      });
      _costumers[enterpriseCode] = costumersTemp;

      notifyListeners();
    }
  }

  _clearCostumers(String enterpriseCode) async {
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
    await _updateCostumerInDatabase();
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
    required String enterpriseCode,
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
    required String enterpriseCode,
  }) {
    double _quantityToAdd =
        tryChangeControllerTextToDouble(consultedProductController);

    if (_quantityToAdd == 0) {
      //quando o campo de quantidade estiver sem dados ou não conseguir
      //converter a informação para inteiro, o aplicativo vai informar que a
      //quanitdade a ser inserida será "1"
      _quantityToAdd = 1;
    }

    double _praticedPrice = getPraticedPrice(
      product: product,
      consultedProductController: consultedProductController,
      enterpriseCode: enterpriseCode,
    );

    double _totalItemValue = _quantityToAdd * _praticedPrice;

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

  _updateCartInDatabase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("cart");
    await prefs.setString("cart", json.encode(_cartProducts));
  }

  restoreProducts(String enterpriseCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cart') != "" && prefs.getString('cart') != null) {
      var _key = prefs.getString("cart")!;
      Map cartProductsInDatabase = jsonDecode(_key);

      List<SaleRequestCartProductsModel> cartProductsTemp = [];
      cartProductsInDatabase.forEach((key, value) {
        if (key == enterpriseCode) {
          value.forEach((element) {
            cartProductsTemp
                .add(SaleRequestCartProductsModel.fromJson(element));
          });
        }
      });

      _cartProducts[enterpriseCode] = cartProductsTemp;
      // var cart = SaleRequestCartProductsModel.fromJson(cartProductsInDatabase);

      // _cartProducts[enterpriseCode] = cartProductsInDatabase[enterpriseCode];
      notifyListeners();
    }
  }

  dynamic addProductInCart({
    required SaleRequestProductsModel product,
    required TextEditingController consultedProductController,
    required String enterpriseCode,
  }) async {
    double praticedPrice = getPraticedPrice(
      product: product,
      consultedProductController: consultedProductController,
      enterpriseCode: enterpriseCode,
    );
    double quantity =
        tryChangeControllerTextToDouble(consultedProductController);

    if (quantity == 0) {
      quantity = 1; //quando retornar zero, precisa adicionar uma unidade
    }

    SaleRequestCartProductsModel cartProductsModel =
        SaleRequestCartProductsModel(
      ProductPackingCode: product.ProductPackingCode,
      Name: product.Name,
      Quantity: quantity,
      Value: praticedPrice,
      IncrementPercentageOrValue: "0.0",
      IncrementValue: 0.0,
      DiscountPercentageOrValue: "0.0",
      DiscountValue: 0.0,
      ExpectedDeliveryDate: "\"${DateTime.now().toString()}\"",
      ProductCode: product.ProductCode, //remove
      PLU: product.PLU, //remove
      PackingQuantity: product.PackingQuantity,
      RetailPracticedPrice: product.RetailPracticedPrice, //remove
      RetailSalePrice: product.RetailSalePrice, //remove
      RetailOfferPrice: product.RetailOfferPrice, //remove
      WholePracticedPrice: product.WholePracticedPrice, //remove
      WholeSalePrice: product.WholeSalePrice, //remove
      WholeOfferPrice: product.WholeOfferPrice, //remove
      ECommercePracticedPrice: product.ECommercePracticedPrice, //remove
      ECommerceSalePrice: product.ECommerceSalePrice, //remove
      ECommerceOfferPrice: product.ECommerceOfferPrice, //remove
      MinimumWholeQuantity: product.MinimumWholeQuantity, //remove
      BalanceStockSale: product.BalanceStockSale, //remove
      StorageAreaAddress: product.StorageAreaAddress, //remove
      StockByEnterpriseAssociateds: product.StockByEnterpriseAssociateds,
    );

    //as chaves que estão com o comentário "remove" são removidas para enviar a
    //requisição de salvar o pedido. Salvei todas informações do produto no
    //carrinho porque precisa de várias para conseguir editar a quantidade do
    //produto que já está no carrinho

    if (alreadyContainsProduct(
      ProductPackingCode: product.ProductPackingCode,
      enterpriseCode: enterpriseCode,
    )) {
      int index = _cartProducts[enterpriseCode]!.indexWhere((element) =>
          element.ProductPackingCode == product.ProductPackingCode);

      _cartProducts[enterpriseCode]![index].Quantity += quantity;
      _cartProducts[enterpriseCode]![index].Value = praticedPrice;
    } else {
      if (_cartProducts[enterpriseCode.toString()] != null) {
        _cartProducts[enterpriseCode.toString()]?.add(cartProductsModel);
      } else {
        _cartProducts.putIfAbsent(
            enterpriseCode.toString(), () => [cartProductsModel]);
      }
    }

    consultedProductController.text = "";

    _changeCursorToLastIndex(consultedProductController);

    jsonSaleRequest["Products"] = _cartProducts;

    await _updateCartInDatabase();
    notifyListeners();
  }

  updateProductFromCart({
    required int productPackingCode,
    required double quantity,
    required double value,
    required String enterpriseCode,
  }) {
    _cartProducts[enterpriseCode]!.forEach((element) {
      if (element.ProductPackingCode == productPackingCode) {
        element.Quantity = quantity;
        element.Value = value;
      }
    });
    notifyListeners();
  }

  double getTotalCartPrice(String enterpriseCode) {
    double total = 0;
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        total += element.Quantity * element.Value;
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

  clearCart(String enterpriseCode) async {
    if (_cartProducts[enterpriseCode] != null) {
      _cartProducts[enterpriseCode]!.clear();
    }

    await _updateCartInDatabase();
    notifyListeners();
  }

  removeProductFromCart({
    required int ProductPackingCode,
    required String enterpriseCode,
  }) async {
    // removedProduct = _cartProducts[enterpriseCode]!.firstWhere(
    //     (element) => element.ProductPackingCode == ProductPackingCode);

    indexOfRemovedProduct = _cartProducts[enterpriseCode]!.indexWhere(
        (element) => element.ProductPackingCode == ProductPackingCode);

    removedProduct =
        _cartProducts[enterpriseCode]!.removeAt(indexOfRemovedProduct!);

    // _cartProducts[enterpriseCode]!.removeWhere(
    //     (element) => element.ProductPackingCode == ProductPackingCode);

    await _updateCartInDatabase();

    notifyListeners();
  }

  restoreProductRemoved(String enterpriseCode) async {
    _cartProducts[enterpriseCode]!
        .insert(indexOfRemovedProduct!, removedProduct);

    await _updateCartInDatabase();
    notifyListeners();
  }

  alreadyContainsProduct({
    required int ProductPackingCode,
    required String enterpriseCode,
  }) {
    bool alreadyContainsProduct = false;

    if (_cartProducts[enterpriseCode] == null) {
      return false;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        if (ProductPackingCode == element.ProductPackingCode) {
          alreadyContainsProduct = true;
        }
      });

      return alreadyContainsProduct;
    }
  }

  double getTotalItensInCart({
    required int ProductPackingCode,
    required String enterpriseCode,
  }) {
    double atualQuantity = 0;

    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        // print(element["ProductPackingCode"]);
        if (element.ProductPackingCode == ProductPackingCode) {
          atualQuantity = element.Quantity;
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
    required String enterpriseCode,
  }) async {
    _costumers[enterpriseCode]?.forEach((element) {
      element.selected = false;
    });
    _costumers[enterpriseCode]?[index].selected = value;

    await _updateCostumerInDatabase();
    notifyListeners();
  }

  Future<void> getCostumers({
    required BuildContext context,
    required String searchValueControllerText,
    required String enterpriseCode,
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
    required String enterpriseCode,
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
    required String enterpriseCode,
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

    int costumerCode = getCostumerCode(enterpriseCode);

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
        await clearCart(enterpriseCode);

        await _clearCostumers(enterpriseCode);

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

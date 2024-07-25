import 'dart:convert';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/sale_request/sale_request.dart';
import '../utils/utils.dart';
import './providers.dart';

class SaleRequestProvider with ChangeNotifier {
  bool _isLoadingRequests = false;
  bool get isLoadingRequests => _isLoadingRequests;
  String _errorMessageRequests = "";
  String get errorMessageRequests => _errorMessageRequests;
  List<SaleRequestsModel> _requests = [];
  get requests => [..._requests];
  get requestsCount => _requests.length;

  bool _updatedCart = true;
  bool get updatedCart => _updatedCart;
  set updatedCart(bool) {
    _updatedCart = true;
  }

  bool _isLoadingCustomer = false;
  bool get isLoadingCustomer => _isLoadingCustomer;
  String _errorMessageCustomer = "";
  String get errorMessageCustomer => _errorMessageCustomer;
  Map<String, List<SaleRequestCustomerModel>> _customers = {};
  Map<String, List<SaleRequestCustomerModel>> get customers => _customers;
  int customersCount(String enterpriseCode) {
    if (_customers[enterpriseCode] == null) {
      return 0;
    } else {
      return _customers[enterpriseCode]!.length;
    }
  }

  int get indexOfSelectedCovenant {
    int _indexOfSelectedCovenant = -1;
    _customers.forEach((key, value) {
      value.forEach((customer) {
        if (customer.selected) {
          _indexOfSelectedCovenant =
              customer.Covenants.indexWhere((customer) => customer.selected);
        }
      });
    });
    return _indexOfSelectedCovenant;
  }

  getSelectedCovenantCode(String enterpriseCode) {
    int covenantCode = 0;
    if (_customers[enterpriseCode] != null) {
      _customers[enterpriseCode]!.forEach((customer) {
        customer.Covenants.forEach((covenant) {
          if (covenant.selected) {
            covenantCode = covenant.code;
          }
        });
      });
    }
    return covenantCode;
  }

  getSelectedCustomerCode(String enterpriseCode) {
    int customerCode = -1;
    if (_customers[enterpriseCode] != null)
      _customers[enterpriseCode]!.forEach((element) {
        if (element.selected) {
          customerCode = element.Code;
        }
      });
    else {
      customerCode = -1;
    }
    return customerCode;
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

  String _errorMessageProcessCart = "";
  get errorMessageProcessCart => _errorMessageProcessCart;
  bool _isLoadingProcessCart = false;
  get isLoadingProcessCart => _isLoadingProcessCart;

  String _lastSaleRequestSaved = "";
  String get lastSaleRequestSaved => _lastSaleRequestSaved;

  void clearRequests() {
    _requests.clear();
    notifyListeners();
  }

  _updateCustomerInDatabase() async {
    await PrefsInstance.setObject(
      prefsKeys: PrefsKeys.customers,
      object: _customers,
    );
  }

  restorecustomers(String enterpriseCode) async {
    String customers = await PrefsInstance.getString(PrefsKeys.customers);
    if (customers != "") {
      Map customersInDatabase = jsonDecode(customers);

      List<SaleRequestCustomerModel> customersTemp = [];
      customersInDatabase.forEach((key, value) {
        if (key == enterpriseCode) {
          value.forEach((element) {
            customersTemp.add(SaleRequestCustomerModel.fromJson(element));
          });
        }
      });
      _customers[enterpriseCode] = customersTemp;

      notifyListeners();
    }
  }

  _clearcustomers(String enterpriseCode) async {
    if (_customers[enterpriseCode] != null) {
      if (_customers[enterpriseCode]!.isNotEmpty) {
        _customers[enterpriseCode]!.clear();
      }
    }

    await _updateCustomerInDatabase();
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

  _changeCursorToLastIndex(TextEditingController consultedProductController) {
    consultedProductController.selection = TextSelection.collapsed(
      offset: consultedProductController.text.length,
    );
  }

  _updateCartInDatabase() async {
    await PrefsInstance.setString(
      prefsKeys: PrefsKeys.cart,
      value: json.encode(_cartProducts),
    );
    _updatedCart = true;
  }

  restoreProducts(String enterpriseCode) async {
    String cart = await PrefsInstance.getString(PrefsKeys.cart);
    if (cart != "") {
      Map cartProductsInDatabase = jsonDecode(cart);

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

      notifyListeners();
    }
  }

  dynamic addProductInCart({
    required SaleRequestProductsModel product,
    required TextEditingController consultedProductController,
    required String enterpriseCode,
  }) async {
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
      enterpriseCode: enterpriseCode,
    )) {
      int index = _cartProducts[enterpriseCode]!.indexWhere((element) =>
          element.ProductPackingCode == product.ProductPackingCode);

      _cartProducts[enterpriseCode]![index].Quantity += quantity;
      _cartProducts[enterpriseCode]![index].Value = product.Value;
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

    await _updateCartInDatabase();
    notifyListeners();
  }

  Future<void> updateProductFromCart({
    required int productPackingCode,
    required double quantity,
    required double value,
    required String enterpriseCode,
    required int index,
  }) async {
    _cartProducts[enterpriseCode]![index].TotalLiquid = quantity * value;
    _cartProducts[enterpriseCode]![index].Quantity = quantity;
    _cartProducts[enterpriseCode]![index].Value = value;

    await _updateCartInDatabase();
    notifyListeners();
  }

  getTotalItemPrice(SaleRequestCartProductsModel product) {
    if (product.TotalLiquid == 0) {
      return (product.Value * product.Quantity) -
          product.AutomaticDiscountValue;
    } else {
      return product.TotalLiquid;
    }
  }

  double getTotalCartPrice(String enterpriseCode) {
    double totalLiquid = 0;
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else {
      _cartProducts[enterpriseCode]!.forEach((element) {
        if (element.TotalLiquid == 0) {
          //só terá o valor do TotalLiquid no produto quando processar o
          //carrinho. Se fechar o app e abrir novamente, esse valor estará
          //zerado e por isso precisa calcular conforme o que já tiver no banco
          //de dados
          totalLiquid += (element.Value * element.Quantity) -
              element.AutomaticDiscountValue;
        } else {
          totalLiquid += element.TotalLiquid;
        }
      });

      return totalLiquid;
    }
  }

  Map<String, dynamic> _jsonSaleRequest = {
    "crossId": UserData.crossIdentity,
    "EnterpriseCode": 0,
    "RequestTypeCode": 0,
    "SellerCode": 0,
    "CovenantCode": 0,
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

    await _clearcustomers(enterpriseCode);
    clearProducts();
    await PrefsInstance.removeKey(PrefsKeys.cart);
    _updatedCart = true;

    await _getCustomersOldSearch(
      searchTypeInt: 2, //exactCode
      controllerText: "-1", //consumidor
      enterpriseCode: enterpriseCode,
    );

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

  String getDiscountDescription(
    SaleRequestCartProductsModel saleRequestCartProductsModel,
  ) {
    String discountDescription = "";
    _jsonSaleRequest["Products"].forEach((element) {
      if (element.ProductPackingCode ==
          saleRequestCartProductsModel.ProductPackingCode) {
        discountDescription = element.DiscountDescription;
      }
    });

    return discountDescription;
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

  Future<void> getRequests({
    required int enterpriseCode,
    required BuildContext context,
    bool? isConsultingAgain = false,
  }) async {
    if (_isLoadingRequests) return;
    _isLoadingRequests = true;
    _errorMessageRequests = "";
    _requests.clear();

    if (isConsultingAgain!) notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "simpleSearchValue": "",
          "enterpriseCode": enterpriseCode,
          "inclusiveTransfer": false,
          "inclusiveBuy": false,
          "inclusiveSale": true,
        },
        typeOfResponse: "GetRequestTypesJsonResponse",
        SOAPAction: "GetRequestTypesJson",
        serviceASMX: "CeltaRequestTypeService.asmx",
        typeOfResult: "GetRequestTypesJsonResult",
      );

      _errorMessageRequests = SoapRequestResponse.errorMessage;

      if (_errorMessageRequests == "") {
        SaleRequestsModel.responseAsStringToSaleRequestsModel(
          responseAsString: SoapRequestResponse.responseAsString,
          listToAdd: _requests,
        );
      }
    } catch (e) {
      //print("Erro para obter os modelos de pedido: $e");
      _errorMessageRequests = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }

    _isLoadingRequests = false;
    notifyListeners();
  }

  Future<void> processCart({
    required BuildContext context,
    required int enterpriseCode,
    required int requestTypeCode,
    required int customerCode,
    required int covenantCode,
  }) async {
    _isLoadingProcessCart = true;
    _errorMessageProcessCart = "";
    notifyListeners();

    try {
      List processCartItems =
          SaleRequestProcessCartModel.cartProductsToProcessCart(
        _cartProducts[enterpriseCode.toString()]!,
      );

      var jsonBody = json.encode({
        "crossId": UserData.crossIdentity,
        "EnterpriseCode": enterpriseCode,
        "RequestTypeCode": requestTypeCode,
        "CovenantCode": covenantCode,
        "CustomerCode": customerCode,
        "Products": processCartItems,
      }
          //   // 'SellerCode: 1,' //não possui opção para consulta de vendedor no aplicativo. Ele retorna o código de acordo com o funcionário vinculado ao usuário logado, por isso não precisa enviar essa informação. O próprio backend vai verificar qual é o vendedor vinculado ao usuário e retornar o código dele
          );

      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "json": jsonBody,
        },
        typeOfResponse: "ProcessCartResponse",
        SOAPAction: "ProcessCart",
        serviceASMX: "CeltaSaleRequestService.asmx",
        typeOfResult: "ProcessCartResult",
      );

      _errorMessageProcessCart = SoapRequestResponse.errorMessage;

      if (_errorMessageProcessCart == "") {
        SaleRequestProcessCartModel.updateCartWithProcessCartResponse(
          jsonSaleRequest: _jsonSaleRequest,
          apiItemsResponse: SoapRequestResponse.responseAsString,
          enterpriseCode: enterpriseCode.toString(),
          cartProducts: _cartProducts[enterpriseCode.toString()]!,
        );

        _updatedCart = false;
      } else {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageProcessCart,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para obter os preços do carrinho: $e");
      ShowSnackbarMessage.showMessage(
        message: _errorMessageProcessCart,
        context: context,
      );
    }

    _isLoadingProcessCart = false;
    notifyListeners();
  }

  void updateSelectedCustomer({
    required int index,
    required bool value,
    required String enterpriseCode,
  }) async {
    _customers[enterpriseCode]?.forEach((element) {
      element.selected = false;
    });
    _customers[enterpriseCode]?[index].selected = value;

    _updatedCart = true;

    _customers[enterpriseCode]?.forEach((element) {
      element.Covenants.forEach((element) {
        element.selected =
            false; //tira a seleção de todos convênios se alterar o cleinte selecionado
      });
    });
    await _updateCustomerInDatabase();
    notifyListeners();
  }

  void updateSelectedCovenant({
    required String enterpriseCode,
    required int indexOfCustomer,
    required int indexOfCovenants,
    required bool isSelected,
  }) {
    _customers[enterpriseCode]?[indexOfCustomer].Covenants.forEach((element) {
      element.selected = false;
    });

    _customers[enterpriseCode]?[indexOfCustomer]
        .Covenants[indexOfCovenants]
        .selected = isSelected;

    _updateCustomerInDatabase();

    _updatedCart = true;
  }

  Future<void> getCustomers({
    required BuildContext context,
    required String controllerText,
    required String enterpriseCode,
    required ConfigurationsProvider configurationsProvider,
    bool? searchOnlyDefaultCustomer = false,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode

    await _clearcustomers(enterpriseCode);

    await _getCustomersOldSearch(
      searchTypeInt: 2, //exactCode
      controllerText: "-1", //consumidor
      enterpriseCode: enterpriseCode,
    );

    if (_customers.isNotEmpty && controllerText == "-1") {
      //como está consultando o cliente consumidor, não precisa continuar pois já foi pesquisado
      return;
    }

    if (searchOnlyDefaultCustomer!) {
      return;
    }

    int? codeValue = int.tryParse(controllerText);
    if (codeValue == null) {
      await _getCustomersOldSearch(
        searchTypeInt: 3, //ApproximateName
        controllerText: controllerText,
        enterpriseCode: enterpriseCode,
      );
    } else if (configurationsProvider.customerPersonalizedCode?.value == true) {
      await _getCustomersOldSearch(
        searchTypeInt: 4, //PersonalizedCode
        controllerText: controllerText,
        enterpriseCode: enterpriseCode,
      );
    } else if (CPFValidator.isValid(codeValue.toString())) {
      await _getCustomersOldSearch(
        searchTypeInt: 1, //ExactCnpjCpfNumber
        controllerText: controllerText,
        enterpriseCode: enterpriseCode,
      );
    } else {
      await _getCustomersOldSearch(
        searchTypeInt: 2, //exactCode
        controllerText: controllerText,
        enterpriseCode: enterpriseCode,
      );
    }
  }

  Future<void> _getCustomersOldSearch({
    required int searchTypeInt,
    required String controllerText,
    required String enterpriseCode,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode

    _errorMessageCustomer = "";
    _isLoadingCustomer = true;
    notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "customerData": controllerText,
          "customerDataType": searchTypeInt,
        },
        typeOfResponse: "GetCustomerJsonResponse",
        SOAPAction: "GetCustomerJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCustomerJsonResult",
      );

      _errorMessageCustomer = SoapRequestResponse.errorMessage;
      if (_errorMessageCustomer ==
          "O formato dos filtros informado está inválido") {
        await _getCustomersNewSearch(
          searchTypeInt: searchTypeInt,
          controllerText: controllerText,
          enterpriseCode: enterpriseCode,
        );
      }
      if (_errorMessageCustomer == "") {
        if (_customers[enterpriseCode] == null) {
          _customers[enterpriseCode] = [];
        }

        SaleRequestCustomerModel.responseAsStringToSaleRequestCustomerModel(
          responseAsString: SoapRequestResponse.responseAsString,
          listToAdd: _customers[enterpriseCode]!,
        );
      }

      await _updateCustomerInDatabase();
    } catch (e) {
      //print("Erro para obter os clientes: $e");
      _errorMessageCustomer = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingCustomer = false;
      notifyListeners();
    }
  }

  Future<void> _getCustomersNewSearch({
    required int searchTypeInt,
    required String controllerText,
    required String enterpriseCode,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
// 4=PersonalizedCode

    _errorMessageCustomer = "";

    try {
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode({
            "crossIdentity": UserData.crossIdentity,
            "customerData": controllerText,
            "customerDataType": searchTypeInt,
            "enterpriseCode": enterpriseCode,
          }),
        },
        typeOfResponse: "GetCustomerJsonResponse",
        SOAPAction: "GetCustomerJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCustomerJsonResult",
      );

      _errorMessageCustomer = SoapRequestResponse.errorMessage;
    } catch (e) {
      throw Exception();
    }
  }

  Future<void> getProducts({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    required ConfigurationsProvider configurationsProvider,
    required int requestTypeCode,
  }) async {
    _products.clear();
    _errorMessageProducts = "";
    _isLoadingProducts = true;
    notifyListeners();

    Map jsonGetProducts = {
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": controllerText,
      "RequestTypeCode": requestTypeCode,
      "EnterpriseCodes": [enterpriseCode],
      "SearchTypeInt": SoapHelper.getSearchTypeInt(configurationsProvider),
      "RoutineInt": 1,
      // "SupplierCode": _selectedSupplier!.Code,
      // "EnterpriseDestinyCode": 0,
      // "SearchType": 0,
      // "Routine": 0,
    };

    try {
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(jsonGetProducts),
        },
        typeOfResponse: "GetProductsJsonResponse",
        SOAPAction: "GetProductsJson",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductsJsonResult",
      );

      _errorMessageProducts = SoapRequestResponse.errorMessage;
      if (_errorMessageProducts == "") {
        SaleRequestProductsModel.responseAsStringToSaleRequestProductsModel(
          responseAsString: SoapRequestResponse.responseAsString,
          listToAdd: _products,
        );
      }
    } catch (e) {
      //print("Erro para obter os produtos: $e");
      _errorMessageProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> saveSaleRequest({
    required String enterpriseCode,
    required int requestTypeCode,
    required BuildContext context,
  }) async {
    _errorMessageSaveSaleRequest = "";
    _isLoadingSaveSaleRequest = true;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.saleRequestSave,
    );

    _jsonSaleRequest["crossId"] = "${UserData.crossIdentity}";
    var jsonSaleRequestEncoded = json.encode(_jsonSaleRequest);
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "json": jsonSaleRequestEncoded,
          "printerName": "",
        },
        typeOfResponse: "InsertResponse",
        SOAPAction: "Insert",
        serviceASMX: "CeltaSaleRequestService.asmx",
      );

      _errorMessageSaveSaleRequest = SoapRequestResponse.errorMessage;

      if (_errorMessageSaveSaleRequest == "") {
        ShowSnackbarMessage.showMessage(
          message: "O pedido foi salvo com sucesso!",
          context: context,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );

        RegExp regex = RegExp(
            r'\((.*?)\)'); // Expressão regular para capturar o conteúdo entre parênteses

        Match? match = regex.firstMatch(SoapRequestResponse
            .responseAsString); // Encontrar o primeiro match na string
        SoapRequestResponse.responseAsMap;
        SoapRequestResponse.responseAsString;
        if (match != null) {
          _lastSaleRequestSaved = "Último pedido salvo: " + match.group(1)!;
        } else {
          //print("Nenhum conteúdo entre parênteses encontrado.");
        }

        await clearCart(enterpriseCode);

        await _clearcustomers(enterpriseCode);
        await _getCustomersOldSearch(
          searchTypeInt: 2, //exactCode
          controllerText: "-1", //consumidor
          enterpriseCode: enterpriseCode,
        );
      } else {
        _isLoadingSaveSaleRequest = false;

        ShowSnackbarMessage.showMessage(
          message: _errorMessageSaveSaleRequest,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para salvar o pedido: $e");
      _errorMessageSaveSaleRequest =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageSaveSaleRequest,
        context: context,
      );
    } finally {
      _isLoadingSaveSaleRequest = false;
      notifyListeners();
    }
  }
}

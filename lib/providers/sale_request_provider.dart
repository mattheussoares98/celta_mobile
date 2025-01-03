import 'dart:convert';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/models.dart';

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

  bool _needProcessCart = true;
  bool get needProcessCart => _needProcessCart;
  set needProcessCart(bool) {
    _needProcessCart = true;
  }

  bool _isLoadingCustomer = false;
  bool get isLoadingCustomer => _isLoadingCustomer;
  String _errorMessageCustomer = "";
  String get errorMessageCustomer => _errorMessageCustomer;
  Map<String, List<SaleRequestCustomerModel>> _customers = {};
  Map<String, List<SaleRequestCustomerModel>> get customers => _customers;

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageProducts = "";
  String get errorMessageProducts => _errorMessageProducts;
  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => [..._products];
  int get productsCount => _products.length;
  var removedProduct;
  int? indexOfRemovedProduct;

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

  SaleRequestProcessCartModel? saleRequestProcessCart;

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

  Map<String, List<GetProductJsonModel>> _cartProducts = {};
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

    if (customers.isEmpty) {
      _customers.clear();
    } else {
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
    }
    notifyListeners();
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

  double getTotalItemValue({
    required GetProductJsonModel product,
    required TextEditingController? newQuantityController,
    required String enterpriseCode,
  }) {
    double totalQuantity = 1;

    if (newQuantityController != null &&
        newQuantityController.text.isNotEmpty) {
      totalQuantity = newQuantityController.text.toDouble();
    }

    totalQuantity += getTotalItensInCart(
      ProductPackingCode: product.productPackingCode!,
      enterpriseCode: enterpriseCode,
    );

    double practicedPrice = getPracticedPrice(
      quantityToAdd: totalQuantity,
      product: product,
      enterpriseCode: enterpriseCode,
    );

    return totalQuantity * practicedPrice;
  }

  double getNewPrice({
    required GetProductJsonModel product,
    required TextEditingController newQuantityController,
    required String enterpriseCode,
    TextEditingController? manualWrittedPriceController,
  }) {
    double quantityToAdd = newQuantityController.text.isEmpty
        ? 1
        : newQuantityController.text.toDouble();

    if (quantityToAdd <= 0) {
      quantityToAdd = 1;
    }

    if (manualWrittedPriceController != null &&
        manualWrittedPriceController.text.isNotEmpty &&
        manualWrittedPriceController.text.toDouble() > 0) {
      return quantityToAdd * manualWrittedPriceController.text.toDouble();
    }

    double price = getPracticedPrice(
      enterpriseCode: enterpriseCode,
      quantityToAdd: quantityToAdd,
      product: product,
    );

    return quantityToAdd * price;
  }

  double getPracticedPrice({
    required double quantityToAdd,
    required GetProductJsonModel product,
    required String enterpriseCode,
  }) {
    if (product.minimumWholeQuantity != null &&
        product.minimumWholeQuantity! > 0 &&
        product.wholePracticedPrice != null &&
        product.wholePracticedPrice! > 0 &&
        quantityToAdd >= product.minimumWholeQuantity!) {
      return product.wholePracticedPrice!;
    } else {
      return product.retailPracticedPrice!;
    }
  }

  // void _changeCursorToLastIndex(
  //     TextEditingController consultedProductController) {
  //   consultedProductController.selection = TextSelection.collapsed(
  //     offset: consultedProductController.text.length,
  //   );
  // }

  _updateCartInDatabase({bool updateToNeedProcessCartAgain = true}) async {
    await PrefsInstance.setObject(
      prefsKeys: PrefsKeys.cart,
      object: _cartProducts,
    );

    if (updateToNeedProcessCartAgain) {
      _needProcessCart = true;
    }
  }

  restoreProducts(String enterpriseCode) async {
    String cart = await PrefsInstance.getString(PrefsKeys.cart);

    if (cart.isEmpty) {
      _cartProducts.clear();
    } else {
      Map cartProductsInDatabase = jsonDecode(cart);

      List<GetProductJsonModel> cartProductsTemp = [];
      cartProductsInDatabase.forEach((key, value) {
        if (key == enterpriseCode) {
          value.forEach((element) {
            cartProductsTemp.add(GetProductJsonModel.fromJson(element));
          });
        }
      });

      _cartProducts[enterpriseCode] = cartProductsTemp;
    }
    notifyListeners();
  }

  void addProductInCart({
    required GetProductJsonModel product,
    required TextEditingController newQuantityController,
    required String enterpriseCode,
  }) async {
    double quantity = 1;

    if (newQuantityController.text.isNotEmpty) {
      quantity = newQuantityController.text.toDouble();
    }

    if (quantity <= 0) {
      quantity = 1;
    }

    final indexOfProductInCart =
        _cartProducts[enterpriseCode]?.indexWhere((e) => e.plu == product.plu);
    double? quantityInCart;
    if (indexOfProductInCart != null && indexOfProductInCart != -1) {
      quantityInCart =
          _cartProducts[enterpriseCode]![indexOfProductInCart].quantity;
    }

    final productPrice = getPracticedPrice(
      quantityToAdd:
          quantityInCart != null ? quantityInCart + quantity : quantity,
      product: product,
      enterpriseCode: enterpriseCode,
    );

    GetProductJsonModel cartProductsModel = GetProductJsonModel(
      productPackingCode: product.productPackingCode!,
      name: product.name!,
      quantity: quantity,
      value: productPrice,
      IncrementPercentageOrValue: "0.0",
      IncrementValue: 0.0,
      DiscountPercentageOrValue: "0.0",
      DiscountValue: 0.0,
      // expectedDeliveryDate: "\"${DateTime.now().toString()}\"",
      productCode: product.productCode!,
      plu: product.plu!,
      packingQuantity: product.packingQuantity ?? "0",
      retailPracticedPrice: product.retailPracticedPrice ?? 0,
      retailSalePrice: product.retailSalePrice ?? 0,
      retailOfferPrice: product.retailOfferPrice ?? 0,
      wholePracticedPrice: product.wholePracticedPrice ?? 0,
      wholeSalePrice: product.wholeSalePrice ?? 0,
      wholeOfferPrice: product.wholeOfferPrice ?? 0,
      eCommercePracticedPrice: product.eCommercePracticedPrice ?? 0,
      eCommerceSalePrice: product.eCommerceSalePrice ?? 0,
      eCommerceOfferPrice: product.eCommerceOfferPrice ?? 0,
      minimumWholeQuantity: product.minimumWholeQuantity ?? 0,
      storageAreaAddress: product.storageAreaAddress,
      stockByEnterpriseAssociateds: product.stockByEnterpriseAssociateds,
      alterationPriceForAllPackings: product.alterationPriceForAllPackings,
      balanceLabelQuantity: product.balanceLabelQuantity,
      balanceLabelType: product.balanceLabelType,
      enterpriseCode: product.enterpriseCode,
      fiscalCost: product.fiscalCost,
      fiscalLiquidCost: product.fiscalLiquidCost,
      inClass: product.inClass,
      isChildOfGrate: product.isChildOfGrate,
      isFatherOfGrate: product.isFatherOfGrate,
      lastBuyEntrance: product.lastBuyEntrance,
      liquidCost: product.liquidCost,
      liquidCostMidle: product.liquidCostMidle,
      markUpdateClassInAdjustSalePriceIndividual:
          product.markUpdateClassInAdjustSalePriceIndividual,
      operationalCost: product.operationalCost,
      pendantPrintLabel: product.pendantPrintLabel,
      priceCost: product.priceCost,
      realCost: product.realCost,
      realLiquidCost: product.realLiquidCost,
      replacementCost: product.replacementCost,
      replacementCostMidle: product.replacementCostMidle,
      stocks: product.stocks,
      AutomaticDiscountPercentageOrValue:
          product.AutomaticDiscountPercentageOrValue,
      AutomaticDiscountValue: product.AutomaticDiscountValue,
      TotalLiquid: product.TotalLiquid,
      valueTyped: product.valueTyped,
    );

    if (alreadyContainsProduct(
      ProductPackingCode: product.productPackingCode!,
      enterpriseCode: enterpriseCode,
    )) {
      int index = _cartProducts[enterpriseCode]!.indexWhere((element) =>
          element.productPackingCode == product.productPackingCode);

      _cartProducts[enterpriseCode]![index].quantity += quantity;
      _cartProducts[enterpriseCode]![index].value = productPrice;
    } else {
      if (_cartProducts[enterpriseCode.toString()] != null) {
        _cartProducts[enterpriseCode.toString()]?.add(cartProductsModel);
      } else {
        _cartProducts.putIfAbsent(
            enterpriseCode.toString(), () => [cartProductsModel]);
      }
    }

    newQuantityController.text = "";

    await _updateCartInDatabase();
    notifyListeners();
  }

  Future<void> updateProductFromCart({
    required double quantity,
    required double value,
    required String enterpriseCode,
    required int index,
    bool updateToNeedProcessCartAgain = true,
  }) async {
    _cartProducts[enterpriseCode]![index].TotalLiquid = quantity * value;
    _cartProducts[enterpriseCode]![index].quantity = quantity;
    _cartProducts[enterpriseCode]![index].value = value;

    saleRequestProcessCart = SaleRequestProcessCartModel(
      crossId: UserData.crossIdentity,
      EnterpriseCode: saleRequestProcessCart?.EnterpriseCode,
      RequestTypeCode: saleRequestProcessCart?.RequestTypeCode,
      SellerCode: saleRequestProcessCart?.SellerCode,
      CovenantCode: saleRequestProcessCart?.CovenantCode,
      CustomerCode: saleRequestProcessCart?.CustomerCode,
      Products: _cartProducts[enterpriseCode]!
          .map((e) =>
              SaleRequestProductProcessCartModel.fromGetProductJsonModel(e))
          .toList(),
    );

    await _updateCartInDatabase(
      updateToNeedProcessCartAgain: updateToNeedProcessCartAgain,
    );
    notifyListeners();
  }

  double getTotalCartPrice(String enterpriseCode) {
    if (_cartProducts[enterpriseCode] == null) {
      return 0;
    } else {
      double totalLiquid = 0;
      _cartProducts[enterpriseCode]!.forEach((element) {
        if (element.TotalLiquid != null && element.TotalLiquid! > 0) {
          //só terá o valor do TotalLiquid no produto quando processar o
          //carrinho. Se fechar o app e abrir novamente, esse valor estará
          //zerado e por isso precisa calcular conforme o que já tiver no banco
          //de dados
          totalLiquid += element.TotalLiquid!;

          if (element.AutomaticDiscountValue != null &&
              element.AutomaticDiscountValue! > 0) {
            totalLiquid -= element.AutomaticDiscountValue!;
          }
        } else if (element.value != null && element.value! > 0) {
          double price = element.value! * element.quantity;
          totalLiquid += price;
          // print(totalLiquid);
        } else {
          //preço do produto está zerado, não deve somar
        }
      });
      return totalLiquid;
    }
  }

  void clearProducts() {
    _products.clear();
    notifyListeners();
  }

  Future<void> clearCart(String enterpriseCode) async {
    if (_cartProducts[enterpriseCode] != null) {
      _cartProducts[enterpriseCode]!.clear();
    }

    await _clearcustomers(enterpriseCode);
    clearProducts();
    await PrefsInstance.removeKey(PrefsKeys.cart);
    _needProcessCart = true;

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
        (element) => element.productPackingCode == ProductPackingCode);

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
        if (ProductPackingCode == element.productPackingCode) {
          alreadyContainsProduct = true;
        }
      });

      return alreadyContainsProduct;
    }
  }

  String? getDiscountDescription(
    GetProductJsonModel product,
  ) {
    return saleRequestProcessCart?.Products
        ?.where((e) => e.ProductPackingCode == product.productPackingCode)
        .first
        .DiscountDescription;
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
        if (element.productPackingCode == ProductPackingCode) {
          atualQuantity = element.quantity;
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
      _errorMessageRequests = DefaultErrorMessage.ERROR;
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
          SaleRequestProductProcessCartModel.cartProductsToProcessCart(
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
        saleRequestProcessCart = SaleRequestProcessCartModel.fromJson(
          json.decode(SoapRequestResponse.responseAsString),
        );

        _needProcessCart = false;
      } else {
        ShowSnackbarMessage.show(
          message: _errorMessageProcessCart,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para obter os preços do carrinho: $e");
      ShowSnackbarMessage.show(
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

    _needProcessCart = true;

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

    _needProcessCart = true;
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
      _errorMessageCustomer = DefaultErrorMessage.ERROR;
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
    required EnterpriseModel enterprise,
    required String controllerText,
    required BuildContext context,
    required ConfigurationsProvider configurationsProvider,
    required int requestTypeCode,
  }) async {
    _products.clear();
    _errorMessageProducts = "";
    _isLoadingProducts = true;
    notifyListeners();

    try {
      _products = await SoapHelper.getProductsJsonModel(
        enterprise: enterprise,
        searchValue: controllerText,
        configurationsProvider: configurationsProvider,
        routineTypeInt: 1,
        enterprisesCodes: [enterprise.Code],
      );

      _errorMessageProducts = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para obter os produtos: $e");
      _errorMessageProducts = DefaultErrorMessage.ERROR;
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> saveSaleRequest({
    required String enterpriseCode,
    required int requestTypeCode,
    required BuildContext context,
    required String instructions,
    required String observations,
  }) async {
    _errorMessageSaveSaleRequest = "";
    _isLoadingSaveSaleRequest = true;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.saleRequestSave,
    );
//TODO afeter my brother treats save products with different prices, test if works using a user that has permission to change prices, and a user that dont have permission to change prices
    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "json": json.encode(saleRequestProcessCart?.toJson()),
          "printerName": "",
        },
        typeOfResponse: "InsertResponse",
        SOAPAction: "Insert",
        serviceASMX: "CeltaSaleRequestService.asmx",
      );

      _errorMessageSaveSaleRequest = SoapRequestResponse.errorMessage;

      if (_errorMessageSaveSaleRequest == "") {
        ShowSnackbarMessage.show(
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

        ShowSnackbarMessage.show(
          message: _errorMessageSaveSaleRequest,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para salvar o pedido: $e");
      _errorMessageSaveSaleRequest = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageSaveSaleRequest,
        context: context,
      );
    } finally {
      _isLoadingSaveSaleRequest = false;
      notifyListeners();
    }
  }
}

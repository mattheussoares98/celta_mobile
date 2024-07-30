import 'dart:convert';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/buy_request/buy_request.dart';
import '../utils/utils.dart';
import './providers.dart';

class BuyRequestProvider with ChangeNotifier {
  List<BuyRequestProductsModel> _products = [];
  List<BuyRequestProductsModel> get products => [..._products];
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageGetProducts = "";
  String get errorMessageGetProducts => _errorMessageGetProducts;
  int get productsCount => _products.length;

  List<BuyRequestBuyerModel> _buyers = [];
  List<BuyRequestBuyerModel> get buyers => [..._buyers];
  bool _isLoadingBuyer = false;
  bool get isLoadingBuyer => _isLoadingBuyer;
  String _errorMessageBuyer = "";
  String get errorMessageBuyer => _errorMessageBuyer;
  int get buyersCount => _buyers.length;
  static BuyRequestBuyerModel? _selectedBuyer;
  BuyRequestBuyerModel? get selectedBuyer => _selectedBuyer;
  set selectedBuyer(BuyRequestBuyerModel? value) {
    _selectedBuyer = value;
    notifyListeners();
    _updateDataInDatabase();
  }

  List<BuyRequestRequestsTypeModel> _requestsType = [];
  List<BuyRequestRequestsTypeModel> get requestsType => [..._requestsType];
  bool _isLoadingRequestsType = false;
  bool get isLoadingRequestsType => _isLoadingRequestsType;
  String _errorMessageRequestsType = "";
  String get errorMessageRequestsType => _errorMessageRequestsType;
  int get requestsTypeCount => _requestsType.length;
  static BuyRequestRequestsTypeModel? _selectedRequestModel;
  BuyRequestRequestsTypeModel? get selectedRequestModel =>
      _selectedRequestModel;
  set selectedRequestModel(BuyRequestRequestsTypeModel? value) {
    _selectedRequestModel = value;

    if (enterprisesCount > 0) {
      _clearProducts();
      _clearCartProducts();
      _clearEnterprisesAndSelectedEnterprises();
      _observationsController.text = "";
    }
    notifyListeners();
    _updateDataInDatabase();
  }

  List<BuyRequestSupplierModel> _suppliers = [];
  List<BuyRequestSupplierModel> get suppliers => [..._suppliers];
  bool _isLoadingSupplier = false;
  bool get isLoadingSupplier => _isLoadingSupplier;
  String _errorMessageSupplier = "";
  String get errorMessageSupplier => _errorMessageSupplier;
  int get suppliersCount => _suppliers.length;
  static BuyRequestSupplierModel? _selectedSupplier;
  BuyRequestSupplierModel? get selectedSupplier => _selectedSupplier;
  set selectedSupplier(BuyRequestSupplierModel? value) {
    _selectedSupplier = value;

    _clearEnterprisesAndSelectedEnterprises();
    _clearProducts();
    _clearCartProducts();
    _observationsController.text = "";
    notifyListeners();
    _updateDataInDatabase();
  }

  static List<BuyRequestEnterpriseModel> _enterprises = [];
  static List<BuyRequestEnterpriseSelectedModel> _enterprisesSelecteds = [];
  List<BuyRequestEnterpriseModel> get enterprises => [..._enterprises];
  bool _isLoadingEnterprises = false;
  bool get isLoadingEnterprises => _isLoadingEnterprises;
  String _errorMessageEnterprises = "";
  String get errorMessageEnterprises => _errorMessageEnterprises;
  int get enterprisesCount => _enterprises.length;
  bool get hasSelectedEnterprise {
    bool hasSelectedEnterprise = false;
    for (var index = 0; index < _enterprises.length; index++) {
      if (_enterprises[index].selected) {
        hasSelectedEnterprise = true;
        break;
      }
    }
    return hasSelectedEnterprise;
  }

  bool _isLoadingInsertBuyRequest = false;
  bool get isLoadingInsertBuyRequest => _isLoadingInsertBuyRequest;
  String _errorMessageInsertBuyRequest = "";
  String get errorMessageInsertBuyRequest => _errorMessageInsertBuyRequest;

  static List<BuyRequestProductsModel> _productsInCart = [];
  List<BuyRequestProductsModel> get productsInCart => [..._productsInCart];
  int get productsInCartCount => _productsInCart.length;

  static TextEditingController _observationsController =
      TextEditingController();
  TextEditingController get observationsController => _observationsController;
  void updateObservationsControllerText(String newValue) {
    _observationsController.text = newValue;
    _updateDataInDatabase();
    notifyListeners();
  }

  FocusNode focusNodeConsultProduct = FocusNode();
  FocusNode quantityFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();
  int indexOfSelectedProduct = -1;
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final GlobalKey<FormState> insertQuantityFormKey = GlobalKey();

  String _lastRequestSavedNumber = "";
  String get lastRequestSavedNumber => _lastRequestSavedNumber;
  bool expandLastRequestSavedNumbers = false;

  Map<String, dynamic> _jsonBuyRequest = {
    "CrossIdentity": UserData.crossIdentity,
    "BuyerCode": _selectedBuyer?.Code ?? -1,
    "RequestTypeCode": _selectedRequestModel?.Code ?? -1,
    "SupplierCode": _selectedSupplier?.Code ?? -1,
    // "DateOfCreation": DateTime.now(),
    // "DateOfCreation": "2023-10-25T10:07:00",
    "Observations": _observationsController.text,
    "Enterprises": _enterprisesSelecteds.map((e) => e.toJson()).toList(),
    "Products": _productsInCart
        .map(
          (product) => BuyRequestCartProductModel(
            EnterpriseCode: product.EnterpriseCode,
            ProductPackingCode: product.ProductPackingCode,
            Value: product.Value,
            Quantity: product.quantity,
            IncrementPercentageOrValue: "R\$",
            IncrementValue: 0,
            DiscountPercentageOrValue: "R\$",
            DiscountValue: 0,
          ),
        )
        .toList(),
  };

  double get totalCartPrice {
    double total = _productsInCart.fold(0, (previousValue, product) {
      double productTotal = product.quantity * product.ValueTyped;
      return previousValue + productTotal;
    });

    return total;
  }

  Future<void> _updateDataInDatabase() async {
    var buyersJsonList = _buyers.map((buyer) => buyer.toJson()).toList();
    var suppliersJsonList =
        _suppliers.map((supplier) => supplier.toJson()).toList();
    var enterprisesJsonList =
        _enterprises.map((enterprise) => enterprise.toJson()).toList();
    var enterprisesSelectedsJsonList =
        _enterprisesSelecteds.map((enterprise) => enterprise.toJson()).toList();
    var cartProductsJsonList =
        _productsInCart.map((cartProduct) => cartProduct.toJson()).toList();
    var requestsTypesJsonList =
        _requestsType.map((requestsType) => requestsType.toJson()).toList();

    Map<String, dynamic> _json = {
      "buyers": buyersJsonList,
      "suppliers": suppliersJsonList,
      "enterprises": enterprisesJsonList,
      "enterprisesSelecteds": enterprisesSelectedsJsonList,
      "cartProducts": cartProductsJsonList,
      "requestsType": requestsTypesJsonList,
      "observations": observationsController.text,
      "selectedBuyer": _selectedBuyer?.toJson(),
      "selectedRequestModel": _selectedRequestModel?.toJson(),
      "selectedSupplier": _selectedSupplier?.toJson(),
      "lastRequestSavedNumber": _lastRequestSavedNumber,
    };

    await PrefsInstance.setObject(
      prefsKeys: PrefsKeys.buyRequest,
      object: _json,
    );
  }

  Future<void> restoreDataByDatabase() async {
    String buyRequestStringInDatabase = await PrefsInstance.getString(
      PrefsKeys.buyRequest,
    );

    if (buyRequestStringInDatabase.isEmpty) {
      _requestsType.clear();
      _buyers.clear();
      _suppliers.clear();
      _enterprises.clear();
      _products.clear();
      _productsInCart.clear();
      _observationsController.clear();
      _selectedBuyer = null;
      _selectedRequestModel = null;
      _selectedSupplier = null;
      _lastRequestSavedNumber = "";
    } else {
      Map jsonInDatabase = {};
      jsonInDatabase = json.decode(buyRequestStringInDatabase);

      _restoreRequestTypeAndSelectedRequestType(jsonInDatabase);
      _restoreBuyersAndSelectedBuyer(jsonInDatabase);
      _restoreSuppliersAndSelectedSuppliers(jsonInDatabase);
      _restoreEnterprisesAndSelectedEnterprises(jsonInDatabase);
      _restoreCartProducts(jsonInDatabase);
      _restoreObservations(jsonInDatabase);
      _restoreLastRequestSavedNumber(jsonInDatabase);
    }

    notifyListeners();
  }

  _restoreBuyersAndSelectedBuyer(Map jsonInDatabase) {
    List<BuyRequestBuyerModel> buyersTemp = [];
    if (jsonInDatabase.containsKey("buyers")) {
      jsonInDatabase["buyers"].forEach((element) {
        buyersTemp.add(BuyRequestBuyerModel.fromJson(element));
      });
      _buyers = buyersTemp;
    }

    if (jsonInDatabase.containsKey("selectedBuyer") &&
        jsonInDatabase["selectedBuyer"] != null) {
      _selectedBuyer =
          BuyRequestBuyerModel.fromJson(jsonInDatabase["selectedBuyer"]);
    }
  }

  _restoreRequestTypeAndSelectedRequestType(Map jsonInDatabase) {
    List<BuyRequestRequestsTypeModel> requestsTypeTemp = [];
    if (jsonInDatabase.containsKey("requestsType")) {
      jsonInDatabase["requestsType"].forEach((element) {
        requestsTypeTemp.add(BuyRequestRequestsTypeModel.fromJson(element));
      });
      _requestsType = requestsTypeTemp;
    }

    if (jsonInDatabase.containsKey("selectedRequestModel") &&
        jsonInDatabase["selectedRequestModel"] != null) {
      _selectedRequestModel = BuyRequestRequestsTypeModel.fromJson(
          jsonInDatabase["selectedRequestModel"]);
    }
  }

  _restoreSuppliersAndSelectedSuppliers(Map jsonInDatabase) {
    List<BuyRequestSupplierModel> suppliersTemp = [];
    if (jsonInDatabase.containsKey("suppliers")) {
      jsonInDatabase["suppliers"].forEach((element) {
        suppliersTemp.add(BuyRequestSupplierModel.fromJson(element));
      });
      _suppliers = suppliersTemp;
    }

    if (jsonInDatabase.containsKey("selectedSupplier") &&
        jsonInDatabase["selectedSupplier"] != null) {
      _selectedSupplier =
          BuyRequestSupplierModel.fromJson(jsonInDatabase["selectedSupplier"]);
    }
  }

  _restoreEnterprisesAndSelectedEnterprises(Map jsonInDatabase) {
    List<BuyRequestEnterpriseModel> enterprisesTemp = [];

    if (jsonInDatabase.containsKey("enterprises")) {
      jsonInDatabase["enterprises"].forEach((element) {
        enterprisesTemp.add(BuyRequestEnterpriseModel.fromJson(element));
      });
      _enterprises = enterprisesTemp;
    }

    List<BuyRequestEnterpriseSelectedModel> enterprisesSelectedsTemp = [];

    if (jsonInDatabase.containsKey("enterprisesSelecteds")) {
      jsonInDatabase["enterprisesSelecteds"].forEach((element) {
        enterprisesSelectedsTemp
            .add(BuyRequestEnterpriseSelectedModel.fromJson(element));
      });
      _enterprisesSelecteds = enterprisesSelectedsTemp;
    }
  }

  _restoreCartProducts(Map jsonInDatabase) {
    List<BuyRequestProductsModel> cartProductsTemp = [];

    if (jsonInDatabase.containsKey("cartProducts")) {
      jsonInDatabase["cartProducts"].forEach((element) {
        cartProductsTemp.add(BuyRequestProductsModel.fromJson(element));
      });
      _productsInCart = cartProductsTemp;
    }
  }

  _restoreObservations(Map jsonInDatabase) {
    if (jsonInDatabase.containsKey("observations")) {
      _observationsController.text = jsonInDatabase["observations"];
    }
  }

  _restoreLastRequestSavedNumber(Map jsonInDatabase) {
    if (jsonInDatabase.containsKey("lastRequestSavedNumber")) {
      _lastRequestSavedNumber = jsonInDatabase["lastRequestSavedNumber"];
    }
  }

  bool _containsProductInSelectedEnterprise({
    required BuyRequestEnterpriseModel enterprise,
  }) {
    bool _containsProductWithTheEnterprise = false;
    if (enterprise.selected) {
      for (var x = 0; x < _productsInCart.length; x++) {
        if (_productsInCart[x].EnterpriseCode == enterprise.Code) {
          _containsProductWithTheEnterprise = true;
          break;
        }
      }
    }

    return _containsProductWithTheEnterprise;
  }

  void updateSelectedEnterprise({
    required BuyRequestEnterpriseModel enterprise,
    required BuildContext context,
  }) async {
    bool containsProductInSelectedEnterprise =
        _containsProductInSelectedEnterprise(
      enterprise: enterprise,
    );

    if (containsProductInSelectedEnterprise) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        subtitle:
            "Há produtos informados com a empresa que foi selecionada. Ao remover a seleção da empresa, os produtos dessa empresa serão removidos do pedido.\n\nDeseja realmente retirar a seleção da empresa?",
        title: "Remover produtos",
        function: () async {
          _updateSelectedEnterprise(enterprise);
          await _removeProductsByEnterpriseCode(enterprise.Code);
          await _updateDataInDatabase();
        },
      );
    } else {
      _updateSelectedEnterprise(enterprise);
      await _updateDataInDatabase();
    }

    notifyListeners();
  }

  _removeProductsByEnterpriseCode(int enterpriseCode) async {
    _productsInCart.removeWhere(
      (element) => element.EnterpriseCode == enterpriseCode,
    );
    _products.removeWhere(
      (element) => element.EnterpriseCode == enterpriseCode,
    );
    notifyListeners();
  }

  _updateSelectedEnterprise(BuyRequestEnterpriseModel enterprise) async {
    int indexOfEnterprise = _enterprises.indexOf(enterprise);

    if (indexOfEnterprise != -1) {
      _enterprises[indexOfEnterprise].selected =
          !_enterprises[indexOfEnterprise].selected;
    }

    int indexOfSelectedEnterprise = _enterprisesSelecteds
        .indexWhere((element) => element.EnterpriseCode == enterprise.Code);

    if (indexOfSelectedEnterprise == -1) {
      final selectedEnterprise = BuyRequestEnterpriseSelectedModel(
        IsPrincipal: _enterprisesSelecteds.isEmpty,
        EnterpriseCode: enterprise.Code,
      );

      _enterprisesSelecteds.add(selectedEnterprise);
    } else {
      _enterprisesSelecteds.removeAt(indexOfSelectedEnterprise);
      _removeProductsByEnterpriseCode(enterprise.Code);

      int indexOfPrincipalEnterprise = _enterprisesSelecteds
          .indexWhere((element) => element.IsPrincipal == true);

      if (indexOfPrincipalEnterprise == -1 &&
          _enterprisesSelecteds.length > 0) {
        //não há empresa principal, por isso precisa adicionar uma como principal
        _enterprisesSelecteds[0].IsPrincipal = true;
      }
    }
  }

  void _clearProducts() {
    _products.clear();
  }

  void _clearCartProducts() {
    _productsInCart.clear();
  }

  void _clearBuyers() {
    _buyers.clear();
    selectedBuyer = null;
  }

  void _clearRequestsType() {
    _requestsType.clear();
    selectedRequestModel = null;
  }

  void _clearSuppliers() {
    _suppliers.clear();
    selectedSupplier = null;
  }

  void _clearEnterprisesAndSelectedEnterprises() {
    _enterprises.clear();
    _enterprisesSelecteds.clear();
  }

  bool hasProductInCart(BuyRequestProductsModel product) {
    int index = _productsInCart.indexWhere((cartProduct) =>
        product.ProductPackingCode == cartProduct.ProductPackingCode &&
        product.EnterpriseCode == cartProduct.EnterpriseCode);

    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  void _updateProductWithProductCart() {
    if (productsInCartCount == 0) {
      return;
    }

    for (int i = 0; i < _products.length; i++) {
      for (int j = 0; j < _productsInCart.length; j++) {
        if (_products[i].ProductPackingCode ==
                _productsInCart[j].ProductPackingCode &&
            _products[i].EnterpriseCode == _productsInCart[j].EnterpriseCode) {
          _products[i].ValueTyped = _productsInCart[j].ValueTyped;
          _products[i].quantity = _productsInCart[j].quantity;

          break;
        }
      }
    }
    notifyListeners();
  }

  void changeSelectedRequestModel() async {
    _clearSuppliers();
    _clearEnterprisesAndSelectedEnterprises();
    _clearProducts();
    _clearCartProducts();
    await _updateDataInDatabase();
  }

  void orderUpByEnterprise() {
    _productsInCart
        .sort((a, b) => a.EnterpriseCode.compareTo(b.EnterpriseCode));

    notifyListeners();
  }

  void orderDownByEnterprise() {
    _productsInCart
        .sort((a, b) => b.EnterpriseCode.compareTo(a.EnterpriseCode));

    notifyListeners();
  }

  void _orderProductsUpByPlu() {
    _products.sort((a, b) => a.PLU.compareTo(b.PLU));
    notifyListeners();
  }

  void orderCartUpByName() {
    _productsInCart.sort((a, b) => a.Name.compareTo(b.Name));
    notifyListeners();
  }

  void orderCartDownByName() {
    _productsInCart.sort((a, b) => b.Name.compareTo(a.Name));
    notifyListeners();
  }

  void orderCartDownByTotalCost() {
    _productsInCart.sort((a, b) =>
        (b.ValueTyped * b.quantity).compareTo(a.ValueTyped * a.quantity));
    notifyListeners();
  }

  void orderCartUpByTotalCost() {
    _productsInCart.sort((a, b) =>
        (a.ValueTyped * a.quantity).compareTo(b.ValueTyped * b.quantity));
    notifyListeners();
  }

  Future<void> getProducts({
    required String searchValue,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    _products.clear();
    indexOfSelectedProduct = -1;
    priceController.text = "";
    quantityController.text = "";
    notifyListeners();

    try {
      await SoapHelper.getProductBuyRequest(
        searchValue: searchValue,
        configurationsProvider: configurationsProvider,
        selectedRequestModelCode: _selectedRequestModel!.Code,
        enterpriseCodes:
            _enterprisesSelecteds.map((e) => e.EnterpriseCode).toList(),
        selectedSupplierCode: _selectedSupplier!.Code,
        products: _products,
      );

      _errorMessageGetProducts = SoapRequestResponse.errorMessage;

      _updateProductWithProductCart();
      _orderProductsUpByPlu();
    } catch (e) {
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  Future<void> getBuyers({
    bool? isSearchingAgain = false,
    required BuildContext context,
  }) async {
    if (_isLoadingBuyer) return;

    _errorMessageBuyer = "";
    _isLoadingBuyer = true;
    _clearBuyers();
    if (isSearchingAgain!) notifyListeners();

    try {
      await SoapHelper.getBuyers(buyers: _buyers);

      _errorMessageBuyer = SoapRequestResponse.errorMessage;

      if (_errorMessageBuyer == "") {
        await _updateDataInDatabase();
      } else {
        ShowSnackbarMessage.showMessage(
          message:
              "Ocorreu um erro não esperado para consultar os compradores. Verifique a sua internet",
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para obter os compradores: $e");
      _errorMessageBuyer = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageBuyer,
        context: context,
      );
    }
    _isLoadingBuyer = false;
    notifyListeners();
  }

  Future<void> getRequestsType({
    bool? isSearchingAgain = false,
    required BuildContext context,
  }) async {
    if (_isLoadingRequestsType) return;

    _errorMessageRequestsType = "";
    _isLoadingRequestsType = true;
    _clearRequestsType();
    if (isSearchingAgain!) notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "inclusiveBuy": true,
          "inclusiveTransfer": false,
          "inclusiveSale": false,
          // "simpleSearchValue": "string",
          // "enterpriseCode": "int",
        },
        serviceASMX: "CeltaRequestTypeService.asmx",
        typeOfResponse: "GetRequestTypesJsonResponse",
        SOAPAction: "GetRequestTypesJson",
        typeOfResult: "GetRequestTypesJsonResult",
      );

      _errorMessageRequestsType = SoapRequestResponse.errorMessage;

      if (_errorMessageRequestsType == "") {
        BuyRequestRequestsTypeModel
            .responseAsStringToBuyRequestRequestsTypeModel(
          responseAsString: SoapRequestResponse.responseAsString,
          listToAdd: _requestsType,
        );
        await _updateDataInDatabase();
      } else {
        ShowSnackbarMessage.showMessage(
          message:
              "Ocorreu um erro não esperado para consultar os modelos de pedido. Verifique a sua internet",
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para obter os modelos de pedido: $e");
      _errorMessageRequestsType = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageRequestsType,
        context: context,
      );
    }
    _isLoadingRequestsType = false;
    notifyListeners();
  }

  Future<void> getSuppliers({
    required BuildContext context,
    required String searchValue,
  }) async {
    _errorMessageSupplier = "";
    _isLoadingSupplier = true;
    _clearSuppliers();
    notifyListeners();

    Map jsonGetSupplier = {
      "CrossIdentity": UserData.crossIdentity,
      "SearchValue": searchValue,
      "RoutineInt": 2,
      // "Routine": 0,
    };

    try {
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(jsonGetSupplier),
        },
        serviceASMX: "CeltaSupplierService.asmx",
        typeOfResponse: "GetSupplierJsonResponse",
        SOAPAction: "GetSupplierJson",
        typeOfResult: "GetSupplierJsonResult",
      );

      _errorMessageSupplier = SoapRequestResponse.errorMessage;

      if (_errorMessageSupplier == "") {
        BuyRequestSupplierModel.responseAsStringToBuyRequestSupplierModel(
          responseAsString: SoapRequestResponse.responseAsString,
          listToAdd: _suppliers,
        );
        await _updateDataInDatabase();
      }
    } catch (e) {
      //print("Erro para obter os fornecedores: $e");
      _errorMessageSupplier = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageSupplier,
        context: context,
      );
    }
    _isLoadingSupplier = false;
    notifyListeners();
  }

  Future<void> getEnterprises({
    required BuildContext context,
    bool isSearchingAgain = true,
  }) async {
    if (_isLoadingEnterprises) return;

    _errorMessageEnterprises = "";
    _isLoadingEnterprises = true;
    _clearEnterprisesAndSelectedEnterprises();
    _clearProducts();
    _clearCartProducts();
    if (isSearchingAgain) notifyListeners();

    Map jsonGetEnterprises = {
      "CrossIdentity": UserData.crossIdentity,
      "RoutineInt": 2,
      "SupplierCode": _selectedSupplier!.Code, //7
      "RequestTypeCode": _selectedRequestModel!.Code, //33
      // "SearchValue": "%",
      // "EnterpriseOriginCode": 0,
      // "Routine": 0,
    };

    try {
      await SoapRequest.soapPost(
        parameters: {
          "filters": json.encode(jsonGetEnterprises),
        },
        serviceASMX: "CeltaEnterpriseService.asmx",
        typeOfResponse: "GetEnterprisesJsonByFiltersResponse",
        SOAPAction: "GetEnterprisesJsonByFilters",
        typeOfResult: "GetEnterprisesJsonByFiltersResult",
      );

      _errorMessageEnterprises = SoapRequestResponse.errorMessage;

      if (_errorMessageEnterprises == "") {
        BuyRequestEnterpriseModel.responseAsStringToBuyRequestEnterpriseModel(
          responseAsString: SoapRequestResponse.responseAsString,
          listToAdd: _enterprises,
        );

        await _updateDataInDatabase();
      }
    } catch (e) {
      //print("Erro para obter as empresas: $e");
      _errorMessageEnterprises = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageEnterprises,
        context: context,
      );
    }
    _isLoadingEnterprises = false;
    notifyListeners();
  }

  void updateProductInCart({
    required BuyRequestProductsModel product,
  }) async {
    double price =
        double.parse(priceController.text.replaceAll(RegExp(r','), '.'));
    double quantity =
        double.parse(quantityController.text.replaceAll(RegExp(r','), '.'));

    product.quantity = quantity;
    product.ValueTyped = price;

    int indexOfCartProduct = _productsInCart.indexWhere((element) =>
        element.EnterpriseCode == product.EnterpriseCode &&
        element.ProductPackingCode == product.ProductPackingCode);

    if (indexOfCartProduct == -1) {
      _productsInCart.add(product);
    } else {
      _productsInCart[indexOfCartProduct] = product;
    }

    await _updateDataInDatabase();

    notifyListeners();
  }

  void removeProductFromCart(BuyRequestProductsModel product) async {
    int indexOfProduct = _products.indexWhere(
      (element) =>
          element.ProductPackingCode == product.ProductPackingCode &&
          element.EnterpriseCode == product.EnterpriseCode,
    );

    if (indexOfProduct != -1) {
      _products[indexOfProduct].ValueTyped = 0;
      _products[indexOfProduct].quantity = 0;
    }

    _productsInCart.removeWhere(
      (element) =>
          element.ProductPackingCode == product.ProductPackingCode &&
          element.EnterpriseCode == product.EnterpriseCode,
    );

    await _updateDataInDatabase();

    notifyListeners();
  }

  List<BuyRequestCartProductModel> convertToCartProductModels() {
    return _productsInCart
        .map((product) => BuyRequestCartProductModel(
              EnterpriseCode: product.EnterpriseCode,
              ProductPackingCode: product.ProductPackingCode,
              Value: product.Value,
              Quantity: product.quantity,
              IncrementPercentageOrValue:
                  "", // Coloque os valores apropriados aqui
              IncrementValue: 0.0, // Coloque os valores apropriados aqui
              DiscountPercentageOrValue:
                  "", // Coloque os valores apropriados aqui
              DiscountValue: 0.0, // Coloque os valores apropriados aqui
            ))
        .toList();
  }

  void _updateJsonBuyRequest() {
    _jsonBuyRequest["CrossIdentity"] = UserData.crossIdentity;
    _jsonBuyRequest["BuyerCode"] = _selectedBuyer?.Code ?? -1;
    _jsonBuyRequest["RequestTypeCode"] = _selectedRequestModel?.Code ?? -1;
    _jsonBuyRequest["SupplierCode"] = _selectedSupplier?.Code ?? -1;
    // "DateOfCreation": DateTime.now();
    // "DateOfCreation": "2023-10-25T10:07:00";
    _jsonBuyRequest["Observations"] = _observationsController.text;
    _jsonBuyRequest["Enterprises"] = _enterprisesSelecteds;
    _jsonBuyRequest["Products"] = _productsInCart
        .map((product) => BuyRequestCartProductModel(
              EnterpriseCode: product.EnterpriseCode,
              ProductPackingCode: product.ProductPackingCode,
              Value: product.ValueTyped,
              Quantity: product.quantity,
              IncrementPercentageOrValue: "R\$",
              IncrementValue: 0,
              DiscountPercentageOrValue: "R\$",
              DiscountValue: 0,
            ))
        .toList();
  }

  void clearAllData() {
    _clearBuyers();
    _clearRequestsType();
    _clearSuppliers();
    _clearEnterprisesAndSelectedEnterprises();
    _clearProducts();
    _clearCartProducts();
    _updateJsonBuyRequest();
    observationsController.text = "";
    notifyListeners();
  }

  _updateLastRequestNumber() {
    RegExp regex = RegExp(r'\(([\d\s\|]+)\)');

    // Encontre correspondências na string
    Iterable<RegExpMatch> matches =
        regex.allMatches(SoapRequestResponse.responseAsString);

    _lastRequestSavedNumber = matches.first.group(1).toString();
    expandLastRequestSavedNumbers = true;
  }

  Future<void> insertBuyRequest(BuildContext context) async {
    _isLoadingInsertBuyRequest = true;
    notifyListeners();

    _updateJsonBuyRequest();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "json": '${json.encode(_jsonBuyRequest)}',
        },
        serviceASMX: "CeltaBuyRequestService.asmx",
        typeOfResponse: "InsertResponse",
        SOAPAction: "Insert",
        typeOfResult: "InsertResult",
      );

      _errorMessageInsertBuyRequest = SoapRequestResponse.errorMessage;

      if (_errorMessageInsertBuyRequest != "") {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageInsertBuyRequest,
          context: context,
        );
        _lastRequestSavedNumber = "";
        expandLastRequestSavedNumbers = false;
      } else {
        _updateLastRequestNumber();
        ShowSnackbarMessage.showMessage(
          message: SoapRequestResponse.responseAsString,
          context: context,
          backgroundColor: Theme.of(context).colorScheme.primary,
        );
        clearAllData();
        await _updateDataInDatabase();
        FirebaseHelper.addSoapCallInFirebase(
            firebaseCallEnum: FirebaseCallEnum.buyRequestSave);
      }
    } catch (e) {
      //print("Erro para salvar o pedido: $e");
      _errorMessageInsertBuyRequest =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageInsertBuyRequest,
        context: context,
      );
    }

    _isLoadingInsertBuyRequest = false;
    notifyListeners();
  }
}

import 'package:celta_inventario/Models/inventory/inventory_model.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/api/firebase_helper.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:celta_inventario/api/soap_helper.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:flutter/cupertino.dart';
import '../Models/inventory/countings_model.dart';
import '../Models/inventory/inventory_product_model.dart';

class InventoryProvider with ChangeNotifier {
  final List<InventoryModel> _inventorys = [];
  List<InventoryModel> get inventorys => [..._inventorys];
  int get inventoryCount => _inventorys.length;
  bool _isLoadingInventorys = false;
  bool get isLoadingInventorys => _isLoadingInventorys;
  static String _errorMessageInventorys = '';
  String get errorMessage => _errorMessageInventorys;

  List<InventoryCountingsModel> _countings = [];

  List<InventoryCountingsModel> getCountings(int CodigoInterno_Inventario) {
    return _countings
        .where((counting) =>
            counting.codigoInternoInventario == CodigoInterno_Inventario)
        .toList();
  }

  int getCountingsQuantity(int CodigoInterno_Inventario) {
    return _countings
        .where((counting) =>
            counting.codigoInternoInventario == CodigoInterno_Inventario)
        .toList()
        .length;
  }

  static bool _isLoadingCountings = false;
  bool get isLoadingCountings => _isLoadingCountings;
  String _errorMessageCountings = "";
  String get errorMessageCountings => _errorMessageCountings;

  bool _isLoadingQuantity = false;
  bool get isLoadingQuantity => _isLoadingQuantity;
  String _errorMessageQuantity = '';
  String get errorMessageQuantity => _errorMessageQuantity;

  //criado somente pra conseguir identificar quando foi chamado o método de subtração
  //e atualizar corretamente a mensagem da última quantidade digitada

  bool _canChangeTheFocus = false;
  bool get canChangeTheFocus => _canChangeTheFocus;
  String _lastQuantityAdded = '';
  double get lastQuantityAdded {
    if (_lastQuantityAdded == "") {
      return 0;
    } else {
      return double.tryParse(_lastQuantityAdded)!;
    }
  }

  List<InventoryProductModel> _products = [];
  List<InventoryProductModel> get products => _products;
  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  int get productsCount => _products.length;
  String _errorMessageGetProducts = '';
  String get errorMessageGetProducts => _errorMessageGetProducts;
  FocusNode consultedProductFocusNode = FocusNode();
  FocusNode consultProductFocusNode = FocusNode();

  int _indexOfLastAddedQuantity = -1;
  int get indexOfLastAddedQuantity => _indexOfLastAddedQuantity;

  bool _useLegacyCode = false;
  bool get useLegacyCode => _useLegacyCode;
  bool _useAutoScan = false;
  bool get useAutoScan => _useAutoScan;

  void changeAutoScanValue() {
    _useAutoScan = !_useAutoScan;
    notifyListeners();
  }

  void changeLegacyCodeValue() {
    _useLegacyCode = !_useLegacyCode;
    notifyListeners();
  }

  Future<void> getInventory({
    required int enterpriseCode,
    required String? userIdentity,
  }) async {
    _isLoadingInventorys = true;
    _inventorys.clear();
    _errorMessageInventorys = '';
    _countings.clear();
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
        },
        typeOfResponse: "GetFrozenProcessesResponse",
        SOAPAction: "GetFrozenProcesses",
        serviceASMX: "CeltaInventoryService.asmx",
        typeOfResult: "GetFrozenProcessesResult",
      );
      _errorMessageInventorys = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageInventorys == "") {
        InventoryModel.responseAsStringToInventoryModel(
          data: SoapHelperResponseParameters.responseAsMap["Inventarios"],
          listToAdd: _inventorys,
        );

        InventoryCountingsModel.responseInStringToInventoryCountingsModel(
          data: SoapHelperResponseParameters
              .responseAsMap["InventariosContagens"],
          listToAdd: _countings,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageInventorys = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingInventorys = false;
    }

    notifyListeners();
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required int inventoryCountingCode,
    required int inventoryProcessCode,
    required String controllerText, //em string pq vem de um texfFormField
    required BuildContext context,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    _indexOfLastAddedQuantity = -1;
    notifyListeners();
    dynamic value = int.tryParse(controllerText);
    //o valor pode ser em inteiro ou em texto
    if (value == null) {
      //retorna nulo quando não consegue converter para inteiro. Se não
      //conseguir converter precisa consultar por nome, por isso pode usar o
      //próprio texto do "controllerText"
      value = controllerText;
    }

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
          "searchValue": controllerText,
          "searchTypeInt": _useLegacyCode ? 11 : 0,
          "inventoryProcessCode": inventoryProcessCode,
          "inventoryCountingCode": inventoryCountingCode,
        },
        typeOfResponse: "GetProductResponse",
        SOAPAction: "GetProduct",
        serviceASMX: "CeltaInventoryService.asmx",
        typeOfResult: "GetProductResult",
      );

      _errorMessageGetProducts = SoapHelperResponseParameters.errorMessage;
      if (_errorMessageGetProducts == "") {
        InventoryProductModel.responseInStringToInventoryProductModel(
          data: SoapHelperResponseParameters.responseAsMap["Produtos"],
          listToAdd: _products,
        );

        Future.delayed(const Duration(milliseconds: 100), () {
          //se não colocar em um future pra mudar o foco, não funciona corretamente
          FocusScope.of(context).requestFocus(consultedProductFocusNode);
          //altera o foco para o campo de pesquisa novamente
        });
      }
    } catch (e) {
      print("Erro para efetuar a requisição : $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required int enterpriseCode,
    required int inventoryProcessCode,
    required BuildContext context,
    required bool isIndividual,
    required TextEditingController consultProductController,
    required int inventoryCountingCode,
  }) async {
    if (consultProductController.text.isEmpty) {
      //se não digitar o ean ou plu, vai abrir a câmera
      consultProductController.text = await ScanBarCode.scanBarcode();
    }

    if (consultProductController.text.isEmpty) return;

    await _getProducts(
      controllerText: consultProductController.text,
      enterpriseCode: enterpriseCode,
      context: context,
      inventoryCountingCode: inventoryCountingCode,
      inventoryProcessCode: inventoryProcessCode,
    );

    if (_errorMessageGetProducts != '') {
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    }
  }

  alterFocusToConsultedProduct({
    required BuildContext context,
  }) {
    Future.delayed(const Duration(milliseconds: 400), () {
      //se não colocar em um future, da erro pra alterar o foco porque tenta trocar enquanto o campo está desabilitado
      FocusScope.of(context).requestFocus(consultedProductFocusNode);
    });
  }

  alterFocusToConsultProduct({
    required BuildContext context,
  }) {
    Future.delayed(const Duration(milliseconds: 300), () {
      //se não colocar em um future pra mudar o foco, não funciona corretamente
      FocusScope.of(context).requestFocus(consultProductFocusNode);
    });
  }

  Future<void> _entryQuantity({
    required int countingCode,
    required int productPackingCode,
    required String quantity,
    required bool isSubtract,
    required BuildContext context,
    required int indexOfProduct,
  }) async {
    quantity = quantity.replaceAll(RegExp(r','), '.');
    double newQuantity = double.parse(quantity);

    if (isSubtract &&
        newQuantity > _products[indexOfProduct].quantidadeInvContProEmb) {
      _errorMessageQuantity = "A quantidade não pode ficar negativa!";
      ShowSnackbarMessage.showMessage(
        message: _errorMessageQuantity,
        context: context,
      );
      return;
    }
    if (isSubtract) {
      newQuantity = newQuantity - (newQuantity * 2);
    }

    _isLoadingQuantity = true;
    _errorMessageQuantity = '';
    _canChangeTheFocus = false;
    _indexOfLastAddedQuantity = -1;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.inventoryEntryQuantity,
    );

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "countingCode": countingCode,
          "productPackingCode": productPackingCode,
          "quantity": newQuantity,
        },
        typeOfResponse: "EntryQuantityResponse",
        SOAPAction: "EntryQuantity",
        serviceASMX: "CeltaInventoryService.asmx",
      );

      _errorMessageQuantity = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageQuantity == "") {
        if (isSubtract) {
          _lastQuantityAdded = "-$quantity";
        } else {
          _lastQuantityAdded = quantity;
        }

        _indexOfLastAddedQuantity = indexOfProduct;

        _updateLastQuantity(
          quantity: newQuantity,
          indexOfProduct: indexOfProduct,
        );

        if (!_useAutoScan) {
          alterFocusToConsultedProduct(
            context: context,
          );
        }
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageQuantity,
        context: context,
      );
    }
    _isLoadingQuantity = false;
    _canChangeTheFocus = true;
    notifyListeners();
  }

  Future<void> anullQuantity({
    required int inventoryProcessCode,
    required int productPackingCode,
    required BuildContext context,
    required int indexOfProduct,
  }) async {
    _errorMessageQuantity = '';
    _isLoadingQuantity = true;
    _lastQuantityAdded = '';
    _indexOfLastAddedQuantity = -1;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.inventoryEntryQuantity,
    );

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "countingCode": inventoryProcessCode,
          "productPackingCode": productPackingCode,
        },
        typeOfResponse: "AnnulQuantityResponse",
        SOAPAction: "AnnulQuantity",
        serviceASMX: "CeltaInventoryService.asmx",
      );

      _errorMessageQuantity = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageQuantity == "") {
        _products[indexOfProduct].quantidadeInvContProEmb = -1;
      } else {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageQuantity,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageQuantity,
        context: context,
      );
      _lastQuantityAdded = '';
    }

    _isLoadingQuantity = false;
    print(_lastQuantityAdded);
    notifyListeners();
  }

  _updateLastQuantity({
    required double quantity,
    required int indexOfProduct,
  }) {
    if (_products[indexOfProduct].quantidadeInvContProEmb == -1) {
      _products[indexOfProduct].quantidadeInvContProEmb = 0;
    }
    _products[indexOfProduct].quantidadeInvContProEmb += quantity;

    notifyListeners();
  }

  addQuantity({
    required bool isIndividual,
    required BuildContext context,
    required int countingCode,
    required bool isSubtract,
    required TextEditingController consultedProductController,
    required int indexOfProduct,
  }) async {
    _isLoadingQuantity = true;
    notifyListeners();

    double quantity = 1;
    if (consultedProductController.text.isNotEmpty && !isIndividual) {
      quantity = double.tryParse(
          consultedProductController.text.replaceAll(RegExp(r','), '.'))!;
    }

    try {
      await _entryQuantity(
        indexOfProduct: indexOfProduct,
        countingCode: countingCode,
        productPackingCode: _products[indexOfProduct].codigoInternoProEmb,
        quantity: isIndividual ? '1' : quantity.toString(),
        isSubtract: isSubtract,
        context: context,
      );

      if (_errorMessageQuantity != "") {
        ShowSnackbarMessage.showMessage(
          message: _errorMessageQuantity,
          context: context,
        );
        return;
      }

      consultedProductController.text = "";
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowSnackbarMessage.showMessage(
        message: _errorMessageQuantity,
        context: context,
      );
    } finally {
      _isLoadingQuantity = false;
      notifyListeners();
    }
  }
}

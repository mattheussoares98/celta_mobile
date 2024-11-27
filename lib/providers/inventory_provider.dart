import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/enterprise/enterprise.dart';
import '../models/inventory/inventory.dart';
import '../utils/utils.dart';
import './providers.dart';

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

  Future<void> getInventory({
    required int enterpriseCode,
    required String? userIdentity,
    bool? isConsultingAgain = false,
  }) async {
    if (_isLoadingInventorys) return;

    _isLoadingInventorys = true;
    _inventorys.clear();
    _errorMessageInventorys = '';
    _countings.clear();

    if (isConsultingAgain!) notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
        },
        typeOfResponse: "GetFrozenProcessesResponse",
        SOAPAction: "GetFrozenProcesses",
        serviceASMX: "CeltaInventoryService.asmx",
        typeOfResult: "GetFrozenProcessesResult",
      );
      _errorMessageInventorys = SoapRequestResponse.errorMessage;

      if (_errorMessageInventorys == "") {
        InventoryModel.responseAsStringToInventoryModel(
          data: SoapRequestResponse.responseAsMap["Inventarios"],
          listToAdd: _inventorys,
        );

        InventoryCountingsModel.responseInStringToInventoryCountingsModel(
          data: SoapRequestResponse.responseAsMap["InventariosContagens"],
          listToAdd: _countings,
        );
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageInventorys = DefaultErrorMessage.ERROR;
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
    required EnterpriseModel enterprise,
    required int inventoryCountingCode,
    required int inventoryProcessCode,
    required String controllerText, //em string pq vem de um texfFormField
    required BuildContext context,
    required ConfigurationsProvider configurationsProvider,
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
      await SoapHelper.getProductInventory(
        enterprise: enterprise,
        searchValue: controllerText,
        configurationsProvider: configurationsProvider,
        inventoryProcessCode: inventoryProcessCode,
        inventoryCountingCode: inventoryCountingCode,
        products: _products,
      );

      _errorMessageGetProducts = SoapRequestResponse.errorMessage;
    } catch (e) {
      //print("Erro para efetuar a requisição : $e");
      _errorMessageGetProducts = DefaultErrorMessage.ERROR;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required EnterpriseModel enterprise,
    required int inventoryProcessCode,
    required BuildContext context,
    required bool isIndividual,
    required TextEditingController consultProductController,
    required int inventoryCountingCode,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    if (consultProductController.text.isEmpty) {
      //se não digitar o ean ou plu, vai abrir a câmera
      consultProductController.text = await ScanBarCode.scanBarcode(context);
    }

    if (consultProductController.text.isEmpty) return;

    await _getProducts(
      controllerText: consultProductController.text,
      enterprise: enterprise,
      context: context,
      inventoryCountingCode: inventoryCountingCode,
      inventoryProcessCode: inventoryProcessCode,
      configurationsProvider: configurationsProvider,
    );

    if (_errorMessageGetProducts != '' && !isIndividual && productsCount == 1) {
      alterFocusToConsultProduct(context: context);
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
    required ConfigurationsProvider configurationsProvider,
    required bool isIndividual,
  }) async {
    quantity = quantity.replaceAll(RegExp(r','), '.');
    double newQuantity = double.parse(quantity);

    if (isSubtract &&
        newQuantity > _products[indexOfProduct].quantidadeInvContProEmb) {
      _errorMessageQuantity = "A quantidade não pode ficar negativa!";
      ShowSnackbarMessage.show(
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
      await SoapRequest.soapPost(
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

      _errorMessageQuantity = SoapRequestResponse.errorMessage;

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

        if (configurationsProvider.autoScan?.value != true &&
            productsCount == 1 &&
            !isIndividual) {
          alterFocusToConsultedProduct(
            context: context,
          );
        }
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
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
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "countingCode": inventoryProcessCode,
          "productPackingCode": productPackingCode,
        },
        typeOfResponse: "AnnulQuantityResponse",
        SOAPAction: "AnnulQuantity",
        serviceASMX: "CeltaInventoryService.asmx",
      );

      _errorMessageQuantity = SoapRequestResponse.errorMessage;

      if (_errorMessageQuantity == "") {
        _products[indexOfProduct].quantidadeInvContProEmb = -1;
      } else {
        ShowSnackbarMessage.show(
          message: _errorMessageQuantity,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
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
    required ConfigurationsProvider configurationsProvider,
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
        configurationsProvider: configurationsProvider,
        isIndividual: isIndividual,
      );

      if (_errorMessageQuantity != "") {
        ShowSnackbarMessage.show(
          message: _errorMessageQuantity,
          context: context,
        );
        return;
      }

      consultedProductController.text = "";
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageQuantity,
        context: context,
      );
    } finally {
      _isLoadingQuantity = false;
      notifyListeners();
    }
  }
}

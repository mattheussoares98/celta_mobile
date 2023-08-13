import 'package:celta_inventario/Models/inventory/inventory_model.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/soap_helper.dart';
import 'package:flutter/cupertino.dart';
import '../Components/Global_widgets/show_error_message.dart';
import '../Models/inventory/countings_model.dart';
import '../Models/inventory/inventory_product_model.dart';
import '../utils/user_identity.dart';

class InventoryProvider with ChangeNotifier {
  final List<InventoryModel> _inventorys = [];
  List<InventoryModel> get inventorys => [..._inventorys];
  int get inventoryCount => _inventorys.length;
  bool _isLoadingInventorys = false;
  bool get isLoadingInventorys => _isLoadingInventorys;
  static String _errorMessageInventorys = '';
  String get errorMessage => _errorMessageInventorys;

  List<InventoryCountingsModel> _countings = [];
  List<InventoryCountingsModel> get countings => [..._countings];
  int get countingsQuantity => countings.length;
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
          "crossIdentity": UserIdentity.identity,
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
    required bool isLegacyCodeSearch,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    _indexOfLastAddedQuantity = -1;
    controllerText =
        ConvertString.convertToRemoveSpecialCaracters(controllerText);
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
          "crossIdentity": UserIdentity.identity,
          "enterpriseCode": enterpriseCode,
          "searchValue": controllerText,
          "searchTypeInt": isLegacyCodeSearch ? 11 : 0,
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

  Future<void> getProductsAndAddIfIsIndividual({
    required String controllerText,
    required int enterpriseCode,
    required int inventoryProcessCode,
    required BuildContext context,
    required bool isIndividual,
    required TextEditingController consultedProductController,
    required bool isLegacyCodeSearch,
    required int indexOfProduct,
    required int inventoryCountingCode,
  }) async {
    await _getProducts(
      controllerText: controllerText,
      enterpriseCode: enterpriseCode,
      context: context,
      isLegacyCodeSearch: isLegacyCodeSearch,
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

    if (_errorMessageGetProducts == '' && isIndividual && productsCount == 1) {
      //se estiver habilitado pra inserir individualmente e retornar somente um
      //produto, assim que efetuar a consulta do produto já vai tentar adicionar
      //uma unidade.

      await addQuantity(
        indexOfProduct: indexOfProduct,
        isIndividual: isIndividual,
        context: context,
        isSubtract: false,
        inventoryProcessCode: inventoryProcessCode,
        consultedProductController: consultedProductController,
      );
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
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageQuantity,
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

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
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
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageQuantity,
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

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
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
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageQuantity,
        context: context,
      );
      _lastQuantityAdded = '';
    }

    _isLoadingQuantity = false;
    print(_lastQuantityAdded);
    notifyListeners();
  }

  _updateLastQuantity({
    required bool isSubtract,
    required double quantity,
    required bool isIndividual,
    required int indexOfProduct,
  }) {
    if (!isIndividual &&
        _products[indexOfProduct].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      _products[indexOfProduct].quantidadeInvContProEmb =
          double.tryParse(quantity.toString().replaceAll(RegExp(r','), '.'))!;
    } else if (isIndividual &&
        _products[indexOfProduct].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      _products[indexOfProduct].quantidadeInvContProEmb = 1;
    } else if (isIndividual && isSubtract) {
      _products[indexOfProduct].quantidadeInvContProEmb--;
    } else if (isIndividual && !isSubtract) {
      _products[indexOfProduct].quantidadeInvContProEmb++;
    } else if (!isIndividual &&
        isSubtract &&
        (_products[indexOfProduct].quantidadeInvContProEmb - quantity) >= 0) {
      _products[indexOfProduct].quantidadeInvContProEmb -= quantity;
    } else {
      //se não for individual nem subtração, vai cair aqui
      //precisei sobrescrever a vírgula por ponto senão ocorria erro para somar/subtrair fracionado
      _products[indexOfProduct].quantidadeInvContProEmb +=
          double.tryParse(quantity.toString().replaceAll(RegExp(r','), '.'))!;
    }
  }

  addQuantity({
    required bool isIndividual,
    required BuildContext context,
    required int inventoryProcessCode,
    required bool isSubtract,
    required TextEditingController consultedProductController,
    required int indexOfProduct,
  }) async {
    double quantity = 0;
    if (consultedProductController.text.isNotEmpty && !isIndividual) {
      quantity = double.tryParse(
          consultedProductController.text.replaceAll(RegExp(r','), '.'))!;
    }

    try {
      await _entryQuantity(
        indexOfProduct: indexOfProduct,
        countingCode: inventoryProcessCode,
        productPackingCode: _products[indexOfProduct].codigoInternoProEmb,
        quantity: isIndividual ? '1' : quantity.toString(),
        isSubtract: isSubtract,
        context: context,
      );

      if (_errorMessageQuantity != "") {
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageQuantity,
          context: context,
        );
        return;
      }

      _updateLastQuantity(
        isSubtract: isSubtract,
        quantity: quantity,
        isIndividual: isIndividual,
        indexOfProduct: indexOfProduct,
      );

      if (!isIndividual) {
        alterFocusToConsultedProduct(
          context: context,
        );
      }

      consultedProductController.clear();
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageQuantity,
        context: context,
      );
    }
  }
}

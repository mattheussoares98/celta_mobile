import 'package:celta_inventario/Models/inventory/inventory_product_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum SearchTypes {
  GetProductByEAN,
  GetProductByPLU,
}

class InventoryProductProvider with ChangeNotifier {
  List<InventoryProductModel> _products = [];

  List<InventoryProductModel> get products {
    return _products;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  int get productsCount => _products.length;

  String _errorMessageGetProducts = '';

  get errorMessageGetProducts {
    return _errorMessageGetProducts;
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }

  Future<void> _getProducts({
    required String controllerText,
    required int enterpriseCode,
    required int inventoryProcessCode,
    required int inventoryCountingCode,
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    _products.clear();
    _errorMessageGetProducts = '';
    _isLoading = true;
    _lastQuantityAdded = "";
    controllerText = controllerText.replaceAll(RegExp(r'\%'), '\%25');

    notifyListeners();

    http.Request? request;

    if (isLegacyCodeSearch) {
      request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/Inventory/ProductByLegacyCode?searchValue=$controllerText&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
    } else {
      request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/Inventory/GetProduct?searchValue=$controllerText&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
    }

    try {
      var headers = {'Content-Type': 'application/json'};

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para NOVA consulta de produtos = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(responseInString)["Message"];
        _isLoading = false;
        notifyListeners();
        return;
      }

      InventoryProductModel.responseInStringToInventoryProductModel(
        responseInString: responseInString,
        listToAdd: _products,
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultedProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      _isLoading = false;
      notifyListeners();
    }

    if (products.isNotEmpty) {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> _getProductsOld({
    required String controllerText,
    required int enterpriseCode,
    required int inventoryProcessCode,
    required int inventoryCountingCode,
    required BuildContext context,
    required SearchTypes searchTypes,
  }) async {
    _products.clear();
    _errorMessageGetProducts = '';
    _isLoading = true;
    _lastQuantityAdded = "";
    controllerText = controllerText.replaceAll(RegExp(r'\%'), '\%25');

    notifyListeners();

    http.Request request;

    if (searchTypes == SearchTypes.GetProductByEAN) {
      request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}//Inventory/GetProductByEan?ean=$controllerText&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
    } else {
      request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/Inventory/GetProductByPlu?plu=$controllerText&enterpriseCode=$enterpriseCode&inventoryProcessCode=$inventoryProcessCode&inventoryCountingCode=$inventoryCountingCode'),
      );
    }

    try {
      var headers = {'Content-Type': 'application/json'};

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();

      print('resposta para consulta do $searchTypes = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(responseInString)["Message"];
        _isLoading = false;
        notifyListeners();
        return;
      }

      InventoryProductModel.responseInStringToInventoryProductModel(
        responseInString: responseInString,
        listToAdd: _products,
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultedProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      _isLoading = false;
      notifyListeners();
    }

    if (products.isNotEmpty) {
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> getProductsAndAddIfIsIndividual({
    required String controllerText,
    required int enterpriseCode,
    required int inventoryProcessCode,
    required int codigoInternoInvCont,
    required BuildContext context,
    required bool isIndividual,
    required TextEditingController consultedProductController,
    required bool isLegacyCodeSearch,
  }) async {
    await _getProducts(
      controllerText: controllerText,
      enterpriseCode: enterpriseCode,
      inventoryProcessCode: inventoryProcessCode,
      inventoryCountingCode: codigoInternoInvCont,
      context: context,
      isLegacyCodeSearch: isLegacyCodeSearch,
    );

    if (_products.isEmpty && _errorMessageGetProducts != "") {
      await _getProductsOld(
        controllerText: controllerText,
        enterpriseCode: enterpriseCode,
        inventoryProcessCode: inventoryProcessCode,
        inventoryCountingCode: codigoInternoInvCont,
        context: context,
        searchTypes: SearchTypes.GetProductByPLU,
      );

      if (_products.isEmpty) {
        await _getProductsOld(
          controllerText: controllerText,
          enterpriseCode: enterpriseCode,
          inventoryProcessCode: inventoryProcessCode,
          inventoryCountingCode: codigoInternoInvCont,
          context: context,
          searchTypes: SearchTypes.GetProductByEAN,
        );
      }
    }

    if (_errorMessageGetProducts != '') {
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    }

    if (_errorMessageGetProducts == '' && isIndividual) {
      //se estiver habilitado pra inserir individualmente, assim que efetuar a consulta do produto já vai tentar adicionar uma unidade

      await addQuantity(
        isIndividual: isIndividual,
        context: context,
        codigoInternoInvCont: codigoInternoInvCont,
        isSubtract: false,
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

  bool _isLoadingQuantity = false;

  bool get isLoadingQuantity {
    return _isLoadingQuantity;
  }

  String _errorMessageQuantity = '';

  String get errorMessageQuantity {
    return _errorMessageQuantity;
  }

  //criado somente pra conseguir identificar quando foi chamado o método de subtração
  //e atualizar corretamente a mensagem da última quantidade digitada

  bool _canChangeTheFocus = false;

  bool get canChangeTheFocus {
    return _canChangeTheFocus;
  }

  String _lastQuantityAdded = '';

  double get lastQuantityAdded {
    if (_lastQuantityAdded == "") {
      return 0;
    } else {
      return double.tryParse(_lastQuantityAdded)!;
    }
  }

  Future<void> _entryQuantity({
    required int countingCode,
    required int productPackingCode,
    required String quantity,
    required bool isSubtract,
    required BuildContext context,
  }) async {
    quantity = quantity.replaceAll(RegExp(r','), '.');
    if (isSubtract &&
        double.tryParse(quantity)! > _products[0].quantidadeInvContProEmb) {
      _errorMessageQuantity = "A quantidade não pode ficar negativa!";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageQuantity,
        context: context,
      );
      return;
    }
    _isLoadingQuantity = true;
    _errorMessageQuantity = '';
    _canChangeTheFocus = false;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          isSubtract
              ? '${BaseUrl.url}/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=-$quantity'
              : '${BaseUrl.url}/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=$quantity',
        ),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      print('response do entryQuantity: $resultAsString');

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageQuantity = json.decode(resultAsString)["Message"];
        _isLoadingQuantity = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorMessageQuantity,
          context: context,
        );
        notifyListeners();
        return;
      }

      if (isSubtract) {
        _lastQuantityAdded = "-$quantity";
      } else {
        _lastQuantityAdded = quantity;
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
    required int countingCode,
    required int productPackingCode,
    required BuildContext context,
  }) async {
    _errorMessageQuantity = '';
    _isLoadingQuantity = true;
    _lastQuantityAdded = '';
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          '${BaseUrl.url}/Inventory/AnnulQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode',
        ),
      );
      request.body = json.encode(UserIdentity.identity);

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();

      print('response do anullQuantity: $resultAsString');

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageQuantity = json.decode(resultAsString)["Message"];
        _isLoadingQuantity = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorMessageQuantity,
          context: context,
        );
        notifyListeners();
        return;
      }

      _products[0].quantidadeInvContProEmb = -1;

      alterFocusToConsultProduct(
        context: context,
      );
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
  }) {
    if (!isIndividual && _products[0].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      _products[0].quantidadeInvContProEmb =
          double.tryParse(quantity.toString().replaceAll(RegExp(r','), '.'))!;
    } else if (isIndividual && _products[0].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      _products[0].quantidadeInvContProEmb = 1;
    } else if (isIndividual && isSubtract) {
      _products[0].quantidadeInvContProEmb--;
    } else if (isIndividual && !isSubtract) {
      _products[0].quantidadeInvContProEmb++;
    } else if (!isIndividual &&
        isSubtract &&
        (_products[0].quantidadeInvContProEmb - quantity) >= 0) {
      _products[0].quantidadeInvContProEmb -= quantity;
    } else {
      //se não for individual nem subtração, vai cair aqui
      //precisei sobrescrever a vírgula por ponto senão ocorria erro para somar/subtrair fracionado
      _products[0].quantidadeInvContProEmb +=
          double.tryParse(quantity.toString().replaceAll(RegExp(r','), '.'))!;
    }
  }

  FocusNode consultedProductFocusNode = FocusNode();
  FocusNode consultProductFocusNode = FocusNode();

  addQuantity({
    required bool isIndividual,
    required BuildContext context,
    required int codigoInternoInvCont,
    required bool isSubtract,
    required TextEditingController consultedProductController,
  }) async {
    double quantity = 0;
    if (consultedProductController.text.isNotEmpty && !isIndividual) {
      quantity = double.tryParse(
          consultedProductController.text.replaceAll(RegExp(r','), '.'))!;
    }

    try {
      await _entryQuantity(
        countingCode: codigoInternoInvCont,
        productPackingCode: _products[0].codigoInternoProEmb,
        quantity: isIndividual ? '1' : quantity.toString(),
        isSubtract: isSubtract,
        context: context,
      );

      if (_errorMessageQuantity != "") {
        //Se der erro não pode alterar a última quantidade adicionada
        return;
      }

      _updateLastQuantity(
        isSubtract: isSubtract,
        quantity: quantity,
        isIndividual: isIndividual,
      );

      if (isIndividual) {
        alterFocusToConsultProduct(
          context: context,
        );
      } else {
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

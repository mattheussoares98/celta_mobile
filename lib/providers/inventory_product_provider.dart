import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/inventory_product_model.dart';

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

  String _errorMessage = '';

  get errorMessage {
    return _errorMessage;
  }

  clearProducts() {
    _products.clear();
  }

  Future<void> _getProducts({
    required String controllerText,
    required int enterpriseCode,
    required int inventoryProcessCode,
    required int inventoryCountingCode,
    required BuildContext context,
    required SearchTypes searchTypes,
  }) async {
    _products.clear();
    _errorMessage = '';
    _isLoading = true;
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
        _errorMessage = json.decode(responseInString)["Message"];
        _isLoading = false;
        notifyListeners();
        return;
      }

      InventoryProductModel.responseInStringToInventoryProductModel(
        responseInString: responseInString,
        listToAdd: _products,
      );
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
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
    required FocusNode consultProductFocusNode,
    required bool isIndividual,
    required InventoryProductProvider inventoryProductProvider,
  }) async {
    await _getProducts(
      controllerText: controllerText,
      enterpriseCode: enterpriseCode,
      inventoryProcessCode: inventoryProcessCode,
      inventoryCountingCode: codigoInternoInvCont,
      context: context,
      searchTypes: SearchTypes.GetProductByPLU,
    );

    if (_products.length == 0) {
      await _getProducts(
        controllerText: controllerText,
        enterpriseCode: enterpriseCode,
        inventoryProcessCode: inventoryProcessCode,
        inventoryCountingCode: codigoInternoInvCont,
        context: context,
        searchTypes: SearchTypes.GetProductByEAN,
      );
    }

    if (_errorMessage != '') {
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });

      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
    }

    if (_errorMessage == '' && isIndividual) {
      //se estiver habilitado pra inserir individualmente, assim que efetuar a consulta do produto já vai tentar adicionar uma unidade
      await addQuantity(
        isIndividual: true,
        context: context,
        quantity: '1',
        isSubtract: false,
        codigoInternoInvCont: codigoInternoInvCont,
      );
    }
  }

  alterFocusToConsultProduct({
    required BuildContext context,
    required FocusNode consultProductFocusNode,
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

  String get lastQuantityAdded {
    return _lastQuantityAdded;
  }

  Future<void> _entryQuantity({
    required int countingCode,
    required int productPackingCode,
    required String quantity,
    required bool isSubtract,
    required BuildContext context,
  }) async {
    _isLoadingQuantity = true;
    _errorMessageQuantity = '';
    _canChangeTheFocus = false;
    _lastQuantityAdded = '';
    notifyListeners();

    try {
      quantity = quantity.replaceAll(RegExp(r','), '.');
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
    required String userIdentity,
    required BuildContext context,
    required InventoryProductProvider inventoryProductProvider,
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
      request.body = json.encode(userIdentity);

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

      _products[0].quantidadeInvContProEmb = -1;
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
    required dynamic quantity,
    required bool isIndividual,
  }) {
    if (!isIndividual && _products[0].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      _products[0].quantidadeInvContProEmb = double.tryParse(
          quantity.text.toString().replaceAll(RegExp(r','), '.'))!;
    } else if (isIndividual && _products[0].quantidadeInvContProEmb == -1) {
      //quando fica nulo, deixei pra ficar com o valor de -1 para corrigir um bug
      _products[0].quantidadeInvContProEmb = 1;
    } else if (isIndividual && isSubtract) {
      _products[0].quantidadeInvContProEmb--;
    } else if (isIndividual && !isSubtract) {
      _products[0].quantidadeInvContProEmb++;
    } else if (!isIndividual &&
        isSubtract &&
        (_products[0].quantidadeInvContProEmb -
                double.tryParse(quantity.text)!) >=
            0) {
      _products[0].quantidadeInvContProEmb -= double.tryParse(quantity.text)!;
    } else {
      //se não for individual nem subtração, vai cair aqui
      //precisei sobrescrever a vírgula por ponto senão ocorria erro para somar/subtrair fracionado
      _products[0].quantidadeInvContProEmb += double.tryParse(
          quantity.text.toString().replaceAll(RegExp(r','), '.'))!;
    }
  }

  addQuantity({
    required bool isIndividual,
    required BuildContext context,
    required int codigoInternoInvCont,
    required dynamic
        quantity, //coloquei como dynamic porque pode ser um controller ou somente o valor direto, como no caso de quando está inserindo os produtos individualmente que precisa inserir direto a quantidade "1"
    required bool isSubtract,
    void Function()? alterFocusToConsultedProduct,
  }) async {
    try {
      await _entryQuantity(
        countingCode: codigoInternoInvCont,
        productPackingCode: _products[0].codigoInternoProEmb,
        quantity: isIndividual ? '1' : quantity.text,
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
          isIndividual: isIndividual);
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageQuantity = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageQuantity,
        context: context,
      );
    }
    if (_errorMessageQuantity != '') {
      alterFocusToConsultedProduct!();
      return;
    }

    if (!isIndividual) {
      quantity.clear();
      alterFocusToConsultedProduct!();
    }
  }
}

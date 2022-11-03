import 'dart:convert';
import 'package:celta_inventario/Models/receipt_conference_product_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum SearchTypes {
  GetProductByName,
  GetProductByEAN,
  GetProductByPLU,
}

class ReceiptConferenceProvider with ChangeNotifier {
  List<ReceiptConferenceProductModel> _products = [];

  get products {
    return _products;
  }

  get productsCount {
    return _products.length;
  }

  bool _consultingProducts = false;

  get consultingProducts {
    return _consultingProducts;
  }

  String _errorMessageGetProducts = "";

  get errorMessageGetProducts {
    return _errorMessageGetProducts;
  }

  String _errorMessageUpdateQuantity = "";

  get errorMessageUpdateQuantity {
    return _errorMessageUpdateQuantity;
  }

  var consultProductFocusNode = FocusNode();
  var consultedProductFocusNode = FocusNode();

  clearProducts() {
    _products = [];
    notifyListeners();
  }

  Future<void> getAllProductsWithoutEan({
    required int docCode,
    required BuildContext context,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _consultingProducts = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProduct?docCode=${docCode}&searchTypeInt=19&searchValue=undefined'),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print(resultAsString);

      if (resultAsString.contains("Message")) {
        //significa que tem algum erro
        _errorMessageGetProducts = json.decode(resultAsString)["Message"];
        _consultingProducts = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageGetProducts,
          context: context,
        );
        notifyListeners();
        return;
      } else {
        ReceiptConferenceProductModel.resultAsStringToReceiptConferenceModel(
          resultAsString: resultAsString,
          listToAdd: _products,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;

      ShowErrorMessage.showErrorMessage(
        error: _errorMessageGetProducts,
        context: context,
      );
    }

    _consultingProducts = false;
    notifyListeners();
  }

  void _updateAtualQuantity({
    required int index,
    required double newQuantity,
    required bool isAnnulQuantity,
  }) {
    ReceiptConferenceProductModel productWithNewQuantity =
        ReceiptConferenceProductModel(
      Nome_Produto: _products[index].Nome_Produto,
      FormatedProduct: _products[index].FormatedProduct,
      CodigoInterno_Produto: _products[index].CodigoInterno_Produto,
      CodigoInterno_ProEmb: _products[index].CodigoInterno_ProEmb,
      CodigoPlu_ProEmb: _products[index].CodigoPlu_ProEmb,
      Codigo_ProEmb: _products[index].Codigo_ProEmb,
      PackingQuantity: _products[index].PackingQuantity,
      Quantidade_ProcRecebDocProEmb:
          isAnnulQuantity ? null : newQuantity, //alterando a quantidade
      ReferenciaXml_ProcRecebDocProEmb:
          _products[index].ReferenciaXml_ProcRecebDocProEmb,
      AllEans: _products[index].AllEans,
    );

    _products[index] = productWithNewQuantity;
    notifyListeners();
  }

  bool _isUpdatingQuantity = false;

  get isUpdatingQuantity {
    return _isUpdatingQuantity;
  }

  updateQuantity({
    required int docCode,
    required int productgCode,
    required int productPackingCode,
    required String
        quantityText, //o parâmetro é recebido via String porque vem de um controller de um textFormField
    required int index,
    required BuildContext context,
  }) async {
    quantityText = quantityText.replaceAll(RegExp(r','), '.');
    var quantity = double.tryParse(quantityText);

    if (_products[index].Quantidade_ProcRecebDocProEmb == quantity) {
      //se a quantidade for igual à atual, não precisa fazer a requisição
      _errorMessageUpdateQuantity = "A quantidade é igual à atual";

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultedProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    } else if (quantity == 0) {
      //se a quantidade for igual a 0, precisa zerar a contagem
      await anullQuantity(
        docCode: docCode,
        productgCode: productgCode,
        productPackingCode: productPackingCode,
        index: index,
        context: context,
      );
      return;
    }
    _errorMessageUpdateQuantity = "";
    _isUpdatingQuantity = true;

    notifyListeners();

    double? quantityToAdd;

    if (_products[index].Quantidade_ProcRecebDocProEmb == null) {
      quantityToAdd = quantity;
    } else {
      quantityToAdd =
          quantity! - _products[index].Quantidade_ProcRecebDocProEmb;
    }
    print(quantityToAdd);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              "${BaseUrl.url}/GoodsReceiving/EntryQuantity?grDocCode=${docCode}" +
                  "&productgCode=${productgCode}&productPackingCode=${productPackingCode}" +
                  "&quantity=${quantityToAdd}"));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print(resultAsString);

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageUpdateQuantity = json.decode(resultAsString)["Message"];
        _isUpdatingQuantity = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageGetProducts,
          context: context,
        );
        notifyListeners();
        return;
      } else {
        _updateAtualQuantity(
          index: index,
          newQuantity: quantity!,
          isAnnulQuantity: false,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
    }

    _isUpdatingQuantity = false;
    notifyListeners();
  }

  anullQuantity({
    required int docCode,
    required int productgCode,
    required int productPackingCode,
    required int index,
    required BuildContext context,
  }) async {
    print("anulando");
    if (_products[index].Quantidade_ProcRecebDocProEmb == 0 ||
        _products[index].Quantidade_ProcRecebDocProEmb == null) {
      //se a quantidade for igual à atual, não precisa fazer a requisição
      _errorMessageUpdateQuantity = "A quantidade já está nula";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      notifyListeners();
      return;
    }
    _errorMessageUpdateQuantity = "";
    _isUpdatingQuantity = true;
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/GoodsReceiving/AnnulQuantity?grDocCode=${docCode}&productgCode=${productgCode}&productPackingCode=${productPackingCode}'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print(resultAsString);

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageUpdateQuantity = json.decode(resultAsString)["Message"];
        _isUpdatingQuantity = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageUpdateQuantity,
          context: context,
        );
        notifyListeners();
        return;
      } else {
        _updateAtualQuantity(
          index: index,
          newQuantity: 0,
          isAnnulQuantity: true,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
    }

    _isUpdatingQuantity = false;
    notifyListeners();
  }

  Future<void> _getProducts({
    required int docCode,
    required SearchTypes searchTypes,
    required String controllerText,
    required BuildContext context,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _consultingProducts = true;
    notifyListeners();
    http.Request? request;

    if (searchTypes == SearchTypes.GetProductByEAN) {
      request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProductByEan?docCode=$docCode&ean=$controllerText'),
      );
    } else if (searchTypes == SearchTypes.GetProductByPLU) {
      request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/GoodsReceiving/GetProductByPlu?docCode=${docCode}&plu=${controllerText}'));
    } else {
      request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProduct?docCode=$docCode&searchTypeInt=6&searchValue=$controllerText'),
      );
    }

    try {
      var headers = {'Content-Type': 'application/json'};

      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do $searchTypes: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(resultAsString)["Message"];
        _consultingProducts = false;

        notifyListeners();
        return;
      }

      ReceiptConferenceProductModel.resultAsStringToReceiptConferenceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageGetProducts,
        context: context,
      );
    }
    _consultingProducts = false;
    notifyListeners();
  }

  Future<void> getProductByPluEanOrName({
    required docCode,
    required controllerText,
    required BuildContext context,
  }) async {
    int? isInt = int.tryParse(controllerText);
    if (isInt != null) {
      //só faz a consulta por ean ou plu se conseguir converter o texto para inteiro
      await _getProducts(
        docCode: docCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByEAN,
        context: context,
      );
      if (productsCount > 0) return;

      await _getProducts(
        docCode: docCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByPLU,
        context: context,
      );
      if (productsCount > 0) return;
    } else {
      //só consulta por nome se não conseguir converter o valor para inteiro, pois se for inteiro só pode ser ean ou plu
      await _getProducts(
        docCode: docCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByName,
        context: context,
      );
    }

    if (_errorMessageGetProducts != "") {
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageGetProducts,
        context: context,
      );

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    }
  }
}

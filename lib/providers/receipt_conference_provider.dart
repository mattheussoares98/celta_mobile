import 'dart:convert';
import 'package:celta_inventario/Models/receipt_conference_product_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
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

  bool _isLoadingValidityDate = false;
  get isLoadingValidityDate => _isLoadingValidityDate;

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
    required double quantity,
    required bool isAnnulQuantity,
    required bool isSubtract,
    required BuildContext context,
  }) {
    if (isSubtract) {
      quantity = _products[index].Quantidade_ProcRecebDocProEmb - quantity;
    } else if (_products[index].Quantidade_ProcRecebDocProEmb != null) {
      quantity = _products[index].Quantidade_ProcRecebDocProEmb + quantity;
    }

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
          isAnnulQuantity ? null : quantity, //alterando a quantidade
      ReferenciaXml_ProcRecebDocProEmb:
          _products[index].ReferenciaXml_ProcRecebDocProEmb,
      AllEans: _products[index].AllEans,
      DataValidade_ProcRecebDocProEmb:
          _products[index].DataValidade_ProcRecebDocProEmb,
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
    required bool isSubtract,
    required String validityDate,
  }) async {
    quantityText = quantityText.replaceAll(RegExp(r','), '.');
    var quantity = double.tryParse(quantityText);

    if (isSubtract && _products[index].Quantidade_ProcRecebDocProEmb == null) {
      _isUpdatingQuantity = false;
      _errorMessageUpdateQuantity = "A quantidade não pode ficar negativa!";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    } else if (isSubtract &&
        quantity! > _products[index].Quantidade_ProcRecebDocProEmb) {
      _isUpdatingQuantity = false;
      _errorMessageUpdateQuantity = "A quantidade não pode ficar negativa!";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    }

    _isLoadingValidityDate = true;
    _errorMessageUpdateQuantity = "";
    _isUpdatingQuantity = true;

    notifyListeners();

    try {
      http.Request request;
      var headers = {'Content-Type': 'application/json'};
      if (isSubtract) {
        request = http.Request(
          'POST',
          Uri.parse(
            "${BaseUrl.url}/GoodsReceiving/EntryQuantity?grDocCode=${docCode}" +
                "&productgCode=${productgCode}&productPackingCode=${productPackingCode}" +
                "&quantity=-${quantity}" +
                "&&validityDate=${validityDate}",
          ),
        );
      } else {
        request = http.Request(
          'POST',
          Uri.parse(
            "${BaseUrl.url}/GoodsReceiving/EntryQuantity?grDocCode=${docCode}" +
                "&productgCode=${productgCode}&productPackingCode=${productPackingCode}" +
                "&quantity=${quantity}" +
                "&&validityDate=${validityDate}",
          ),
        );
      }
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
          context: context,
          index: index,
          quantity: quantity!,
          isAnnulQuantity: false,
          isSubtract: isSubtract,
        );
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(consultedProductFocusNode);
      });

      _products[index].DataValidade_ProcRecebDocProEmb =
          validityDate.toString();
      notifyListeners();
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
    } finally {
      _isLoadingValidityDate = false;
      _isUpdatingQuantity = false;
      notifyListeners();
    }
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
          quantity: 0,
          isAnnulQuantity: true,
          isSubtract: false,
          context: context,
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
      // ShowErrorMessage.showErrorMessage(
      //   error: _errorMessageGetProducts,
      //   context: context,
      // );

      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    }
  }
}

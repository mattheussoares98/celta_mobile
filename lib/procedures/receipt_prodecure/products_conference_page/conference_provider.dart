import 'dart:convert';

import 'package:celta_inventario/procedures/receipt_prodecure/models/conference_product_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class ConferenceProvider with ChangeNotifier {
  List<ConferenceProductModel> _products = [];

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

  clearProducts() {
    _products = [];
  }

  resultAsStringToConferenceModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        ConferenceProductModel(
          Nome_Produto: data["Nome_Produto"],
          FormatedProduct: data["FormatedProduct"],
          CodigoInterno_Produto: data["CodigoInterno_Produto"],
          CodigoInterno_ProEmb: data["CodigoInterno_ProEmb"],
          CodigoPlu_ProEmb: data["CodigoPlu_ProEmb"],
          Codigo_ProEmb: data["Codigo_ProEmb"],
          PackingQuantity: data["PackingQuantity"],
          Quantidade_ProcRecebDocProEmb: data["Quantidade_ProcRecebDocProEmb"],
          ReferenciaXml_ProcRecebDocProEmb:
              data["ReferenciaXml_ProcRecebDocProEmb"],
          AllEans: data["AllEans"],
        ),
      );
    });
  }

  Future<void> getAllProductsWithoutEan({
    required int docCode,
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
      } else if (resultAsString.contains("!DOCTYPE HTML")) {
        _errorMessageGetProducts =
            "Ocorreu um erro não esperado para consultar os produtos";
        _consultingProducts = false;
        notifyListeners();
        return;
      } else {
        resultAsStringToConferenceModel(
          resultAsString: resultAsString,
          listToAdd: _products,
        );
      }
    } catch (e) {
      _errorMessageGetProducts =
          "Erro para consultar os produtos do recebimento";
      print('Erro para consultar os produtos do recebimento: ${e.toString()}');
    }

    _consultingProducts = false;
    notifyListeners();
  }

  void _updateAtualQuantity({
    required int index,
    required double newQuantity,
  }) {
    ConferenceProductModel productWithNewQuantity = ConferenceProductModel(
      Nome_Produto: _products[index].Nome_Produto,
      FormatedProduct: _products[index].FormatedProduct,
      CodigoInterno_Produto: _products[index].CodigoInterno_Produto,
      CodigoInterno_ProEmb: _products[index].CodigoInterno_ProEmb,
      CodigoPlu_ProEmb: _products[index].CodigoPlu_ProEmb,
      Codigo_ProEmb: _products[index].Codigo_ProEmb,
      PackingQuantity: _products[index].PackingQuantity,
      Quantidade_ProcRecebDocProEmb: newQuantity, //alterando a quantidade
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
  }) async {
    quantityText = quantityText.replaceAll(RegExp(r','), '.');
    var quantity = double.tryParse(quantityText);

    if (_products[index].Quantidade_ProcRecebDocProEmb == quantity) {
      //se a quantidade for igual à atual, não precisa fazer a requisição
      _errorMessageUpdateQuantity = "A quantidade é igual à atual";
      notifyListeners();
      return;
    } else if (quantity == 0) {
      //se a quantidade for igual a 0, precisa zerar a contagem
      await anullQuantity(
        docCode: docCode,
        productgCode: productgCode,
        productPackingCode: productPackingCode,
        quantityText: quantityText,
        index: index,
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
        notifyListeners();
        return;
      } else if (resultAsString.contains("!DOCTYPE HTML")) {
        _errorMessageUpdateQuantity =
            "Ocorreu um erro não esperado para consultar os produtos";
        _isUpdatingQuantity = false;
        notifyListeners();
        return;
      } else {
        _updateAtualQuantity(
          index: index,
          newQuantity: quantity!,
        );
      }
    } catch (e) {
      _errorMessageUpdateQuantity = "Erro para alterar a quantidade";
      print('Erro para alterar a quantidade do produto: ${e.toString()}');
    }

    _isUpdatingQuantity = false;
    notifyListeners();
  }

  anullQuantity({
    required int docCode,
    required int productgCode,
    required int productPackingCode,
    required String
        quantityText, //o parâmetro é recebido via String porque vem de um controller de um textFormField
    required int index,
  }) async {
    if (_products[index].Quantidade_ProcRecebDocProEmb == 0) {
      //se a quantidade for igual à atual, não precisa fazer a requisição
      _errorMessageUpdateQuantity = "A quantidade já está zerada";
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
        notifyListeners();
        return;
      } else if (resultAsString.contains("!DOCTYPE HTML")) {
        _errorMessageUpdateQuantity =
            "Ocorreu um erro não esperado para consultar os produtos";
        _isUpdatingQuantity = false;
        notifyListeners();
        return;
      } else {
        _updateAtualQuantity(
          index: index,
          newQuantity: 0,
        );
      }
    } catch (e) {
      _errorMessageUpdateQuantity = "Erro para alterar a quantidade";
      print('Erro para alterar a quantidade do produto: ${e.toString()}');
    }

    _isUpdatingQuantity = false;
    notifyListeners();
  }

  Future<void> _getProductByPlu({
    required int docCode,
    required String pluInString, //em string pq vem de um texfFormField
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _consultingProducts = true;
    notifyListeners();
    print("obtendo produtos por PLU");
    int? plu = int.tryParse(pluInString);
    if (plu == null) {
      //quando clica no ícone de pesquisa, consulta primeiro por plu, depois por
      //ean e finalmente pelo nome. Caso não consiga converter o que foi
      //digitado em um inteiro, significa que não precisa continuar a execução
      //do código pois deve efetuar a consulta via nome
      return;
    }

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProductByPlu?docCode=${docCode}&plu=${plu}'));
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do PLU: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(resultAsString)["Message"];
        _consultingProducts = false;
        notifyListeners();
        return;
      } else if (resultAsString.contains("!DOCTYPE HTML")) {
        _errorMessageGetProducts =
            "Ocorreu um erro não esperado para consultar os produtos";
        _consultingProducts = false;
        notifyListeners();
        return;
      }

      resultAsStringToConferenceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      _errorMessageGetProducts = "Erro para consultar o produto";
    }
    _consultingProducts = false;
    notifyListeners();
  }

  Future<void> getProductByEan({
    required int docCode,
    required String eanInString, //em string pq vem de um texfFormField
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _consultingProducts = true;
    notifyListeners();
    print("obtendo produtos por EAN");

    int? ean = int.tryParse(eanInString);
    if (ean == null) {
      //quando clica no ícone de pesquisa, consulta primeiro por plu, depois por
      //ean e finalmente pelo nome. Caso não consiga converter o que foi
      //digitado em um inteiro, significa que não precisa continuar a execução
      //do código pois deve efetuar a consulta via nome
      return;
    }

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProductByEan?docCode=$docCode&ean=$ean'),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do EAN: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(resultAsString)["Message"];
        _consultingProducts = false;
        notifyListeners();
        return;
      } else if (resultAsString.contains("!DOCTYPE HTML")) {
        _errorMessageGetProducts =
            "Ocorreu um erro não esperado para consultar os produtos";
        _consultingProducts = false;
        notifyListeners();
        return;
      }

      resultAsStringToConferenceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      _errorMessageGetProducts = "Erro para consultar o produto";
    }
    _consultingProducts = false;
    notifyListeners();
  }

  Future<void> _getProductByName({
    required int docCode,
    required String name,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _consultingProducts = true;
    notifyListeners();
    print("obtendo produtos por nome");

    //só está funcionando porque está chamando o setState na função

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/GetProduct?docCode=$docCode&searchTypeInt=6&searchValue=$name'),
      );
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do nome: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageGetProducts = json.decode(resultAsString)["Message"];
        _consultingProducts = false;
        notifyListeners();
        return;
      } else if (resultAsString.contains("!DOCTYPE HTML")) {
        _errorMessageGetProducts =
            "Ocorreu um erro não esperado para consultar os produtos";
        _consultingProducts = false;
        notifyListeners();
        return;
      }

      resultAsStringToConferenceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      _errorMessageGetProducts = "Erro para consultar o produto";
    }
    _consultingProducts = false;
    notifyListeners();
  }

  Future<void> getProductByPluEanOrName({
    required docCode,
    required controllerText,
  }) async {
    int? isInt = int.tryParse(controllerText);
    if (isInt != null) {
      //só faz a consulta por ean ou plu se conseguir converter o texto para inteiro
      await _getProductByPlu(docCode: docCode, pluInString: controllerText);
      if (_products.isNotEmpty) return;

      await getProductByEan(docCode: docCode, eanInString: controllerText);
      if (_products.isNotEmpty) return;
    } else {
      //só consulta por nome se não conseguir converter o valor para inteiro, pois se for inteiro só pode ser ean ou plu
      await _getProductByName(docCode: docCode, name: controllerText);
    }
  }

  Future<String> scanBarcode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // if (!mounted) return;

    if (barcodeScanRes != '-1') {
      return barcodeScanRes;
    } else {
      return "";
    }
  }
}

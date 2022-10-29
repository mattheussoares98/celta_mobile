import 'dart:convert';

import 'package:celta_inventario/procedures/consult_price_procedure/models/consult_price_model.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../../utils/base_url.dart';

enum SearchTypes {
  GetProductByName,
  GetProductByEAN,
  GetProductByPLU,
}

class ConsultPriceProvider with ChangeNotifier {
  List<ConsultPriceModel> _products = [];

  get products {
    return _products;
  }

  get productsCount {
    return _products.length;
  }

  bool _isLoading = false;

  get isLoading {
    return _isLoading;
  }

  String _errorMessage = "";

  get errorMessage {
    return _errorMessage;
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

  String _convertToBrazilianNumber(String valueInString) {
    print(valueInString);
    int lastindex = valueInString.lastIndexOf("\.");

    // print(lastindex.toString());

    valueInString = valueInString.replaceRange(lastindex, lastindex + 1, ',');
    if (lastindex > 4) {
      valueInString = valueInString.replaceFirst(RegExp(r'\,'), '.');
      return valueInString;
    } else {
      return valueInString;
    }
  }

  resultAsStringToConferenceModel({
    required resultAsString,
    required listToAdd,
  }) {
    List resultAsList = json.decode(resultAsString);
    Map resultAsMap = resultAsList.asMap();

    resultAsMap.forEach((id, data) {
      listToAdd.add(
        ConsultPriceModel(
          PriceLookUp: data["PriceLookUp"],
          ProductName: data["ProductName"],
          Packing: data["Packing"],
          PackingQuantity: data["PackingQuantity"],
          Name: data["Name"],
          ReducedName: data["ReducedName"],
          ProductPackingCode: data["ProductPackingCode"],
          PersonalizedCode: data["PersonalizedCode"],
          AllowTransfer: data["AllowTransfer"],
          AllowSale: data["AllowSale"],
          AllowBuy: data["AllowBuy"],
          MinimumWholeQuantity: data["MinimumWholeQuantity"],
          SalePracticedRetail: data["SalePracticedRetail"],
          SalePracticedWholeSale: data["SalePracticedWholeSale"],
          OperationalCost: data["OperationalCost"],
          ReplacementCost: data["ReplacementCost"],
          ReplacementCostMidle: data["ReplacementCostMidle"],
          LiquidCost: data["LiquidCost"],
          LiquidCostMidle: data["LiquidCostMidle"],
          RealCost: data["RealCost"],
          RealLiquidCost: data["RealLiquidCost"],
          FiscalCost: data["FiscalCost"],
          FiscalLiquidCost: data["FiscalLiquidCost"],
          CurrentStock: data["CurrentStock"],
          SaldoEstoqueVenda: data["SaldoEstoqueVenda"],
          EtiquetaPendente: data["EtiquetaPendente"],
          EtiquetaPendenteDescricao: data["EtiquetaPendenteDescricao"],
        ),
      );
    });

    _products.forEach((element) {
      element.SalePracticedRetail =
          _convertToBrazilianNumber(element.SalePracticedRetail.toString());
      element.CurrentStock =
          _convertToBrazilianNumber(element.CurrentStock.toString());
    });
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String controllerText, //em string pq vem de um texfFormField
    required SearchTypes searchTypes,
  }) async {
    _products.clear();
    _errorMessage = "";
    _isLoading = true;
    String searchType =
        searchTypes.toString().replaceAll(RegExp(r'SearchTypes.'), '');
    notifyListeners();
    dynamic value = int.tryParse(controllerText);
    //o valor pode ser em inteiro ou em texto
    if (value == null) {
      //retorna nulo quando não consegue converter para inteiro. Se não
      //conseguir converter precisa consultar por nome, por isso pode usar o
      //próprio texto do "controllerText"
      value = controllerText;
    }

    var headers = {'Content-Type': 'application/json'};
    // print(searchType);
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/PriceConference/$searchType?enterpriseCode=$enterpriseCode&searchValue=$value'));
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();
      print("resultAsString consulta do $searchType: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];
        _isLoading = false;
        notifyListeners();
        return;
      }

      resultAsStringToConferenceModel(
        resultAsString: resultAsString,
        listToAdd: _products,
      );
    } catch (e) {
      print(e);
      _errorMessage =
          "Ocorreu um erro não esperado durante a operação. Verifique a sua internet e caso ela esteja funcionando, entre em contato com o suporte";
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getProductByPluEanOrName({
    required int enterpriseCode,
    required controllerText,
  }) async {
    int? isInt = int.tryParse(controllerText);
    if (isInt != null) {
      //só faz a consulta por ean ou plu se conseguir converter o texto para inteiro
      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByPLU,
      );
      if (_products.isNotEmpty) return;

      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByEAN,
      );
      if (_products.isNotEmpty) return;
    } else {
      //só consulta por nome se não conseguir converter o valor para inteiro, pois se for inteiro só pode ser ean ou plu
      await _getProducts(
        enterpriseCode: enterpriseCode,
        controllerText: controllerText,
        searchTypes: SearchTypes.GetProductByName,
      );
    }

    notifyListeners();
  }

  bool _isSendingToPrint = false;

  bool get isSendingToPrint => _isSendingToPrint;

  String _errorSendToPrint = "";

  String get errorSendToPrint => _errorSendToPrint;

  Future<void> sendToPrint({
    required int enterpriseCode,
    required int productPackingCode,
    required int index,
  }) async {
    _isSendingToPrint = true;
    _errorSendToPrint = "";
    notifyListeners();
    bool newValue = !_products[index].EtiquetaPendente;

    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/PriceConference/SendToPrint?enterpriseCode=$enterpriseCode' +
                '&productPackingCode=$productPackingCode&send=$newValue'));
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      String resultAsString = await response.stream.bytesToString();
      print("resultAsString marcar para impressão: $resultAsString");

      if (resultAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(resultAsString)["Message"];
        _isLoading = false;
        notifyListeners();
        return;
      }

      if (_products[index].EtiquetaPendenteDescricao == "Sim") {
        _products[index].EtiquetaPendenteDescricao = "Não";
      } else {
        _products[index].EtiquetaPendenteDescricao = "Sim";
      }
      //caso dê certo a alteração, vai alterar o valor localmente para o usuário
      //saber que deu certo a requisição
    } catch (e) {
      print("Erro para alterar o status da impressão");
      _errorSendToPrint =
          "Ocorreu um erro não esperado durante a operação. Verifique a sua internet e caso ela esteja funcionando, entre em contato com o suporte";
    } finally {
      _isSendingToPrint = false;
      notifyListeners();
    }
  }

  orderByUpPrice() {
    _products
        .sort((a, b) => a.SalePracticedRetail.compareTo(b.SalePracticedRetail));
    notifyListeners();
  }

  orderByDownPrice() {
    _products
        .sort((a, b) => b.SalePracticedRetail.compareTo(a.SalePracticedRetail));
    notifyListeners();
  }

  orderByUpName() {
    _products.sort((a, b) => a.ProductName.compareTo(b.ProductName));

    notifyListeners();
  }

  orderByDownName() {
    _products.sort((a, b) => b.ProductName.compareTo(a.ProductName));
    notifyListeners();
  }
}

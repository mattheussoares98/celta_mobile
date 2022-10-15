import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuantityProvider with ChangeNotifier {
  bool _isLoadingQuantity = false;

  bool get isLoadingQuantity {
    return _isLoadingQuantity;
  }

  String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  bool _isConfirmedQuantity = false;

  bool get isConfirmedQuantity {
    return _isConfirmedQuantity;
  }

  //criado somente pra conseguir identificar quando foi chamado o método de subtração
  //e atualizar corretamente a mensagem da última quantidade digitada
  bool _isSubtract = false;

  bool get isSubtract {
    return _isSubtract;
  }

  bool _canChangeTheFocus = false;

  bool get canChangeTheFocus {
    return _canChangeTheFocus;
  }

  String _lastQuantityAdded = '';

  String get lastQuantityAdded {
    return _lastQuantityAdded;
  }

  Future<void> entryQuantity({
    required int? countingCode,
    required int? productPackingCode,
    required String? quantity,
    required String? userIdentity,
    required bool? isSubtract,
  }) async {
    if (isSubtract!) {
      _isSubtract = true;
    } else {
      _isSubtract = false;
    }
    _isConfirmedQuantity = false;
    _isLoadingQuantity = true;
    _errorMessage = '';
    _canChangeTheFocus = false;
    _lastQuantityAdded = '';
    notifyListeners();

    try {
      quantity = quantity!.replaceAll(RegExp(r','), '.');
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          isSubtract
              ? '${BaseUrl.url}/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=-$quantity'
              : '${BaseUrl.url}/Inventory/EntryQuantity?countingCode=$countingCode&productPackingCode=$productPackingCode&quantity=$quantity',
        ),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String resultAsString = await response.stream.bytesToString();

      print('response do quantityProvider: $resultAsString');

      if (resultAsString.contains('não permite fracionamento')) {
        _errorMessage = 'Esse produto não permite fracionamento!';
      } else if (resultAsString.contains('request is invalid')) {
        _errorMessage = 'Operação inválida';
      } else if (resultAsString
          .contains('tornará a quantidade contada do produto negativa')) {
        _errorMessage =
            'A quantidade contada não pode ser negativa! Essa operação tornaria a quantidade negativa';
      }

      if (response.statusCode == 200) {
        print('deu certo o quantity provider');
        _isConfirmedQuantity = true;
        _lastQuantityAdded = quantity;
      } else {
        print('erro no quantityProvider');
      }
    } catch (e) {
      _errorMessage =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
    } finally {}
    _isLoadingQuantity = false;
    _canChangeTheFocus = true;
    notifyListeners();
  }

  bool isConfirmedAnullQuantity = false;
  Future<void> anullQuantity({
    required int countingCode,
    required int productPackingCode,
    required String userIdentity,
  }) async {
    isConfirmedAnullQuantity = false;
    _errorMessage = '';
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

      if (response.statusCode == 200) {
        isConfirmedAnullQuantity = true;
        _lastQuantityAdded = '';
        notifyListeners();
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      _errorMessage =
          'Erro para confirmar. Verifique a sua internet e tente novamente';
      print('Erro no anullQuantity: $e');
      _lastQuantityAdded = '';
    }

    _isLoadingQuantity = false;
    print(_lastQuantityAdded);
    notifyListeners();
  }
}

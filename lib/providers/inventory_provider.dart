import 'package:celta_inventario/Models/inventory/inventory_model.dart';
import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryProvider with ChangeNotifier {
  final List<InventoryModel> _inventorys = [];

  List<InventoryModel> get inventorys {
    return [..._inventorys];
  }

  int get inventoryCount {
    return _inventorys.length;
  }

  bool _isLoadingInventorys = false;

  bool get isLoadingInventorys {
    return _isLoadingInventorys;
  }

  static String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  Future<void> getInventory({
    required int enterpriseCode,
    required String? userIdentity,
  }) async {
    _isLoadingInventorys = true;
    _inventorys.clear();
    _errorMessage = '';
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/Inventory/GetFroozenProcesses?enterpriseCode=$enterpriseCode'),
      );
      request.body = json.encode(userIdentity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseAsString = await response.stream.bytesToString();

      //esse if serve para quando não houver um inventário congelado para a empresa, não continunar o processo senão dará erro na aplicação
      if (responseAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(responseAsString)["Message"];
        _isLoadingInventorys = false;

        notifyListeners();
        return;
      }

      InventoryModel.responseAsStringToInventoryModel(
        responseAsString: responseAsString,
        listToAdd: _inventorys,
      );
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingInventorys = false;
    }

    notifyListeners();
  }
}

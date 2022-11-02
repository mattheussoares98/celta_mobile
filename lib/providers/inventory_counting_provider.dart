import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../Models/countings_model.dart';

class InventoryCountingProvider with ChangeNotifier {
  List<InventoryCountingsModel> _countings = [];

  List<InventoryCountingsModel> get countings {
    return [..._countings];
  }

  int get countingsQuantity {
    return countings.length;
  }

  static String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  static bool _isLoadingCountings = false;

  bool get isLoadingCountings {
    return _isLoadingCountings;
  }

  getCountings({
    required int inventoryProcessCode,
    required BuildContext context,
  }) async {
    _countings.clear();
    _errorMessage = '';
    _isLoadingCountings = true;
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/Inventory/GetCountings?inventoryProcessCode=$inventoryProcessCode'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseInString = await response.stream.bytesToString();

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(responseInString)["Message"];
        _isLoadingCountings = false;

        ShowErrorMessage.showErrorMessage(
          error: _errorMessage,
          context: context,
        );
        notifyListeners();
        return;
      }

      InventoryCountingsModel.responseInStringToInventoryCountingsModel(
        responseInString: responseInString,
        listToAdd: _countings,
      );
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingCountings = false;
    }

    notifyListeners();
  }
}

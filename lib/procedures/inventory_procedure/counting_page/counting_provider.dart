import 'package:celta_inventario/utils/base_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import '../models/countings_model.dart';

class CountingProvider with ChangeNotifier {
  List<CountingsModel> _countings = [];

  List<CountingsModel> get countings {
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
    int? inventoryProcessCode,
    String? userIdentity,
  }) async {
    _countings.clear();
    _errorMessage = '';
    _isLoadingCountings = true;

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/Inventory/GetCountings?inventoryProcessCode=$inventoryProcessCode'));
      request.body = json.encode(
        userIdentity,
      );
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseInString = await response.stream.bytesToString();
      final List responseInList = json.decode(responseInString);
      final Map responseInMap = responseInList.asMap();

      responseInMap.forEach((id, data) {
        _countings.add(
          CountingsModel(
            codigoInternoInvCont: data['CodigoInterno_InvCont'],
            flagTipoContagemInvCont: data['FlagTipoContagem_InvCont'],
            codigoInternoInventario: data['CodigoInterno_Inventario'],
            numeroContagemInvCont: data['NumeroContagem_InvCont'],
            obsInvCont: data['Obs_InvCont'] == null
                ? 'Não há observações'
                : data['Obs_InvCont'],
            //as vezes a observação vem nula e se não faz isso, gera erro no app
          ),
        );
      });
    } catch (e) {
      print('erro ao consultar a contagem ==== $e');
      _errorMessage =
          'O servidor não foi encontrado. Verifique a sua internet!';
    } finally {
      _isLoadingCountings = false;
    }

    notifyListeners();
  }
}

import 'package:celta_inventario/utils/base_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/user_identity.dart';
import '../models/receipt_model.dart';

class ReceiptProvider with ChangeNotifier {
  final List<ReceiptModel> _receipts = [];

  List<ReceiptModel> get receipts {
    return [..._receipts];
  }

  int get receiptCount {
    return _receipts.length;
  }

  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  static String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  Future<void> getReceipt({
    required String? enterpriseCode,
    required String? userIdentity,
  }) async {
    _isLoading = true;
    _receipts.clear();
    _errorMessage = '';

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/GoodsReceiving/GetActiveGRDocsStatus?enterpriseCode=${enterpriseCode}'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseAsString = await response.stream.bytesToString();

      //esse if serve para quando não houver um inventário congelado para a empresa, não continunar o processo senão dará erro na aplicação
      // if (responseAsString
      //     .contains('Nenhum processo de inventário foi encontrado')) {
      //   _errorMessage =
      //       'Não há processos de inventário para essa empresa. Somente processos de inventário congelados ficarão disponíveis para consulta e seleção.';
      //   _isLoading = false;
      //   notifyListeners();
      //   return;
      // }

      List responseAsList = json.decode(responseAsString.toString());
      Map responseAsMap = responseAsList.asMap();

      print(responseAsMap);
      responseAsMap.forEach((id, data) {
        _receipts.add(
          ReceiptModel(
            CodigoInterno_ProcRecebDoc: data["CodigoInterno_ProcRecebDoc"],
            CodigoInterno_Empresa: data["CodigoInterno_Empresa"],
            Numero_ProcRecebDoc: data["Numero_ProcRecebDoc"],
            EmitterName: data["EmitterName"],
            Status: data["Status"].toString(),
          ),
        );
      });
    } catch (e) {
      print("erro para consultar os recebimentos: " + e.toString());
      _errorMessage =
          'O servidor não foi encontrado! Verifique a sua internet!';
    } finally {
      _treatErrorMessage();
      _isLoading = false;
    }
    notifyListeners();
  }

  _treatErrorMessage() {
    _receipts.forEach((element) {
      if (element.Status == "8") {
        element.Status = "Aguardando a liberação para entrada";
      } else if (element.Status == "6") {
        element.Status = "Aguardando a manutenção dos produtos";
      } else if (element.Status == "4") {
        element.Status = "Em processo de autorização";
      }
    });
  }

  liberate(int grDocCode) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${BaseUrl.url}/GoodsReceiving/LiberateGRDoc?grDocCode=${grDocCode}'));
    request.body = json.encode(UserIdentity.identity);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print("Erro para fazer a requisição: ${response.reasonPhrase}");
    }
  }
}

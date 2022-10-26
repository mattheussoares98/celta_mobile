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

  bool _isLoadingReceipt = false;

  bool get isLoadingReceipt {
    return _isLoadingReceipt;
  }

  bool _isLoadingLiberateCheck = false;

  bool get isLoadingLiberateCheck {
    return _isLoadingLiberateCheck;
  }

  static String _errorMessage = '';

  String get errorMessage {
    return _errorMessage;
  }

  static String _liberateError = '';

  String get liberateError {
    return _liberateError;
  }

  Future<void> getReceipt({
    required String? enterpriseCode,
  }) async {
    _receipts.clear();
    _isLoadingReceipt = true;
    _errorMessage = '';
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      // notifyListeners();
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/GoodsReceiving/GetActiveGRDocsStatus?enterpriseCode=${enterpriseCode}'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseAsString = await response.stream.bytesToString();

      // print(responseAsString);
      if (responseAsString.contains("Message")) {
        //significa que deu algum erro
        _errorMessage = json.decode(responseAsString)["Message"];
        _isLoadingReceipt = false;
        notifyListeners();
        return;
      } else if (responseAsString.contains("!DOCTYPE HTML")) {
        _errorMessage =
            "Ocorreu um erro não esperado para consultar os produtos";
        _isLoadingReceipt = false;
        notifyListeners();
        return;
      }

      List responseAsList = json.decode(responseAsString.toString());
      Map responseAsMap = responseAsList.asMap();

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
      _errorMessage =
          "Ocorreu um erro não esperado na consulta dos recebimentos";
    } finally {
      _treatStatusMessage();
      _isLoadingReceipt = false;
      notifyListeners();
    }
  }

  _treatStatusMessage() {
    _receipts.forEach((element) {
      if (element.Status == "8") {
        element.Status = "Aguardando a liberação para entrada";
      } else if (element.Status == "6") {
        element.Status = "Aguardando a manutenção dos produtos";
      } else if (element.Status == "4") {
        element.Status = "Em processo de autorização";
      } else if (element.Status == "3") {
        element.Status = "Liberado para entrada (aguardando entrada)";
      } else if (element.Status == "1") {
        element.Status = "Utilizado para uma entrada (finalizado)";
      } else {
        element.Status = "Status desconhecido. Avise o suporte";
      }
    });
    notifyListeners();
  }

  void _updateAtualStatus({
    required int index,
  }) {
    ReceiptModel receiptWithNewStatus = ReceiptModel(
      CodigoInterno_ProcRecebDoc: _receipts[index].CodigoInterno_ProcRecebDoc,
      CodigoInterno_Empresa: _receipts[index].CodigoInterno_Empresa,
      Numero_ProcRecebDoc: _receipts[index].Numero_ProcRecebDoc,
      EmitterName: _receipts[index].EmitterName,
      Status:
          "Em processo de autorização", //sempre que da certo a liberação, fica com esse status
    );

    _receipts[index] = receiptWithNewStatus;
    notifyListeners();
  }

  liberate({required int grDocCode, required int index, required}) async {
    _isLoadingLiberateCheck = true;
    _liberateError = "";
    notifyListeners();

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'POST',
          Uri.parse(
              '${BaseUrl.url}/GoodsReceiving/LiberateGRDoc?grDocCode=${grDocCode}'));
      request.body = json.encode(UserIdentity.identity);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final responseInString = await response.stream.bytesToString();

      print("responseInString receiptProvider ${responseInString}");
      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _liberateError = json.decode(responseInString)["Message"];
        _isLoadingLiberateCheck = false;
        notifyListeners();
        return;
      } else if (responseInString.contains("!DOCTYPE HTML")) {
        _liberateError =
            "Ocorreu um erro não esperado para consultar os produtos";
        _isLoadingLiberateCheck = false;
        notifyListeners();
        return;
      } else {
        _updateAtualStatus(index: index);
      }
    } catch (e) {
      _liberateError = "Ocorreu um erro não esperado para efetuar a liberação";
    }

    _isLoadingLiberateCheck = false;
    notifyListeners();
  }
}

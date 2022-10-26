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
    _liberateError = "";
    // notifyListeners();
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

      print(responseAsString);
      if (_haveReceiptError(responseAsString)) {
        //precisa tratar o erro aqui porque não cai no catch se no
        //responseAsString tiver alguma mensagem de erro, por isso ele continua
        //a execução do código abaixo e aí sim da erro, fazendo com que
        //apresente a mensagem de erro errada
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
      //a mensagem de erro precisa ser tratada antes de chegar aqui, pois não
      //pode continuar a execução do código caso no "responseAsString" tenha
      //alguma mensagem de erro
    } finally {
      _treatStatusMessage();
      _isLoadingReceipt = false;
      notifyListeners();
    }
  }

  bool _haveReceiptError(
    String responseAsString,
  ) {
    if (responseAsString.contains(
        "Ocorreu um erro não esperado durante o acesso ao banco de dados do Celta Business Solutions")) {
      _errorMessage =
          "Ocorreu um erro não esperado durante o acesso ao banco de dados do Celta Business Solutions. Este tipo de problema normalmente está ligado à questões de configuração ou à equivocos de desenvolvimento. Fale com seu administrador de sistema ou com nosso suporte técnico para maiores detalhes.";
      return true;
    } else if (responseAsString
        .contains("O Celta Business Solutions enviou uma solicitação")) {
      _errorMessage =
          "O Celta Business Solutions enviou uma solicitação ao banco de dados que não respondeu no tempo esperado (timeout). Caso este problema persista, entre em contato com o nosso suporte técnico para que possamos resolvê-lo o mais rápido possível.";
      return true;
    } else if (responseAsString.contains(
        "Nenhum documento para recebimento de mercadorias foi encontrado")) {
      _errorMessage =
          "Nenhum documento para recebimento de mercadorias foi encontrado no Celta Business Solutions. Caso você sinta que isto está incorreto, entre em contato com o administrador do seu sistema.";
      return true;
    } else {
      return false;
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

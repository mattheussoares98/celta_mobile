import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/user_identity.dart';
import '../Models/receipt_model.dart';

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
    required int enterpriseCode,
    required BuildContext context,
    bool isSearchingAgain = false,
  }) async {
    _receipts.clear();
    _isLoadingReceipt = true;
    _errorMessage = '';
    if (isSearchingAgain) notifyListeners();
    //Quando libera o documento, consulta os recebimentos novamente para atualizar os status corretamente de acordo com o que está no BS. Já quando consulta ao entrar na página de recebimentos, não pode usar o notifyListeners senão da erro no debug console
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
      }

      print(responseAsString);
      ReceiptModel.responseAsStringToReceiptModel(
        responseAsString: responseAsString,
        listToAdd: _receipts,
      );
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessage,
        context: context,
      );
    } finally {
      _treatStatusMessageAndColor();
      _isLoadingReceipt = false;
      notifyListeners();
    }
  }

  _treatStatusMessageAndColor() {
    _receipts.forEach((element) {
      if (element.Status == "1") {
        element.Status = "Utilizado por uma entrada(Finalizado)";
        element.StatusColor = Colors.red;
      } else if (element.Status == "2") {
        element.Status = "Cancelado (Finalizado)";
        element.StatusColor = Colors.red;
      } else if (element.Status == "3") {
        element.Status = "Liberado para entrada (Aguardando entrada)";
        element.StatusColor = Colors.green;
      } else if (element.Status == "4" || element.Status == "7") {
        element.Status = "Em processo de autorização";
        element.StatusColor = Colors.blue;
      } else if (element.Status == "5" || element.Status == "6") {
        element.Status = "Aguardando manutenção de produtos)";
      } else if (element.Status == "8") {
        element.Status = "Aguardando liberação para entrada";
      } else {
        element.Status = "Status desconhecido. Avise o suporte";
        element.StatusColor = Colors.red;
      }
    });
    notifyListeners();
  }

  liberate({
    required int grDocCode,
    required int index,
    required BuildContext context,
    required int enterpriseCode,
  }) async {
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

        ShowErrorMessage.showErrorMessage(
          error: _liberateError,
          context: context,
        );
        notifyListeners();
        return;
      } else if (responseInString.contains("!DOCTYPE HTML")) {
        _liberateError =
            "Ocorreu um erro não esperado para consultar os produtos";
        _isLoadingLiberateCheck = false;
        notifyListeners();
        return;
      } else {
        await getReceipt(
          enterpriseCode: enterpriseCode,
          context: context,
          isSearchingAgain: true,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _liberateError = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _liberateError,
        context: context,
      );
    }

    _isLoadingLiberateCheck = false;
    notifyListeners();
  }
}

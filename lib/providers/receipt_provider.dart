import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../models/enterprise/enterprise.dart';
import '../models/receipt/receipt.dart';
import '../utils/utils.dart';
import './providers.dart';

class ReceiptProvider with ChangeNotifier {
  final List<ReceiptModel> _receipts = [];

  List<ReceiptModel> get receipts => [..._receipts];
  int get receiptCount => _receipts.length;
  bool _isLoadingReceipt = false;

  bool get isLoadingReceipt => _isLoadingReceipt;
  bool _isLoadingLiberateCheck = false;

  bool get isLoadingLiberateCheck => _isLoadingLiberateCheck;
  static String _errorMessage = '';

  String get errorMessage => _errorMessage;
  static String _errorMessageLiberate = '';

  List<ReceiptProductsModel> _products = [];
  List<ReceiptProductsModel> get products => _products;
  int get productsCount => _products.length;
  bool _isLoadingProducts = false;

  get isLoadingProducts => _isLoadingProducts;
  String _errorMessageGetProducts = "";

  get errorMessageGetProducts => _errorMessageGetProducts;
  String _errorMessageUpdateQuantity = "";

  get errorMessageUpdateQuantity => _errorMessageUpdateQuantity;

  var consultProductFocusNode = FocusNode();
  var consultedProductFocusNode = FocusNode();

  clearProducts() {
    _products = [];
    notifyListeners();
  }

  void _updateAtualQuantity({
    required int index,
    required double quantity,
    required bool isAnnulQuantity,
    required bool isSubtract,
    required BuildContext context,
  }) {
    if (isSubtract) {
      if (_products[index].Quantidade_ProcRecebDocProEmb == -1) {
        _products[index].Quantidade_ProcRecebDocProEmb = 0;
      }
      quantity =
          (_products[index].Quantidade_ProcRecebDocProEmb ?? 0) + quantity;
    } else if (_products[index].Quantidade_ProcRecebDocProEmb != -1) {
      quantity =
          (_products[index].Quantidade_ProcRecebDocProEmb ?? 0) + quantity;
    }

    if (isAnnulQuantity) {
      _products[index].Quantidade_ProcRecebDocProEmb = -1;
      _products[index].DataValidade_ProcRecebDocProEmb = "";
    } else {
      _products[index].Quantidade_ProcRecebDocProEmb = quantity;
    }
    notifyListeners();
  }

  bool _isLoadingUpdateQuantity = false;

  get isLoadingUpdateQuantity => _isLoadingUpdateQuantity;
  updateQuantity({
    required int docCode,
    required int productgCode,
    required int productPackingCode,
    required String
        quantityText, //o parâmetro é recebido via String porque vem de um controller de um textFormField
    required int index,
    required BuildContext context,
    required bool isSubtract,
    required String validityDate,
  }) async {
    quantityText = quantityText.replaceAll(RegExp(r','), '.');
    var quantity = double.parse(quantityText);

    if (isSubtract && _products[index].Quantidade_ProcRecebDocProEmb == -1) {
      _isLoadingUpdateQuantity = false;
      _errorMessageUpdateQuantity = "A quantidade não pode ficar negativa!";
      ShowSnackbarMessage.show(
        message: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    } else if (isSubtract &&
        quantity > (_products[index].Quantidade_ProcRecebDocProEmb ?? 0) &&
        _products[index].Quantidade_ProcRecebDocProEmb != -1) {
      _isLoadingUpdateQuantity = false;
      _errorMessageUpdateQuantity = "A quantidade não pode ficar negativa!";
      ShowSnackbarMessage.show(
        message: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    }
    if (isSubtract) {
      quantity = quantity - quantity * 2;
    }

    _errorMessageUpdateQuantity = "";
    _isLoadingUpdateQuantity = true;

    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.receiptEntryQuantity,
    );

    try {
      Map<String, dynamic> parameters = {
        "crossIdentity": UserData.crossIdentity,
        "grDocCode": docCode,
        "productgCode": productgCode,
        "productPackingCode": productPackingCode,
        "quantity": quantity,
      };
      if (validityDate != "") {
        parameters["validityDate"] = validityDate;
      }
      await SoapRequest.soapPost(
        parameters: parameters,
        typeOfResponse: "EntryQuantityResponse",
        SOAPAction: "EntryQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
      );

      _errorMessageUpdateQuantity = SoapRequestResponse.errorMessage;
      if (_errorMessageUpdateQuantity == "") {
        _updateAtualQuantity(
          context: context,
          index: index,
          quantity: quantity,
          isAnnulQuantity: false,
          isSubtract: isSubtract,
        );
      } else {
        ShowSnackbarMessage.show(
          message: _errorMessageUpdateQuantity,
          context: context,
        );
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(consultedProductFocusNode);
      });

      _products[index].DataValidade_ProcRecebDocProEmb = validityDate;
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageUpdateQuantity,
        context: context,
      );
    } finally {
      _isLoadingUpdateQuantity = false;
      notifyListeners();
    }
  }

  anullQuantity({
    required int docCode,
    required int productgCode,
    required int productPackingCode,
    required int index,
    required BuildContext context,
  }) async {
    if (_products[index].Quantidade_ProcRecebDocProEmb == 0 ||
        _products[index].Quantidade_ProcRecebDocProEmb == -1) {
      //se a quantidade for igual à atual, não precisa fazer a requisição
      _errorMessageUpdateQuantity = "A quantidade já está nula";
      ShowSnackbarMessage.show(
        message: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    }
    _errorMessageUpdateQuantity = "";
    _isLoadingUpdateQuantity = true;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.receiptEntryQuantity,
    );

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "grDocCode": docCode,
          "productgCode": productgCode,
          "productPackingCode": productPackingCode,
        },
        typeOfResponse: "AnnulQuantityResponse",
        SOAPAction: "AnnulQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
      );

      _errorMessageUpdateQuantity = SoapRequestResponse.errorMessage;

      if (_errorMessageUpdateQuantity == "") {
        _updateAtualQuantity(
          index: index,
          quantity: 0,
          isAnnulQuantity: true,
          isSubtract: false,
          context: context,
        );
      } else {
        ShowSnackbarMessage.show(
          message: _errorMessageUpdateQuantity,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageUpdateQuantity,
        context: context,
      );
    }

    _isLoadingUpdateQuantity = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required int docCode,
    required String controllerText,
    required BuildContext context,
    required bool isSearchAllCountedProducts,
    required ConfigurationsProvider configurationsProvider,
    required EnterpriseModel enterprise,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _isLoadingProducts = true;
    notifyListeners();

    try {
      await SoapHelper.getProductReceipt(
        configurationsProvider: configurationsProvider,
        searchValue: controllerText,
        docCode: docCode,
        isSearchAllCountedProducts: isSearchAllCountedProducts,
        enterprise: enterprise,
      );

      _errorMessageGetProducts = SoapRequestResponse.errorMessage;

      if (_errorMessageGetProducts == "") {
        ReceiptProductsModel.dataToReceiptConferenceModel(
          data: SoapRequestResponse.responseAsMap["Produtos"],
          listToAdd: _products,
        );
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          //se não colocar em um future pra mudar o foco, não funciona corretamente
          FocusScope.of(context).requestFocus(consultProductFocusNode);
          //altera o foco para o campo de pesquisa novamente
        });
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageGetProducts = DefaultErrorMessage.ERROR;
    }
    _isLoadingProducts = false;
    notifyListeners();
  }

  String get errorMessageLiberate => _errorMessageLiberate;
  Future<void> getReceipt({
    required int enterpriseCode,
    required BuildContext context,
    bool isSearchingAgain = false,
  }) async {
    if (_isLoadingReceipt) return;

    _receipts.clear();
    _isLoadingReceipt = true;
    _errorMessage = '';
    if (isSearchingAgain) notifyListeners();
    //Quando libera o documento, consulta os recebimentos novamente para
    //atualizar os status corretamente de acordo com o que está no BS. Já quando
    //consulta ao entrar na página de recebimentos, não pode usar o
    //notifyListeners senão da erro no debug console. Só está atualizando o
    //código acima porque está sendo chamado dentro de um setState

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "enterpriseCode": enterpriseCode,
        },
        typeOfResponse: "GetActiveGRDocsStatusResponse",
        SOAPAction: "GetActiveGRDocsStatus",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetActiveGRDocsStatusResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage == "") {
        ReceiptModel.dataToReceiptModel(
          data: SoapRequestResponse.responseAsMap["ProcRecebDocumentos"],
          listToAdd: _receipts,
        );
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessage = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessage,
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
    required EnterpriseModel enterprise,
  }) async {
    _isLoadingLiberateCheck = true;
    _errorMessageLiberate = "";
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.receiptLiberate,
    );

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "grDocCode": grDocCode,
        },
        typeOfResponse: "LiberateGRDocResponse",
        SOAPAction: "LiberateGRDoc",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "LiberateGRDocResult",
      );

      _errorMessageLiberate = SoapRequestResponse.errorMessage;

      if (_errorMessageLiberate == "") {
        //quando da certo a liberação, precisa consultar novamente os documentos pra atualizar o status corretamente
        await getReceipt(
          enterpriseCode: enterprise.Code,
          context: context,
          isSearchingAgain: true,
        );
      } else {
        ShowSnackbarMessage.show(
          message: _errorMessageLiberate,
          context: context,
        );
      }
    } catch (e) {
      //print("Erro para efetuar a requisição: $e");
      _errorMessageLiberate = DefaultErrorMessage.ERROR;
      ShowSnackbarMessage.show(
        message: _errorMessageLiberate,
        context: context,
      );
    }

    _isLoadingLiberateCheck = false;
    notifyListeners();
  }
}

import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/api/firebase_helper.dart';
import 'package:celta_inventario/api/soap_helper.dart';
import 'package:flutter/material.dart';
import '../Models/receipt_models/receipt_model.dart';
import '../Models/receipt_models/receipt_products_model.dart';
import '../utils/user_identity.dart';

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
  get products => _products;
  get productsCount => _products.length;
  bool _consultingProducts = false;

  get consultingProducts => _consultingProducts;
  String _errorMessageGetProducts = "";

  get errorMessageGetProducts => _errorMessageGetProducts;
  String _errorMessageUpdateQuantity = "";

  get errorMessageUpdateQuantity => _errorMessageUpdateQuantity;
  bool _isLoadingValidityDate = false;
  get isLoadingValidityDate => _isLoadingValidityDate;

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
      quantity = _products[index].Quantidade_ProcRecebDocProEmb + quantity;
    } else if (_products[index].Quantidade_ProcRecebDocProEmb != -1) {
      quantity = _products[index].Quantidade_ProcRecebDocProEmb + quantity;
    }

    if (isAnnulQuantity) {
      _products[index].Quantidade_ProcRecebDocProEmb = -1;
      _products[index].DataValidade_ProcRecebDocProEmb = "";
    } else {
      _products[index].Quantidade_ProcRecebDocProEmb = quantity;
    }
    notifyListeners();
  }

  bool _isUpdatingQuantity = false;

  get isUpdatingQuantity => _isUpdatingQuantity;
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
      _isUpdatingQuantity = false;
      _errorMessageUpdateQuantity = "A quantidade não pode ficar negativa!";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    } else if (isSubtract &&
        quantity > _products[index].Quantidade_ProcRecebDocProEmb &&
        _products[index].Quantidade_ProcRecebDocProEmb != -1) {
      _isUpdatingQuantity = false;
      _errorMessageUpdateQuantity = "A quantidade não pode ficar negativa!";
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    }
    if (isSubtract) {
      quantity = quantity - quantity * 2;
    }

    _isLoadingValidityDate = true;
    _errorMessageUpdateQuantity = "";
    _isUpdatingQuantity = true;

    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.receiptEntryQuantity,
    );

    try {
      Map<String, dynamic> parameters = {
        "crossIdentity": UserIdentity.identity,
        "grDocCode": docCode,
        "productgCode": productgCode,
        "productPackingCode": productPackingCode,
        "quantity": quantity,
      };
      if (validityDate != "") {
        parameters["validityDate"] = validityDate;
      }
      await SoapHelper.soapPost(
        parameters: parameters,
        typeOfResponse: "EntryQuantityResponse",
        SOAPAction: "EntryQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
      );

      _errorMessageUpdateQuantity = SoapHelperResponseParameters.errorMessage;
      if (_errorMessageUpdateQuantity == "") {
        _updateAtualQuantity(
          context: context,
          index: index,
          quantity: quantity,
          isAnnulQuantity: false,
          isSubtract: isSubtract,
        );
      } else {
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageUpdateQuantity,
          context: context,
        );
      }

      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(consultedProductFocusNode);
      });

      _products[index].DataValidade_ProcRecebDocProEmb = validityDate;
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
    } finally {
      _isLoadingValidityDate = false;
      _isUpdatingQuantity = false;
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
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
      notifyListeners();
      return;
    }
    _errorMessageUpdateQuantity = "";
    _isUpdatingQuantity = true;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.receiptAnullQuantity,
    );

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "grDocCode": docCode,
          "productgCode": productgCode,
          "productPackingCode": productPackingCode,
        },
        typeOfResponse: "AnnulQuantityResponse",
        SOAPAction: "AnnulQuantity",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
      );

      _errorMessageUpdateQuantity = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageUpdateQuantity == "") {
        _updateAtualQuantity(
          index: index,
          quantity: 0,
          isAnnulQuantity: true,
          isSubtract: false,
          context: context,
        );
      } else {
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageUpdateQuantity,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageUpdateQuantity =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageUpdateQuantity,
        context: context,
      );
    }

    _isUpdatingQuantity = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required int docCode,
    required String controllerText,
    required BuildContext context,
    required bool isLegacyCodeSearch,
    required bool isSearchAllCountedProducts,
  }) async {
    _products.clear();
    _errorMessageGetProducts = "";
    _consultingProducts = true;
    notifyListeners();

    int searchTypeInt = 0;
    if (isLegacyCodeSearch) searchTypeInt = 11;
    if (isSearchAllCountedProducts) searchTypeInt = 19;

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "searchTypeInt": searchTypeInt,
          "searchValue": controllerText,
          "grDocCode": docCode,
        },
        typeOfResponse: "GetProductResponse",
        SOAPAction: "GetProduct",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetProductResult",
      );

      _errorMessageGetProducts = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageGetProducts == "") {
        ReceiptProductsModel.dataToReceiptConferenceModel(
          data: SoapHelperResponseParameters.responseAsMap["Produtos"],
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
      print("Erro para efetuar a requisição: $e");
      _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _consultingProducts = false;
    notifyListeners();
  }

  String get errorMessageLiberate => _errorMessageLiberate;
  Future<void> getReceipt({
    required int enterpriseCode,
    required BuildContext context,
    bool isSearchingAgain = false,
  }) async {
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
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "enterpriseCode": enterpriseCode,
        },
        typeOfResponse: "GetActiveGRDocsStatusResponse",
        SOAPAction: "GetActiveGRDocsStatus",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "GetActiveGRDocsStatusResult",
      );

      _errorMessage = SoapHelperResponseParameters.errorMessage;

      if (_errorMessage == "") {
        ReceiptModel.dataToReceiptModel(
          data:
              SoapHelperResponseParameters.responseAsMap["ProcRecebDocumentos"],
          listToAdd: _receipts,
        );
      }
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
    _errorMessageLiberate = "";
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.receiptLiberate,
    );

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "grDocCode": grDocCode,
        },
        typeOfResponse: "LiberateGRDocResponse",
        SOAPAction: "LiberateGRDoc",
        serviceASMX: "CeltaGoodsReceivingService.asmx",
        typeOfResult: "LiberateGRDocResult",
      );

      _errorMessageLiberate = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageLiberate == "") {
        //quando da certo a liberação, precisa consultar novamente os documentos pra atualizar o status corretamente
        await getReceipt(
          enterpriseCode: enterpriseCode,
          context: context,
          isSearchingAgain: true,
        );
      } else {
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageLiberate,
          context: context,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorMessageLiberate = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageLiberate,
        context: context,
      );
    }

    _isLoadingLiberateCheck = false;
    notifyListeners();
  }
}

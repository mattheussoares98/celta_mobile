import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/firebase_helper.dart';
import 'package:celta_inventario/utils/soap_helper.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/cupertino.dart';
import '../Models/price_conference_product_model.dart';

class PriceConferenceProvider with ChangeNotifier {
  List<PriceConferenceProductsModel> _products = [];

  get products => _products;
  get productsCount => _products.length;
  bool _isLoading = false;

  get isLoading => _isLoading;
  String _errorMessage = "";

  get errorMessage => _errorMessage;
  convertSalePracticedRetailToDouble() {
    _products.forEach((element) {
      element.SalePracticedRetail =
          element.SalePracticedRetail.toString().replaceAll(RegExp(r','), '.');

      int pointQuantity =
          ".".allMatches(element.SalePracticedRetail.toString()).length;
      for (var x = 1; x < pointQuantity; x++) {
        if (x < pointQuantity && pointQuantity > 1) {
          element.SalePracticedRetail = element.SalePracticedRetail.toString()
              .replaceFirst(RegExp(r'\.'), '');
        }
      }

      element.SalePracticedRetail =
          double.tryParse(element.SalePracticedRetail);
    });
  }

  clearProducts() {
    _products.clear();
    notifyListeners();
  }

  changeFocusToConsultProduct({required BuildContext context}) {
    FocusScope.of(context).requestFocus(consultProductFocusNode);
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String controllerText, //em string pq vem de um texfFormField
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    _products.clear();
    _errorMessage = "";
    _isLoading = true;
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.priceConferenceGetProduct,
    );

    dynamic value = int.tryParse(controllerText);
    //o valor pode ser em inteiro ou em texto
    if (value == null) {
      //retorna nulo quando não consegue converter para inteiro. Se não
      //conseguir converter precisa consultar por nome, por isso pode usar o
      //próprio texto do "controllerText"
      value = controllerText;
    }

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "enterpriseCode": enterpriseCode,
          "searchValue": controllerText,
          "searchTypeInt": isLegacyCodeSearch ? 11 : 0,
        },
        typeOfResponse: "GetProductCmxJsonResponse",
        SOAPAction: "GetProductCmxJson",
        serviceASMX: "CeltaProductService.asmx",
        typeOfResult: "GetProductCmxJsonResult",
      );

      _errorMessage = SoapHelperResponseParameters.errorMessage;
      if (_errorMessage == "") {
        PriceConferenceProductsModel.resultAsStringToConsultPriceModel(
          data: SoapHelperResponseParameters.responseAsMap["Produtos"],
          listToAdd: _products,
        );
      }
    } catch (e) {
      print("Erro para efetuar a requisição : $e");
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    }
    _isLoading = false;
    notifyListeners();
  }

  final consultProductFocusNode = FocusNode();

  Future<void> getProduct({
    required int enterpriseCode,
    required String controllerText,
    required BuildContext context,
    required bool isLegacyCodeSearch,
  }) async {
    await _getProducts(
      enterpriseCode: enterpriseCode,
      controllerText: controllerText,
      context: context,
      isLegacyCodeSearch: isLegacyCodeSearch,
    );

    if (_errorMessage != "") {
      //quando da erro para consultar os produtos, muda o foco novamente para o
      //campo de pesquisa dos produtos
      Future.delayed(const Duration(milliseconds: 100), () {
        //se não colocar em um future pra mudar o foco, não funciona corretamente
        FocusScope.of(context).requestFocus(consultProductFocusNode);
        //altera o foco para o campo de pesquisa novamente
      });
    }

    notifyListeners();
  }

  bool _isSendingToPrint = false;

  bool get isSendingToPrint => _isSendingToPrint;

  String _errorSendToPrint = "";

  String get errorSendToPrint => _errorSendToPrint;

  Future<void> sendToPrint({
    required int enterpriseCode,
    required int productPackingCode,
    required int index,
    required BuildContext context,
  }) async {
    _isSendingToPrint = true;
    _errorSendToPrint = "";
    notifyListeners();

    FirebaseHelper.addSoapCallInFirebase(
      firebaseCallEnum: FirebaseCallEnum.priceConferenceSendToPrint,
    );

    bool newValue = !_products[index].EtiquetaPendente;

    try {
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserIdentity.identity,
          "enterpriseCode": enterpriseCode,
          "productPackingCode": productPackingCode,
          "send": newValue,
        },
        typeOfResponse: "SendToPrintResponse",
        SOAPAction: "SendToPrint",
        serviceASMX: "CeltaPriceConferenceService.asmx",
      );
      _errorSendToPrint = SoapHelperResponseParameters.errorMessage;

      if (_errorSendToPrint == "") {
        _products[index].EtiquetaPendente = !_products[index].EtiquetaPendente;
      }
      //como deu certo a marcação/desmarcação, precisa atualizar na lista local se está marcado ou não
    } catch (e) {
      print("Erro para efetuar a requisição: $e");
      _errorSendToPrint = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isSendingToPrint = false;
      notifyListeners();
    }
  }

  orderByUpPrice() {
    convertSalePracticedRetailToDouble();
    _products
        .sort((a, b) => a.SalePracticedRetail.compareTo(b.SalePracticedRetail));

    notifyListeners();
  }

  orderByDownPrice() {
    convertSalePracticedRetailToDouble();

    _products
        .sort((a, b) => b.SalePracticedRetail.compareTo(a.SalePracticedRetail));

    notifyListeners();
  }

  orderByUpName() {
    _products.sort((a, b) => a.Name.compareTo(b.Name));

    notifyListeners();
  }

  orderByDownName() {
    _products.sort((a, b) => b.Name.compareTo(a.Name));
    notifyListeners();
  }
}

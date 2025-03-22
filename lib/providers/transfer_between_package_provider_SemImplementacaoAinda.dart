// import 'dart:convert';

// import 'package:flutter/material.dart';

// import '../api/api.dart';
// import '../components/components.dart';
// import '../Models/soap/soap.dart';
// import '../Models/transfer_between_package/transfer_between_package.dart';
// import '../utils/utils.dart';
// import './providers.dart';

// class TransferBetweenPackageProvider with ChangeNotifier {
//   List<GetProductCmxJson> _products = [];
//   List<GetProductCmxJson> get products => _products;
//   int get productsCount => _products.length;

//   String _errorMessageGetProducts = '';
//   String get errorMessageGetProducts => _errorMessageGetProducts;

//   static bool _isLoadingProducts = false;
//   bool get isLoadingProducts => _isLoadingProducts;

//   List<TransferBetweenPackageJustificationsModel> _justifications = [];
//   List<TransferBetweenPackageJustificationsModel> get justifications =>
//       _justifications;

//   String _errorMessageTypeStockAndJustifications = '';
//   String get errorMessageTypeStockAndJustifications =>
//       _errorMessageTypeStockAndJustifications;

//   String _errorMessageAdjustStock = '';
//   String get errorMessageAdjustStock => _errorMessageAdjustStock;

//   // List<TransferBetweenPackageTypeModel> _originPackage = [];
//   // List<TransferBetweenPackageTypeModel> get originPackage => _originPackage;

//   // List<TransferBetweenPackageTypeModel> _destinyPackage = [];
//   // List<TransferBetweenPackageTypeModel> get destinyPackage => _destinyPackage;

//   List<GetStockTypesModel> _originStockTypes = [];
//   List<GetStockTypesModel> get originStockTypes => _originStockTypes;

//   List<GetStockTypesModel> _destinyStockTypes = [];
//   List<GetStockTypesModel> get destinyStockTypes => _destinyStockTypes;

//   Map<String, dynamic> jsonAdjustStock = {
//     "EnterpriseCode": -1, //esse parâmetro vem da tela de empresas
//     "ProductCode": -1, //quando clica no produto, altera o código
//     "ProductPackingCode": -1, //quando clica no produto, altera o código
//     "JustificationCode":
//         -1, //sempre que seleciona a opção do dropdown altera o valor aqui
//     "StockTypeCode":
//         -1, //sempre que seleciona a opção do dropdown altera o valor aqui
//     "StockTypeRecipientCode": -1,
//     "Quantity":
//         -0.1 //quando clica em "alterar", valida se a quantidade é válida e se os dropdowns do estoque e justificativa estão selecionados. Caso esteja tudo certo, altera a quantidade do json de acordo com o que o usuário digitou
//   };

//   String _lastUpdatedQuantity = "";
//   int _indexOfLastProductChangedStockQuantity =
//       -1; //index do último produto alterado. Serve para só exibir a mensagem da última quantidade alterada no produto correto

//   static bool _isLoadingAdjustStock = false;
//   bool get isLoadingAdjustStock => _isLoadingAdjustStock;

//   static bool _isLoadingTypeStockAndJustifications = false;
//   bool get isLoadingTypeStockAndJustifications =>
//       _isLoadingTypeStockAndJustifications;

//   var consultProductFocusNode = FocusNode();
//   var consultedProductFocusNode = FocusNode();

//   String typeOperator =
//       ""; //quando clica na opção de justificativa, obtém o tipo de operador "-" ou "+". Isso é usado pra atualizar o estoque do produto consultado após confirmar a alteração

//   String get lastUpdatedQuantity => _lastUpdatedQuantity;
//   int get indexOfLastProductChangedStockQuantity =>
//       _indexOfLastProductChangedStockQuantity;

//   bool _justificationHasStockType = false;
//   bool get justificationHasStockType => _justificationHasStockType;
//   set justificationHasStockType(bool value) {
//     _justificationHasStockType = value;
//     notifyListeners();
//   }

//   String _justificationStockTypeName = "";
//   String get justificationStockTypeName => _justificationStockTypeName;
//   updateJustificationStockTypeName(String newValue) {
//     _justificationStockTypeName = newValue;
//     notifyListeners();
//   }

//   clearProductsJustificationsPackageAndJsonAdjustStock() {
//     _justifications.clear();
//     // _originPackage.clear();
//     // _destinyPackage.clear();
//     _products.clear();
//     jsonAdjustStock.clear();
//     _lastUpdatedQuantity = "";
//     _indexOfLastProductChangedStockQuantity = -1;
//     notifyListeners();
//   }

//   Future<void> _getProducts({
//     required int enterpriseCode,
//     required String controllerText, //em string pq vem de um texfFormField
//     required BuildContext context,
//     required bool isLegacyCodeSearch,
//   }) async {
//     _errorMessageGetProducts = "";
//     _isLoadingProducts = true;
//     _originStockTypes.clear();
//     _destinyStockTypes.clear();
//     _justifications.clear();
//     _justificationStockTypeName = "";
//     _justificationHasStockType = false;

//     notifyListeners();

//     try {
//       await SoapHelper.getGetProductCmxJson(
//         enterpriseCode: enterpriseCode,
//         searchValue: controllerText,
//         isLegacyCodeSearch: isLegacyCodeSearch,
//         listToAdd: _products,
//       );
//     } catch (e) {
//       //print("Erro para efetuar a requisição na nova forma de consulta: $e");
//       _errorMessageGetProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
//     }
//     _isLoadingProducts = false;
//     notifyListeners();
//   }

//   Future<void> getProducts({
//     required int enterpriseCode,
//     required String controllerText,
//     required BuildContext context,
//     required ConfigurationsProvider configurationsProvider,
//   }) async {
//     _lastUpdatedQuantity = "";
//     _indexOfLastProductChangedStockQuantity = -1;
//     _products.clear();
//     notifyListeners();

//     await _getProducts(
//       enterpriseCode: enterpriseCode,
//       controllerText: controllerText,
//       context: context,
//       isLegacyCodeSearch: configurationsProvider.useLegacyCode,
//     );

//     if (_products.isNotEmpty) {
//       await _getStockTypeAndJustifications(context);
//       return;
//     }

//     if (_errorMessageGetProducts != "") {
//       //quando da erro para consultar os produtos, muda o foco novamente para o
//       //campo de pesquisa dos produtos
//       Future.delayed(const Duration(milliseconds: 100), () {
//         //se não colocar em um future pra mudar o foco, não funciona corretamente
//         FocusScope.of(context).requestFocus(consultProductFocusNode);
//         //altera o foco para o campo de pesquisa novamente
//       });
//       // ShowErrorMessage.showErrorMessage(
//       //   error: _errorMessageGetProducts,
//       //   context: context,
//       // );
//     }
//     notifyListeners();
//   }

//   _getJustificationsType(BuildContext context) async {
//     _justifications.clear();
//     notifyListeners();
//     try {
//       await SoapRequest.soapPost(
//         parameters: {
//           "crossIdentity": UserData.crossIdentity,
//           'simpleSearchValue': 'undefined',
//           "justificationTransferType": 4,
//         },
//         typeOfResponse: "GetJustificationsResponse",
//         typeOfResult: "GetJustificationsResult",
//         SOAPAction: "GetJustifications",
//         serviceASMX: "CeltaProductService.asmx",
//       );

//       if (SoapRequestResponse.errorMessage != "") {
//         _errorMessageTypeStockAndJustifications =
//             SoapRequestResponse.errorMessage;
//       }
//       if (_errorMessageTypeStockAndJustifications == "") {
//         TransferBetweenPackageJustificationsModel
//             .resultAsStringToTransferBetweenPackageJustificationsModel(
//           resultAsString: SoapRequestResponse.responseAsString,
//           listToAdd: _justifications,
//         );
//       } else {
//         ShowSnackbarMessage.show(
//           message: _errorMessageTypeStockAndJustifications,
//           context: context,
//         );
//       }

//       _errorMessageTypeStockAndJustifications =
//           SoapRequestResponse.errorMessage;
//     } catch (e) {
//       //print("Erro para efetuar a requisição justifications: $e");
//       _errorMessageTypeStockAndJustifications =
//           DefaultErrorMessageToFindServer.ERROR_MESSAGE;
//     }
//     notifyListeners();
//   }

//   confirmAdjustStock({
//     required BuildContext context,
//     required int indexOfProduct,
//     required String consultedProductControllerText,
//   }) async {
//     _isLoadingAdjustStock = true;
//     _errorMessageAdjustStock = "";
//     notifyListeners();

//     FirebaseHelper.addSoapCallInFirebase(
//       FirebaseCallEnum.transferBetweenPackageConfirmAdjust,
//     );

//     try {
//       await SoapRequest.soapPost(
//         parameters: {
//           "crossIdentity": UserData.crossIdentity,
//           'jsonAdjustStock': jsonEncode(jsonAdjustStock),
//         },
//         SOAPAction: "ConfirmAdjustStock",
//         serviceASMX: "CeltaProductService.asmx",
//         typeOfResponse: "ConfirmAdjustStockResponse",
//       );

//       _errorMessageAdjustStock = SoapRequestResponse.errorMessage;

//       if (_errorMessageAdjustStock == "") {
//         typeOperator = typeOperator
//             .replaceAll(RegExp(r'\('), '')
//             .replaceAll(RegExp(r'\)'), '');
//         _lastUpdatedQuantity = jsonAdjustStock["Quantity"]!.toString();
//         _indexOfLastProductChangedStockQuantity = indexOfProduct;
//       }
//       _errorMessageAdjustStock = SoapRequestResponse.errorMessage;
//       if (SoapRequestResponse.errorMessage != "") {
//         ShowSnackbarMessage.show(
//           message: _errorMessageAdjustStock,
//           context: context,
//         );
//       }
//     } catch (e) {
//       //print("Erro para confirmar o ajuste: $e");
//       _errorMessageAdjustStock = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
//       ShowSnackbarMessage.show(
//         message: _errorMessageAdjustStock,
//         context: context,
//       );
//     }

//     _isLoadingAdjustStock = false;
//     notifyListeners();
//   }

//   Future<void> _getStockTypeAndJustifications(BuildContext context) async {
//     _isLoadingTypeStockAndJustifications = true;
//     _errorMessageTypeStockAndJustifications = "";
//     _justificationHasStockType = false;
//     notifyListeners();

//     await _getStockType(context);

//     await _getJustificationsType(context);

//     if (_errorMessageTypeStockAndJustifications != "") {
//       ShowSnackbarMessage.show(
//         message: _errorMessageTypeStockAndJustifications,
//         context: context,
//       );
//     }

//     _isLoadingTypeStockAndJustifications = false;
//     notifyListeners();
//   }

//   _getStockType(BuildContext context) async {
//     _originStockTypes.clear();
//     _destinyStockTypes.clear();
//     notifyListeners();
//     try {
//       await SoapHelper.getStockTypesModel(_destinyStockTypes);
//       await SoapHelper.getStockTypesModel(_originStockTypes);
//     } catch (e) {
//       //print("Erro para efetuar a requisição stockTypes: $e");
//       ShowSnackbarMessage.show(
//         message: _errorMessageTypeStockAndJustifications,
//         context: context,
//       );
//     }
//     notifyListeners();
//   }
// }

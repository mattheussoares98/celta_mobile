import 'dart:convert';

import 'package:celta_inventario/Models/sale_request_models/sale_request_costumer_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_products_model.dart';
import 'package:celta_inventario/Models/sale_request_models/sale_request_request_type_model.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:celta_inventario/utils/user_identity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/base_url.dart';
import '../utils/default_error_message_to_find_server.dart';

class SaleRequestProvider with ChangeNotifier {
  bool _isLoadingRequestType = false;
  bool get isLoadingRequestType => _isLoadingRequestType;
  String _errorMessageRequestType = "";
  String get errorMessageRequestType => _errorMessageRequestType;
  List<SaleRequestRequestTypeModel> _requests = [];
  get requests => [..._requests];

  bool _isLoadingCostumer = false;
  bool get isLoadingCostumer => _isLoadingCostumer;
  String _errorMessageCostumer = "";
  String get errorMessageCostumer => _errorMessageCostumer;
  List<SaleRequestCostumerModel> _costumers = [];
  get costumers => [..._costumers];

  bool _isLoadingProducts = false;
  bool get isLoadingProducts => _isLoadingProducts;
  String _errorMessageProducts = "";
  String get errorMessageProducts => _errorMessageProducts;
  List<SaleRequestProductsModel> _products = [];
  get products => [..._products];
  get productsCount => _products.length;

  FocusNode searchProductFocusNode = FocusNode();
  FocusNode consultedProductFocusNode = FocusNode();

  changeFocusToConsultedProduct(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(consultedProductFocusNode);
    });
  }

  Future<void> getRequestType({
    required int enterpriseCode,
    required BuildContext context,
  }) async {
    _isLoadingRequestType = true;
    _errorMessageRequestType = "";
    _requests.clear();
    // notifyListeners();
    //quando usa o notifylisteners ocorre um erro. Só está atualizando o código acima
    //porque está sendo chamado dentro de um setState

    try {
      var headers = {'Authorization': 'Bearer ${UserIdentity.identity}'};
      var request = http.Request(
          'GET',
          Uri.parse(
              '${BaseUrl.url}/SaleRequest/RequestType?enterpriseCode=$enterpriseCode&searchValue=%'));
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();
      print('resposta para consulta do RequestType = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageRequestType = json.decode(responseInString)["Message"];
        _isLoadingRequestType = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageRequestType,
          context: context,
        );
        notifyListeners();
        return;
      }

      String resposta =
          "[\n  {\n    \"Code\": 1,\n    \"PersonalizedCode\": \"Venda\",\n    \"Name\": \"Venda\",\n    \"OperationType\": true,\n    \"TransferUnitValueType\": true,\n    \"UseWholePrice\": true\n  },\n  {\n    \"Code\": 4,\n    \"PersonalizedCode\": \"XVendas\",\n    \"Name\": \"XVendas\",\n    \"OperationType\": true,\n    \"TransferUnitValueType\": true,\n    \"UseWholePrice\": true\n  }\n]";

      resposta = resposta
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceAll(RegExp(r' '), '');

      responseInString = resposta;

      SaleRequestRequestTypeModel.responseAsStringToSaleRequestRequestTypeModel(
        responseAsString: responseInString,
        listToAdd: _requests,
      );
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorMessageRequestType = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageRequestType,
        context: context,
      );
    }

    _isLoadingRequestType = false;
    notifyListeners();
  }

  Future<void> getCostumers({
    required BuildContext context,
    required String searchValueControllerText,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName
    int? codeValue = int.tryParse(searchValueControllerText);
    if (codeValue == null) {
      await _getCostumers(
        context: context,
        searchTypeInt: 3, //ApproximateName
        searchValueControllerText: searchValueControllerText,
      );
    } else {
      await _getCostumers(
        context: context,
        searchTypeInt: 2, //exactCode
        searchValueControllerText: searchValueControllerText,
      );

      if (_costumers.isNotEmpty) return;

      await _getCostumers(
        context: context,
        searchTypeInt: 1, //exactCnpjCpfNumber
        searchValueControllerText: searchValueControllerText,
      );
    }
  }

  Future<void> _getCostumers({
    required BuildContext context,
    required int searchTypeInt,
    required String searchValueControllerText,
  }) async {
// 1=ExactCnpjCpfNumber
// 2=ExactCode
// 3=ApproximateName

    _costumers.clear();
    _errorMessageCostumer = "";
    _isLoadingCostumer = false;
    notifyListeners();

    try {
      var headers = {'Authorization': 'Bearer ${UserIdentity.identity}'};
      var request = http.Request(
        'GET',
        Uri.parse(
          '${BaseUrl.url}/Customer/Customer?searchTypeInt=$searchTypeInt&searchValue=$searchValueControllerText',
        ),
      );
      request.body = '''''';
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String responseInString = await response.stream.bytesToString();
      print('resposta para consulta do RequestType = $responseInString');

      if (responseInString.contains("Message")) {
        //significa que deu algum erro
        _errorMessageRequestType = json.decode(responseInString)["Message"];
        _isLoadingRequestType = false;
        ShowErrorMessage.showErrorMessage(
          error: _errorMessageRequestType,
          context: context,
        );
        notifyListeners();
        return;
      }

      String resposta =
          "[{\"Code\":5,\"PersonalizedCode\":\"5\",\"Name\":\"1Pessoa Fisica SP\",\"ReducedName\":\"1Pessoa Fisica SP\",\"CpfCnpjNumber\":\"13198543894\",\"RegistrationNumber\":\"197741435\",\"SexType\":\"M\"},{\"Code\":15,\"PersonalizedCode\":\"15\",\"Name\":\"Cleusa Oliveira Braga Oliveira Confecções - ME\",\"ReducedName\":\"\",\"CpfCnpjNumber\":\"10249388000112\",\"RegistrationNumber\":\"ISENTO\",\"SexType\":\"M\"},{\"Code\":1,\"PersonalizedCode\":\"1\",\"Name\":\"Consumidor\",\"ReducedName\":\"\",\"CpfCnpjNumber\":\"1\",\"RegistrationNumber\":\"\",\"SexType\":\"M\"},{\"Code\":10,\"PersonalizedCode\":\"10\",\"Name\":\"Estrangeiro\",\"ReducedName\":\"Estrangeiro\",\"CpfCnpjNumber\":\"10\",\"RegistrationNumber\":\"11111111111\",\"SexType\":\"M\"},{\"Code\":16,\"PersonalizedCode\":\"16\",\"Name\":\"Lixo\",\"ReducedName\":\"Lixo\",\"CpfCnpjNumber\":\"44444444444\",\"RegistrationNumber\":\"197741435\",\"SexType\":\"M\"},{\"Code\":386,\"PersonalizedCode\":\"01020304\",\"Name\":\"Mattheus Soares\",\"ReducedName\":\"\",\"CpfCnpjNumber\":\"39367504837\",\"RegistrationNumber\":\"37722006\",\"SexType\":\"M\"},{\"Code\":17,\"PersonalizedCode\":\"5\",\"Name\":\"Nome\",\"ReducedName\":\"Nome\",\"CpfCnpjNumber\":\"55555555555\",\"RegistrationNumber\":\"\",\"SexType\":\"M\"},{\"Code\":12,\"PersonalizedCode\":\"12\",\"Name\":\"Pessoa fisica BA\",\"ReducedName\":\"\",\"CpfCnpjNumber\":\"22222222222\",\"RegistrationNumber\":\"2222\",\"SexType\":\"M\"},{\"Code\":4,\"PersonalizedCode\":\"4\",\"Name\":\"Pessoa Fisica CE\",\"ReducedName\":\"Pessoa Fisica CE\",\"CpfCnpjNumber\":\"19316702003\",\"RegistrationNumber\":\"11005390\",\"SexType\":\"M\"},{\"Code\":7,\"PersonalizedCode\":\"7\",\"Name\":\"Pessoa Fisica MA\",\"ReducedName\":\"Pessoa Fisica MA\",\"CpfCnpjNumber\":\"10699935814\",\"RegistrationNumber\":\"11005390\",\"SexType\":\"M\"},{\"Code\":9,\"PersonalizedCode\":\"9\",\"Name\":\"Pessoa Fisica MG\",\"ReducedName\":\"Pessoa Fisica MG\",\"CpfCnpjNumber\":\"12710259656\",\"RegistrationNumber\":\"31971633064\",\"SexType\":\"M\"},{\"Code\":8,\"PersonalizedCode\":\"8\",\"Name\":\"Pessoa Fisica RJ\",\"ReducedName\":\"Pessoa Fisica RJ\",\"CpfCnpjNumber\":\"45472332842\",\"RegistrationNumber\":\"11635300\",\"SexType\":\"M\"},{\"Code\":6,\"PersonalizedCode\":\"6\",\"Name\":\"Pessoa Jurídica BA\",\"ReducedName\":\"Pessoa Jurídica BA\",\"CpfCnpjNumber\":\"09060984000170\",\"RegistrationNumber\":\"075.086.240\",\"SexType\":\"M\"},{\"Code\":3,\"PersonalizedCode\":\"3\",\"Name\":\"Pessoa Juridica RJ\",\"ReducedName\":\"Pessoa Juridica RJ\",\"CpfCnpjNumber\":\"27356901000177\",\"RegistrationNumber\":\"11005390\",\"SexType\":\"M\"},{\"Code\":13,\"PersonalizedCode\":\"13\",\"Name\":\"Pessoa Juridica SC\",\"ReducedName\":\"Pessoa Juridica SC\",\"CpfCnpjNumber\":\"79525242001040\",\"RegistrationNumber\":\"258992220\",\"SexType\":\"M\"},{\"Code\":2,\"PersonalizedCode\":\"2\",\"Name\":\"Pessoa Juridica SP\",\"ReducedName\":\"Pessoa Juridica SP\",\"CpfCnpjNumber\":\"16839728000141\",\"RegistrationNumber\":\"387130395117\",\"SexType\":\"M\"},{\"Code\":11,\"PersonalizedCode\":\"11\",\"Name\":\"Pessoa Júridica ZFM\",\"ReducedName\":\"Pessoa Jurídica ZFM\",\"CpfCnpjNumber\":\"15803174000160\",\"RegistrationNumber\":\"041841557\",\"SexType\":\"M\"},{\"Code\":371,\"PersonalizedCode\":\"371\",\"Name\":\"REIDI SÃO PAULO\",\"ReducedName\":\"\",\"CpfCnpjNumber\":\"10347996000160\",\"RegistrationNumber\":\"148298358119\",\"SexType\":\"M\"}]";

      resposta = resposta
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceAll(RegExp(r' '), '');

      responseInString = resposta;

      SaleRequestCostumerModel.responseAsStringToSaleRequestCostumerModel(
        responseAsString: responseInString,
        listToAdd: _costumers,
      );
    } catch (e) {
      print("Erro para obter os clientes: $e");
      _errorMessageCostumer = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageCostumer,
        context: context,
      );
    }

    _isLoadingRequestType = false;
    notifyListeners();
  }

  Future<void> _getProducts({
    required int enterpriseCode,
    required String searchValueControllerText,
    required int searchTypeInt,
    required BuildContext context,
  }) async {
// 2=ExactPriceLookUp
// 4=ExactEan
// 6=ApproximateName
// 11=ApproximateLegacyCode

    _products.clear();
    _errorMessageProducts = "";
    _isLoadingProducts = true;
    notifyListeners();

    try {
      // var headers = {
      //   // 'Authorization': 'Bearer ${UserIdentity.identity}',
      //   'Authorization': 'Bearer ',
      // };
      // var request = http.Request(
      //   'GET',
      //   Uri.parse(
      //     '${BaseUrl.url}/SaleRequest/Product?enterpriseCode=$enterpriseCode&searchTypeInt=$searchTypeInt&searchValue=$searchValueControllerText',
      //   ),
      // );
      // request.body = '''''';
      // request.headers.addAll(headers);

      // http.StreamedResponse response = await request.send();
      // String responseInString = await response.stream.bytesToString();
      // print('resposta para consulta do RequestType = $responseInString');

      // if (responseInString.contains("Message")) {
      //   //significa que deu algum erro
      //   _errorMessageRequestType = json.decode(responseInString)["Message"];
      //   _isLoadingRequestType = false;
      //   ShowErrorMessage.showErrorMessage(
      //     error: _errorMessageRequestType,
      //     context: context,
      //   );
      //   notifyListeners();
      //   return;
      // }

      String resposta =
          "[{\"ProductCode\":4,\"ProductPackingCode\":3,\"PLU\":\"00002-4\",\"Name\":\"Isento\",\"PackingQuantity\":\"UN 1\",\"RetailPracticedPrice\":0.99,\"RetailSalePrice\":0.99,\"RetailOfferPrice\":0.00,\"WholePracticedPrice\":0.88,\"WholeSalePrice\":0.88,\"WholeOfferPrice\":0.00,\"ECommercePracticedPrice\":0.00,\"ECommerceSalePrice\":0.00,\"ECommerceOfferPrice\":0.00,\"MinimumWholeQuantity\":3.000,\"BalanceStockSale\":134.000},{\"ProductCode\":4,\"ProductPackingCode\":77,\"PLU\":\"00013-0\",\"Name\":\"Isento\",\"PackingQuantity\":\"CX 12\",\"RetailPracticedPrice\":11.88,\"RetailSalePrice\":11.88,\"RetailOfferPrice\":0.00,\"WholePracticedPrice\":10.56,\"WholeSalePrice\":10.56,\"WholeOfferPrice\":0.00,\"ECommercePracticedPrice\":0.00,\"ECommerceSalePrice\":0.00,\"ECommerceOfferPrice\":0.00,\"MinimumWholeQuantity\":3.000,\"BalanceStockSale\":20.000}]";

      resposta = resposta
          .replaceAll(RegExp(r'\\'), '')
          .replaceAll(RegExp(r'\n'), '')
          .replaceAll(RegExp(r' '), '');

      // responseInString = resposta;

      SaleRequestProductsModel.responseAsStringToSaleRequestProductsModel(
        responseAsString: resposta,
        listToAdd: _products,
      );
    } catch (e) {
      print("Erro para obter os produtos: $e");
      _errorMessageProducts = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
      ShowErrorMessage.showErrorMessage(
        error: _errorMessageProducts,
        context: context,
      );
    }

    _isLoadingProducts = false;
    notifyListeners();
  }

  Future<void> getProducts({
    required BuildContext context,
    required int enterpriseCode,
    required String searchValueControllerText,
  }) async {
// 2=ExactPriceLookUp
// 4=ExactEan
// 6=ApproximateName
// 11=ApproximateLegacyCode

    int? searchTypeInt = int.tryParse(searchValueControllerText);

    if (searchTypeInt == null) {
      //como não conseguiu converter para inteiro, significa que precisa consultar por nome
      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 6, //approximateName
        context: context,
      );
    } else {
      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 4, //ExactEan
        context: context,
      );

      if (_products.isNotEmpty) return;

      await _getProducts(
        enterpriseCode: enterpriseCode,
        searchValueControllerText: searchValueControllerText,
        searchTypeInt: 2, //ExactPriceLookup == PLU
        context: context,
      );
    }
  }
}

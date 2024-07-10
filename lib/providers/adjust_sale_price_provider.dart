import 'package:celta_inventario/api/soap/soap.dart';
import 'package:celta_inventario/models/soap/products/get_product_json/get_product_json_model.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';

import 'providers.dart';

class AdjustSalePriceProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<GetProductJsonModel> _products = [];
  List<GetProductJsonModel> get products => [..._products];

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  List<String> get saleOrOffer => ["Venda", "Oferta"];
  List<Map<String, bool?>> replicationParameters = [
    {"Embalagens": false},
    {"Agrupamento operacional": false},
    {"Classe": false},
    {"Grade": false},
  ];

  Future<void> getProducts({
    required int enterpriseCode,
    required String searchValue,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    _isLoading = true;
    _products.clear();
    _errorMessage = "";
    notifyListeners();

    try {
      await SoapHelper.getProductJsonModel(
        listToAdd: _products,
        enterpriseCode: enterpriseCode,
        searchValue: searchValue,
        configurationsProvider: configurationsProvider,
        routineTypeInt: 0,
      );

      _errorMessage = SoapRequestResponse.errorMessage;
    } catch (e) {
      _errorMessage = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

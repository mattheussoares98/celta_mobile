import 'package:celta_inventario/models/firebase/firebase.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';

class WebProvider with ChangeNotifier {
  bool _isLoadingClients = false;
  bool get isLoadingClients => _isLoadingClients;

  String _errorMessageClients = "";
  String get errorMessageClients => _errorMessageClients;

  bool _isLoadingSoapActions = false;
  bool get isLoadingSoapActions => _isLoadingSoapActions;

  String _errorMessageSoapActions = "";
  String get errorMessageSoapActions => _errorMessageSoapActions;

  int selectedBottomNavigationBarIndex = 0;

  List<FirebaseClientModel> _clients = [];
  List<FirebaseClientModel> get clients => [..._clients];

  List<SoapActionsModel> _lastThreeMonths = [];
  List<SoapActionsModel> get lastThreeMonths => [..._lastThreeMonths];

  List<String> _clientsNames = [];
  List<String> get clientsNames => [..._clientsNames];

  List<SoapActionsModel> _atualMonth = [];
  List<SoapActionsModel> get atualMonth => [..._atualMonth];
  List<SoapActionsModel> _penultimateMonth = [];
  List<SoapActionsModel> get penultimateMonth => [..._penultimateMonth];
  List<SoapActionsModel> _antiPenultimateMonth = [];
  List<SoapActionsModel> get antiPenultimateMonth => [..._antiPenultimateMonth];

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoadingClients = true;
    _errorMessageClients = "";
    notifyListeners();

    try {
      await FirebaseHelper.signIn(
        email: email,
        password: password,
      );
    } catch (e) {
      _errorMessageClients = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingClients = false;
      notifyListeners();
    }
  }

  Future<void> getAllClients() async {
    _isLoadingClients = true;
    _errorMessageClients = "";
    _clients.clear();
    notifyListeners();

    try {
      final clients = await FirebaseHelper.getAllClients();

      _clients = clients
          .map(
            (element) => FirebaseClientModel.fromJson(
              json: element.data() as Map,
              id: element.id,
            ),
          )
          .toList();

      _clients.sort((a, b) => a.enterpriseName.compareTo(b.enterpriseName));
    } catch (e) {
      _errorMessageClients = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingClients = false;
      notifyListeners();
    }
  }

  List<String> _getLastThreeMonts() {
    DateTime now = DateTime.now();
    List<String> lastThreeMonths = [];

    for (int i = 0; i < 3; i++) {
      DateTime date = DateTime(now.year, now.month - i, 1);
      String formattedDate = DateFormat('yyyy-MM').format(date);
      lastThreeMonths.add(formattedDate);
    }

    return lastThreeMonths;
  }

  void _updateAllClientsNames() {
    _clientsNames.clear();
    notifyListeners();

    for (var atual in _atualMonth) {
      if (_clientsNames.contains(atual.documentId)) {
        continue;
      } else {
        _clientsNames.add(atual.documentId);
      }
    }
    for (var atual in _penultimateMonth) {
      if (_clientsNames.contains(atual.documentId)) {
        continue;
      } else {
        _clientsNames.add(atual.documentId);
      }
    }
    for (var atual in _antiPenultimateMonth) {
      if (_clientsNames.contains(atual.documentId)) {
        continue;
      } else {
        _clientsNames.add(atual.documentId);
      }
    }
    notifyListeners();
  }

  int getTotalRequestsByMonth({
    required String clientName,
    required List<SoapActionsModel> monthSoapActions,
  }) {
    int counter = 0;
    final soap =
        monthSoapActions.where((element) => element.documentId == clientName);

    if (soap.isEmpty) {
      return 0;
    } else {}

    sumValueIfHas(int? request) {
      if (request != null) {
        counter += request;
      }
    }

    sumValueIfHas(soap.first.adjustStockConfirmQuantity);
    sumValueIfHas(soap.first.priceConferenceGetProductOrSendToPrint);
    sumValueIfHas(soap.first.inventoryEntryQuantity);
    sumValueIfHas(soap.first.receiptEntryQuantity);
    sumValueIfHas(soap.first.receiptLiberate);
    sumValueIfHas(soap.first.saleRequestSave);
    sumValueIfHas(soap.first.transferBetweenStocksConfirmAdjust);
    sumValueIfHas(soap.first.transferBetweenPackageConfirmAdjust);
    sumValueIfHas(soap.first.transferRequestSave);
    sumValueIfHas(soap.first.customerRegister);
    sumValueIfHas(soap.first.buyRequestSave);
    sumValueIfHas(soap.first.researchPricesInsertPrice);

    return counter;
  }

  int getTotalRequestsByLastThreeMonths(String clientName) {
    int total = 0;

    total += getTotalRequestsByMonth(
        clientName: clientName, monthSoapActions: _atualMonth);
    total += getTotalRequestsByMonth(
        clientName: clientName, monthSoapActions: _penultimateMonth);
    total += getTotalRequestsByMonth(
        clientName: clientName, monthSoapActions: _antiPenultimateMonth);

    return total;
  }

  Future<dynamic> getLastThreeMonthsSoapActions() async {
    _isLoadingSoapActions = true;
    _errorMessageSoapActions = "";
    _lastThreeMonths.clear();

    notifyListeners();

    try {
      List lastThreeMonths = _getLastThreeMonts();
      final atualMonth =
          await FirebaseHelper.getAllSoapActions(lastThreeMonths[0]);
      final penultimateMonth =
          await FirebaseHelper.getAllSoapActions(lastThreeMonths[1]);
      final antiPenultimateMonth =
          await FirebaseHelper.getAllSoapActions(lastThreeMonths[2]);

      if (atualMonth != null) {
        _atualMonth = atualMonth
            .map((element) => SoapActionsModel.fromJson(
                  documentId: element.id,
                  json: element.data() as Map<String, dynamic>,
                ))
            .toList();
      } else {
        throw Exception();
      }

      if (penultimateMonth != null) {
        _penultimateMonth = penultimateMonth
            .map((element) => SoapActionsModel.fromJson(
                  documentId: element.id,
                  json: element.data() as Map<String, dynamic>,
                ))
            .toList();
      } else {
        throw Exception();
      }

      if (antiPenultimateMonth != null) {
        _antiPenultimateMonth = antiPenultimateMonth
            .map((element) => SoapActionsModel.fromJson(
                  documentId: element.id,
                  json: element.data() as Map<String, dynamic>,
                ))
            .toList();
      } else {
        throw Exception();
      }

      _updateAllClientsNames();
    } catch (e) {
      _errorMessageSoapActions = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoadingSoapActions = false;
      notifyListeners();
    }
  }
}

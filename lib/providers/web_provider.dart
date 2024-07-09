import 'package:celta_inventario/components/global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/models/firebase/firebase.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';

class WebProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessageClients = "";
  String get errorMessageClients => _errorMessageClients;

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

  void _orderEnterprisesByName() {
    _clients.sort((a, b) => a.enterpriseName.compareTo(b.enterpriseName));
  }

  int? _sumRequests(
    int? totalLastThree,
    int? totalEqualSoapClientName,
  ) {
    int total = 0;

    if (totalLastThree != null) {
      total += totalLastThree;
    }

    if (totalEqualSoapClientName != null) {
      total += totalEqualSoapClientName;
    }

    if (total > 0) {
      return total;
    } else {
      return null;
    }
  }

  List _mergeDates({
    required int indexOfEqualSoap,
    required SoapActionsModel soapAction,
  }) {
    var newDates = [];

    for (var date in _lastThreeMonths[indexOfEqualSoap].datesUsed!) {
      if (soapAction.datesUsed!.contains(date)) {
        continue;
      } else {
        newDates.add(date);
      }
    }
    return newDates;
  }

  List _mergeUsers({
    required int indexOfEqualSoap,
    required SoapActionsModel soapAction,
  }) {
    var newUsers = [];

    for (var user in _lastThreeMonths[indexOfEqualSoap].users!) {
      if (soapAction.users!.contains(user)) {
        continue;
      } else {
        newUsers.add(user);
      }
    }
    return newUsers;
  }

  void _mergeMonthInLastTrheeMonths(List<SoapActionsModel> listToMerge) {
    for (var soapAction in listToMerge) {
      int indexOfEqualSoap = _lastThreeMonths
          .indexWhere((element) => element.documentId == soapAction.documentId);

      if (indexOfEqualSoap != -1) {
        final mergedAction = SoapActionsModel(
          documentId: soapAction.documentId,
          datesUsed: _mergeDates(
            indexOfEqualSoap: indexOfEqualSoap,
            soapAction: soapAction,
          ),
          users: _mergeUsers(
            indexOfEqualSoap: indexOfEqualSoap,
            soapAction: soapAction,
          ),
          adjustStockConfirmQuantity: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].adjustStockConfirmQuantity,
            soapAction.adjustStockConfirmQuantity,
          ),
          priceConferenceGetProductOrSendToPrint: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap]
                .priceConferenceGetProductOrSendToPrint,
            soapAction.priceConferenceGetProductOrSendToPrint,
          ),
          inventoryEntryQuantity: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].inventoryEntryQuantity,
            soapAction.inventoryEntryQuantity,
          ),
          receiptEntryQuantity: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].receiptEntryQuantity,
            soapAction.receiptEntryQuantity,
          ),
          receiptLiberate: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].receiptLiberate,
            soapAction.receiptLiberate,
          ),
          saleRequestSave: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].saleRequestSave,
            soapAction.saleRequestSave,
          ),
          transferBetweenStocksConfirmAdjust: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap]
                .transferBetweenStocksConfirmAdjust,
            soapAction.transferBetweenStocksConfirmAdjust,
          ),
          transferBetweenPackageConfirmAdjust: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap]
                .transferBetweenPackageConfirmAdjust,
            soapAction.transferBetweenPackageConfirmAdjust,
          ),
          transferRequestSave: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].transferRequestSave,
            soapAction.transferRequestSave,
          ),
          customerRegister: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].customerRegister,
            soapAction.customerRegister,
          ),
          buyRequestSave: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].buyRequestSave,
            soapAction.buyRequestSave,
          ),
          researchPricesInsertPrice: _sumRequests(
            _lastThreeMonths[indexOfEqualSoap].researchPricesInsertPrice,
            soapAction.researchPricesInsertPrice,
          ),
        );
        _lastThreeMonths[indexOfEqualSoap] = mergedAction;
      } else {
        _lastThreeMonths.add(soapAction);
      }
    }
  }

  void _mergeLastThreeMonths() {
    _lastThreeMonths.clear();

    _mergeMonthInLastTrheeMonths(_atualMonth);
    _mergeMonthInLastTrheeMonths(_penultimateMonth);
    _mergeMonthInLastTrheeMonths(_antiPenultimateMonth);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
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
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllClients() async {
    _isLoading = true;
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

      _orderEnterprisesByName();
    } catch (e) {
      _errorMessageClients = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
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
    }

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
    _isLoading = true;
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
      _mergeLastThreeMonths();
    } catch (e) {
      _errorMessageSoapActions = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEnterprise({
    required BuildContext context,
    required String enterpriseId,
  }) async {
    _isLoading = true;
    _errorMessageClients = "";

    try {
      await FirebaseHelper.deleteEnterprise(enterpriseId);

      _clients.removeWhere((element) => element.id == enterpriseId);

      Navigator.of(context).pop();
      ShowSnackbarMessage.showMessage(
        message: "Empresa excluída com sucesso",
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    } catch (e) {
      ShowSnackbarMessage.showMessage(
        message: DefaultErrorMessageToFindServer.ERROR_MESSAGE,
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEnterpriseCcs({
    required BuildContext context,
    required String enterpriseId,
    required String newUrlCcs,
  }) async {
    _isLoading = true;
    _errorMessageClients = "";

    try {
      int indexOfOldClient =
          _clients.indexWhere((element) => element.id == enterpriseId);

      if (indexOfOldClient == -1) {
        throw Exception();
      }

      final oldClient = _clients[indexOfOldClient];

      await FirebaseHelper.updateUrlCcs(newUrl: newUrlCcs, client: oldClient);

      _clients[indexOfOldClient] = FirebaseClientModel(
        id: enterpriseId,
        urlCCS: newUrlCcs,
        usersInformations: oldClient.usersInformations,
        enterpriseName: oldClient.enterpriseName,
      );

      Navigator.of(context).pop();
      ShowSnackbarMessage.showMessage(
        message: "URL alterada com sucesso",
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );

      notifyListeners();
    } catch (e) {
      ShowSnackbarMessage.showMessage(
        message: e.toString(),
        context: context,
      );
    } finally {
      _isLoading = false;
    }
  }

  Future<void> addNewEnterprise({
    required BuildContext context,
    required String enterpriseName,
    required String urlCcs,
  }) async {
    _isLoading = true;
    _errorMessageClients = "";
    try {
      final newEnterprise = FirebaseClientModel(
        enterpriseName: enterpriseName,
        urlCCS: urlCcs,
        id: null,
        usersInformations: null,
      );

      await FirebaseHelper.addNewEnterprise(newEnterprise);

      _clients.add(newEnterprise);
      _orderEnterprisesByName();

      Navigator.of(context).pop();

      ShowSnackbarMessage.showMessage(
        message: "Empresa adicionada com sucesso!",
        context: context,
        backgroundColor: Theme.of(context).colorScheme.primary,
      );
    } catch (e) {
      ShowSnackbarMessage.showMessage(
        message: "Ocorreu um erro não esperado para adicionar a empresa!",
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

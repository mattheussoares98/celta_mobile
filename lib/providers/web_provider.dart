import 'package:celta_inventario/components/global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/models/firebase/firebase.dart';
import 'package:celta_inventario/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';

enum Months {
  AtualMonth,
  PenultimateMonth,
  AntiPenultimateMonth,
}

class WebProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessageClients = "";
  String get errorMessageClients => _errorMessageClients;

  String _errorMessageSoapActions = "";
  String get errorMessageSoapActions => _errorMessageSoapActions;

  int selectedBottomNavigationBarIndex = 0;

  List<FirebaseEnterpriseModel> _enterprises = [];
  List<FirebaseEnterpriseModel> get enterprises => [..._enterprises];

  Set<String> _enterprisesNames = {};
  Set<String> get enterprisesNames => _enterprisesNames;

  Map<String, List<SoapActionsModel>> _dataFromLastTrheeMonths = {
    Months.AtualMonth.name: <SoapActionsModel>[],
    Months.PenultimateMonth.name: <SoapActionsModel>[],
    Months.AntiPenultimateMonth.name: <SoapActionsModel>[],
  };

  Map<String, List<SoapActionsModel>> get dataFromLastTrheeMonths =>
      _dataFromLastTrheeMonths;

  void _orderEnterprisesByName() {
    _enterprises.sort((a, b) => a.enterpriseName.compareTo(b.enterpriseName));
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
    _enterprises.clear();
    notifyListeners();

    try {
      final clients = await FirebaseHelper.getAllClients();

      _enterprises = clients
          .map(
            (element) => FirebaseEnterpriseModel.fromJson(
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

  Future<dynamic> getLastThreeMonthsSoapActions() async {
    _isLoading = true;
    _errorMessageSoapActions = "";

    notifyListeners();

    try {
      List<String> lastThreeMonths = _getLastThreeMonts();

      final atualMonth =
          await FirebaseHelper.getAllSoapActions(lastThreeMonths[0]);

      final penultimateMonth =
          await FirebaseHelper.getAllSoapActions(lastThreeMonths[1]);
      final antiPenultimateMonth =
          await FirebaseHelper.getAllSoapActions(lastThreeMonths[2]);

      if (atualMonth != null &&
          penultimateMonth != null &&
          antiPenultimateMonth != null) {
        _dataFromLastTrheeMonths[Months.AtualMonth.name] = atualMonth
            .map((element) => SoapActionsModel.fromJson(
                  documentId: element.id,
                  json: element.data() as Map<String, dynamic>,
                ))
            .toList();

        _dataFromLastTrheeMonths[Months.PenultimateMonth.name] =
            penultimateMonth
                .map((element) => SoapActionsModel.fromJson(
                      documentId: element.id,
                      json: element.data() as Map<String, dynamic>,
                    ))
                .toList();

        _dataFromLastTrheeMonths[Months.AntiPenultimateMonth.name] =
            antiPenultimateMonth
                .map((element) => SoapActionsModel.fromJson(
                      documentId: element.id,
                      json: element.data() as Map<String, dynamic>,
                    ))
                .toList();

        for (var atualMonthData in atualMonth) {
          _enterprisesNames.add(atualMonthData.id);
        }
        for (var atualMonthData in penultimateMonth) {
          _enterprisesNames.add(atualMonthData.id);
        }
        for (var atualMonthData in antiPenultimateMonth) {
          _enterprisesNames.add(atualMonthData.id);
        }

        final ordenatedList = _enterprisesNames.toList()..sort();
        _enterprisesNames = ordenatedList.toSet();
      } else {
        throw Exception();
      }
    } catch (e) {
      _errorMessageSoapActions = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int getTotalSoapActions({
    required List<Months> months,
    required String clientName,
  }) {
    int totalRequests = 0;

    for (var month in months) {
      bool contains = _dataFromLastTrheeMonths[month.name]!
          .any((element) => element.documentId == clientName);

      if (!contains) {
        return totalRequests;
      }

      final clientData = _dataFromLastTrheeMonths[month.name]!
          .where((element) => element.documentId == clientName)
          .first;

      totalRequests += clientData.adjustStockConfirmQuantity ?? 0;
      totalRequests += clientData.priceConferenceGetProductOrSendToPrint ?? 0;
      totalRequests += clientData.inventoryEntryQuantity ?? 0;
      totalRequests += clientData.receiptEntryQuantity ?? 0;
      totalRequests += clientData.receiptLiberate ?? 0;
      totalRequests += clientData.saleRequestSave ?? 0;
      totalRequests += clientData.transferBetweenStocksConfirmAdjust ?? 0;
      totalRequests += clientData.transferBetweenPackageConfirmAdjust ?? 0;
      totalRequests += clientData.transferRequestSave ?? 0;
      totalRequests += clientData.customerRegister ?? 0;
      totalRequests += clientData.buyRequestSave ?? 0;
      totalRequests += clientData.researchPricesInsertPrice ?? 0;
    }

    return totalRequests;
  }

  Future<void> deleteEnterprise({
    required BuildContext context,
    required String enterpriseId,
  }) async {
    _isLoading = true;
    _errorMessageClients = "";

    try {
      await FirebaseHelper.deleteEnterprise(enterpriseId);

      _enterprises.removeWhere((element) => element.id == enterpriseId);

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
    notifyListeners();

    try {
      int indexOfOldClient =
          _enterprises.indexWhere((element) => element.id == enterpriseId);

      if (indexOfOldClient == -1) {
        throw Exception();
      }

      final oldClient = _enterprises[indexOfOldClient];

      await FirebaseHelper.updateUrlCcs(newUrl: newUrlCcs, client: oldClient);

      _enterprises[indexOfOldClient] = FirebaseEnterpriseModel(
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
    } catch (e) {
      ShowSnackbarMessage.showMessage(
        message: e.toString(),
        context: context,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
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
      final newEnterprise = FirebaseEnterpriseModel(
        enterpriseName: enterpriseName,
        urlCCS: urlCcs,
        id: null,
        usersInformations: null,
      );

      await FirebaseHelper.addNewEnterprise(newEnterprise);

      _enterprises.add(newEnterprise);
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

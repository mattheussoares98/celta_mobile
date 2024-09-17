import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/components.dart';
import '../../models/firebase/firebase.dart';
import '../../utils/utils.dart';
import '../api/api.dart';
import '../models/modules/modules.dart';

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

  int _indexOfSelectedEnterprise = -1;
  int get indexOfSelectedEnterprise => _indexOfSelectedEnterprise;
  set indexOfSelectedEnterprise(int newValue) {
    _indexOfSelectedEnterprise = newValue;

    final modules = _enterprises[_indexOfSelectedEnterprise].modules;

    _selectedModules = [
      ModuleViewModel(
        name: "Ajuste de preços",
        enabled: modules?.adjustSalePrice == true,
      ),
      ModuleViewModel(
        name: "Ajuste de estoques",
        enabled: modules?.adjustStock == true,
      ),
      ModuleViewModel(
        name: "Pedido de compra",
        enabled: modules?.buyRequest == true,
      ),
      ModuleViewModel(
        name: "Cadastro de cliente",
        enabled: modules?.customerRegister == true,
      ),
      ModuleViewModel(
        name: "Inventário",
        enabled: modules?.inventory == true,
      ),
      ModuleViewModel(
        name: "Consulta de preços",
        enabled: modules?.priceConference == true,
      ),
      ModuleViewModel(
        name: "Conferência de produtos (expedição)",
        enabled: modules?.productsConference == true,
      ),
      ModuleViewModel(
        name: "Recebimento",
        enabled: modules?.receipt == true,
      ),
      ModuleViewModel(
        name: "Consulta de preços concorrentes",
        enabled: modules?.researchPrices == true,
      ),
      ModuleViewModel(
        name: "Pedido de vendas",
        enabled: modules?.saleRequest == true,
      ),
      ModuleViewModel(
        name: "Transferência entre estoques",
        enabled: modules?.transferBetweenStocks == true,
      ),
      ModuleViewModel(
        name: "Pedido de transferência",
        enabled: modules?.transferRequest == true,
      ),
    ];
    notifyListeners();
  }

  List<ModuleViewModel> _selectedModules = [];
  List<ModuleViewModel> get selectedModules => _selectedModules;

  SoapActionsModel _sumMonthRequests({
    required List<SoapActionsModel> monthsData,
    required String enterpriseName,
  }) {
    int adjustStockConfirmQuantity = 0;
    int priceConferenceGetProductOrSendToPrint = 0;
    int inventoryEntryQuantity = 0;
    int receiptEntryQuantity = 0;
    int receiptLiberate = 0;
    int saleRequestSave = 0;
    int transferBetweenStocksConfirmAdjust = 0;
    int transferBetweenPackageConfirmAdjust = 0;
    int transferRequestSave = 0;
    int customerRegister = 0;
    int buyRequestSave = 0;
    int researchPricesInsertPrice = 0;

    for (var monthData in monthsData) {
      if (monthData.adjustStockConfirmQuantity != null) {
        adjustStockConfirmQuantity += monthData.adjustStockConfirmQuantity!;
      }
      if (monthData.priceConferenceGetProductOrSendToPrint != null) {
        priceConferenceGetProductOrSendToPrint +=
            monthData.priceConferenceGetProductOrSendToPrint!;
      }
      if (monthData.inventoryEntryQuantity != null) {
        inventoryEntryQuantity += monthData.inventoryEntryQuantity!;
      }
      if (monthData.receiptEntryQuantity != null) {
        receiptEntryQuantity += monthData.receiptEntryQuantity!;
      }
      if (monthData.receiptLiberate != null) {
        receiptLiberate += monthData.receiptLiberate!;
      }
      if (monthData.saleRequestSave != null) {
        saleRequestSave += monthData.saleRequestSave!;
      }
      if (monthData.transferBetweenStocksConfirmAdjust != null) {
        transferBetweenStocksConfirmAdjust +=
            monthData.transferBetweenStocksConfirmAdjust!;
      }
      if (monthData.transferBetweenPackageConfirmAdjust != null) {
        transferBetweenPackageConfirmAdjust +=
            monthData.transferBetweenPackageConfirmAdjust!;
      }
      if (monthData.transferRequestSave != null) {
        transferRequestSave += monthData.transferRequestSave!;
      }
      if (monthData.customerRegister != null) {
        customerRegister += monthData.customerRegister!;
      }
      if (monthData.buyRequestSave != null) {
        buyRequestSave += monthData.buyRequestSave!;
      }
      if (monthData.researchPricesInsertPrice != null) {
        researchPricesInsertPrice += monthData.researchPricesInsertPrice!;
      }
    }

    return SoapActionsModel(
      documentId: enterpriseName,
      datesUsed: [],
      users: [],
      adjustStockConfirmQuantity:
          adjustStockConfirmQuantity == 0 ? null : adjustStockConfirmQuantity,
      priceConferenceGetProductOrSendToPrint:
          priceConferenceGetProductOrSendToPrint == 0
              ? null
              : priceConferenceGetProductOrSendToPrint,
      inventoryEntryQuantity:
          inventoryEntryQuantity == 0 ? null : inventoryEntryQuantity,
      receiptEntryQuantity:
          receiptEntryQuantity == 0 ? null : receiptEntryQuantity,
      receiptLiberate: receiptLiberate == 0 ? null : receiptLiberate,
      saleRequestSave: saleRequestSave == 0 ? null : saleRequestSave,
      transferBetweenStocksConfirmAdjust:
          transferBetweenStocksConfirmAdjust == 0
              ? null
              : transferBetweenStocksConfirmAdjust,
      transferBetweenPackageConfirmAdjust:
          transferBetweenPackageConfirmAdjust == 0
              ? null
              : transferBetweenPackageConfirmAdjust,
      transferRequestSave:
          transferRequestSave == 0 ? null : transferRequestSave,
      customerRegister: customerRegister == 0 ? null : customerRegister,
      buyRequestSave: buyRequestSave == 0 ? null : buyRequestSave,
      researchPricesInsertPrice:
          researchPricesInsertPrice == 0 ? null : researchPricesInsertPrice,
    );
  }

  SoapActionsModel mergeLastThreeMonths(String enterpriseName) {
    final monthsThatHaveData = <SoapActionsModel>[];

    final atualMonthData = _dataFromLastTrheeMonths[Months.AtualMonth.name]
        ?.where((element) => element.documentId == enterpriseName);
    if (atualMonthData?.isEmpty == false) {
      monthsThatHaveData.add(atualMonthData!.first);
    }

    final penultimateMonth =
        _dataFromLastTrheeMonths[Months.PenultimateMonth.name]
            ?.where((element) => element.documentId == enterpriseName);
    if (penultimateMonth?.isEmpty == false) {
      monthsThatHaveData.add(penultimateMonth!.first);
    }

    final antiPenultimateMonth =
        _dataFromLastTrheeMonths[Months.AntiPenultimateMonth.name]
            ?.where((element) => element.documentId == enterpriseName);
    if (antiPenultimateMonth?.isEmpty == false) {
      monthsThatHaveData.add(antiPenultimateMonth!.first);
    }

    return _sumMonthRequests(
        monthsData: monthsThatHaveData, enterpriseName: enterpriseName);
  }

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

  List<String> yearAndMonthFromLastTrheeMonths() {
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
      List<String> lastThreeMonths = yearAndMonthFromLastTrheeMonths();

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
        continue;
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
        modules: oldClient.modules,
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
          modules: ModuleModel(
            adjustSalePrice: false,
            adjustStock: true,
            buyRequest: true,
            customerRegister: true,
            inventory: true,
            priceConference: true,
            productsConference: true,
            receipt: true,
            researchPrices: true,
            saleRequest: true,
            transferBetweenStocks: true,
            transferRequest: true,
          ));

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

  Future<void> enableOrDisableModule(int index) async {
    _isLoading = true;
    _errorMessageClients = "";
    notifyListeners();

    try {
      final client = _enterprises[_indexOfSelectedEnterprise];
      bool newValue = !_selectedModules[index].enabled;

      await FirebaseHelper.enableOrDisableModule(
        client: client,
        moduleName: _selectedModules[index].name,
        newValue: newValue,
      );

      updateValue(index);
    } catch (e) {
      _errorMessageClients = DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateValue(int index) {
    final oldValue = _selectedModules[index];
    ModuleViewModel newValue = ModuleViewModel(
      name: oldValue.name,
      enabled: !oldValue.enabled,
    );
    _selectedModules[index] = newValue;
    notifyListeners();
  }

  FirebaseEnterpriseModel getUpdatedClient(
    Modules module,
    FirebaseEnterpriseModel client,
  ) {
    return FirebaseEnterpriseModel(
      id: client.id,
      urlCCS: client.urlCCS,
      usersInformations: client.usersInformations,
      enterpriseName: client.enterpriseName,
      modules: ModuleModel(
        adjustSalePrice: module == Modules.adjustSalePrice
            ? !client.modules!.adjustSalePrice
            : client.modules!.adjustSalePrice,
        adjustStock: module == Modules.adjustStock
            ? !client.modules!.adjustStock
            : client.modules!.adjustStock,
        buyRequest: module == Modules.buyRequest
            ? !client.modules!.buyRequest
            : client.modules!.buyRequest,
        customerRegister: module == Modules.customerRegister
            ? !client.modules!.customerRegister
            : client.modules!.customerRegister,
        inventory: module == Modules.inventory
            ? !client.modules!.inventory
            : client.modules!.inventory,
        priceConference: module == Modules.priceConference
            ? !client.modules!.priceConference
            : client.modules!.priceConference,
        productsConference: module == Modules.productsConference
            ? !client.modules!.productsConference
            : client.modules!.productsConference,
        receipt: module == Modules.receipt
            ? !client.modules!.receipt
            : client.modules!.receipt,
        researchPrices: module == Modules.researchPrices
            ? !client.modules!.researchPrices
            : client.modules!.researchPrices,
        saleRequest: module == Modules.saleRequest
            ? !client.modules!.saleRequest
            : client.modules!.saleRequest,
        transferBetweenStocks: module == Modules.transferBetweenStocks
            ? !client.modules!.transferBetweenStocks
            : client.modules!.transferBetweenStocks,
        transferRequest: module == Modules.transferRequest
            ? !client.modules!.transferRequest
            : client.modules!.transferRequest,
      ),
    );
    // switch (module) {
    //   case Modules.adjustSalePrice:
    //      client.modules!.adjustSalePrice= !client.modules!.adjustSalePrice;
    //      break;
    //   case Modules.adjustStock:
    //      client.modules!.adjustStock= !client.modules!.adjustStock;
    //      break;
    //   case Modules.buyRequest:
    //      client.modules!.buyRequest= !client.modules!.buyRequest;
    //      break;
    //   case Modules.customerRegister:
    //      client.modules!.customerRegister= !client.modules!.customerRegister;
    //      break;
    //   case Modules.inventory:
    //      client.modules!.inventory= !client.modules!.inventory;
    //      break;
    //   case Modules.priceConference:
    //      client.modules!.priceConference= !client.modules!.priceConference;
    //      break;
    //   case Modules.productsConference:
    //      client.modules!.productsConference= !client.modules!.productsConference;
    //      break;
    //   case Modules.receipt:
    //      client.modules!.receipt= !client.modules!.receipt;
    //      break;
    //   case Modules.researchPrices:
    //      client.modules!.researchPrices= !client.modules!.researchPrices;
    //      break;
    //   case Modules.saleRequest:
    //      client.modules!.saleRequest= !client.modules!.saleRequest;
    //      break;
    //   case Modules.transferBetweenStocks:
    //      client.modules!.transferBetweenStocks= !client.modules!.transferBetweenStocks;
    //      break;
    //   case Modules.transferRequest:
    //      client.modules!.transferRequest= !client.modules!.transferRequest;
    //      break;
  }
}

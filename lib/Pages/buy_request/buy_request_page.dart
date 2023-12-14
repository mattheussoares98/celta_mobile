import 'package:celta_inventario/Pages/buy_request/buy_request_details_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_enterprises_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_identification_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_insert_products_page.dart';
import 'package:celta_inventario/components/Buy_request/buy_request_app_bar_actions.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/show_snackbar_message.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestPage extends StatefulWidget {
  const BuyRequestPage({Key? key}) : super(key: key);

  @override
  State<BuyRequestPage> createState() => _BuyRequestPageState();
}

final GlobalKey<FormFieldState> _buyersKey = GlobalKey();
final GlobalKey<FormFieldState> _requestsKey = GlobalKey();

class _BuyRequestPageState extends State<BuyRequestPage> {
  List<Widget> _pages = <Widget>[
    BuyRequestIdentificationPage(
      buyersKey: _buyersKey,
      requestsKey: _requestsKey,
    ),
    const BuyRequestEnterprisesPage(),
    const BuyRequestInsertProductsPage(),
    const BuyRequestDetailsPage(),
  ];

  static const List appBarTitles = [
    "Identificação",
    "Empresas",
    "Produtos",
    "Confirmação",
  ];

  int _selectedIndex = 0;

  bool _hasSelectedBuyerAndRequestType() {
    bool buyersIsValid = _buyersKey.currentState?.validate() ?? false;
    bool requestsIsValid = _requestsKey.currentState?.validate() ?? false;

    return buyersIsValid && requestsIsValid;
  }

  void _onItemTapped({
    required int index,
    required BuyRequestProvider buyRequestProvider,
  }) {
    if (buyRequestProvider.isLoadingInsertBuyRequest) return;

    if (_selectedIndex == 0) {
      if (!_hasSelectedBuyerAndRequestType() && (index == 1 || index == 2)) {
        ShowSnackbarMessage.showMessage(
          message: "Selecione um comprador e um modelo de pedido",
          context: context,
        );
        return;
      } else if ((index == 1 || index == 2) &&
          buyRequestProvider.selectedSupplier == null) {
        ShowSnackbarMessage.showMessage(
          message: "Selecione um fornecedor",
          context: context,
        );
        return;
      } else if ((index == 2) && !buyRequestProvider.hasSelectedEnterprise) {
        ShowSnackbarMessage.showMessage(
          message: "Selecione pelo menos uma empresa",
          context: context,
        );
        return;
      }
    } else if (_selectedIndex == 1) {
      if (buyRequestProvider.isLoadingEnterprises) {
        return;
      } else if (!buyRequestProvider.hasSelectedEnterprise && index == 2) {
        ShowSnackbarMessage.showMessage(
          message: "Selecione pelo menos uma empresa",
          context: context,
        );
        return;
      }
    } else if (_selectedIndex == 3) {
      if (index == 1) {
        if (buyRequestProvider.selectedBuyer == null ||
            buyRequestProvider.selectedRequestModel == null ||
            buyRequestProvider.selectedSupplier == null) {
          ShowSnackbarMessage.showMessage(
            message: "Informe os dados de identificação",
            context: context,
          );
          return;
        }
      } else if (index == 2) {
        if (buyRequestProvider.hasSelectedEnterprise == false) {
          ShowSnackbarMessage.showMessage(
            message: "Selecione pelo menos uma empresa",
            context: context,
          );
          return;
        }
      }
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: true);

    return PopScope(
      canPop: !buyRequestProvider.isLoadingBuyer &&
          !buyRequestProvider.isLoadingRequestsType &&
          !buyRequestProvider.isLoadingSupplier &&
          !buyRequestProvider.isLoadingEnterprises &&
          !buyRequestProvider.isLoadingProducts &&
          !buyRequestProvider.isLoadingInsertBuyRequest,
      onPopInvoked: (_) async {
        if (buyRequestProvider.isLoadingBuyer ||
            buyRequestProvider.isLoadingRequestsType ||
            buyRequestProvider.isLoadingSupplier ||
            buyRequestProvider.isLoadingEnterprises ||
            buyRequestProvider.isLoadingProducts ||
            buyRequestProvider.isLoadingInsertBuyRequest) {
          ShowSnackbarMessage.showMessage(
            message: "Aguarde o término do processamento",
            backgroundColor: Theme.of(context).colorScheme.primary,
            context: context,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              if (buyRequestProvider.isLoadingBuyer ||
                  buyRequestProvider.isLoadingRequestsType ||
                  buyRequestProvider.isLoadingSupplier ||
                  buyRequestProvider.isLoadingEnterprises ||
                  buyRequestProvider.isLoadingProducts ||
                  buyRequestProvider.isLoadingInsertBuyRequest) {
                ShowSnackbarMessage.showMessage(
                  message: "Aguarde o término do processamento",
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  context: context,
                );
              } else {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            appBarTitles.elementAt(_selectedIndex),
          ),
          actions: [const BuyRequestCartAppbarAction()],
        ),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.info,
                size: 35,
              ),
              label: 'Identificação',
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.business,
                size: 35,
              ),
              label: 'Empresas',
            ),
            BottomNavigationBarItem(
              label: 'Produtos',
              icon: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 35,
                  ),
                  if (buyRequestProvider.productsInCartCount > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FittedBox(
                            child: Text(
                              buyRequestProvider.productsInCartCount.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        maxRadius: 9,
                      ),
                    ),
                ],
              ),
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.check_box_outlined,
                size: 35,
              ),
              label: 'Confirmação',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: (index) {
            _onItemTapped(
              index: index,
              buyRequestProvider: buyRequestProvider,
            );
          },
        ),
        floatingActionButton: _selectedIndex != 3
            ? null
            : Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: FloatingActionButton(
                  tooltip: "Limpar todos os dados do pedido",
                  onPressed: (buyRequestProvider.observationsController.text ==
                                  "" &&
                              buyRequestProvider.selectedBuyer == null &&
                              buyRequestProvider.selectedRequestModel == null &&
                              buyRequestProvider.selectedSupplier == null) ||
                          buyRequestProvider.isLoadingInsertBuyRequest
                      ? null
                      : () {
                          ShowAlertDialog.showAlertDialog(
                            context: context,
                            title: "Apagar todos dados",
                            subtitle:
                                "Deseja realmente apagar todos dados do pedido de compras?",
                            function: () {
                              buyRequestProvider.clearAllData();
                            },
                          );
                        },
                  child: const Icon(Icons.delete, color: Colors.white),
                  backgroundColor: (buyRequestProvider
                                      .observationsController.text ==
                                  "" &&
                              buyRequestProvider.selectedBuyer == null &&
                              buyRequestProvider.selectedRequestModel == null &&
                              buyRequestProvider.selectedSupplier == null) ||
                          buyRequestProvider.isLoadingInsertBuyRequest
                      ? Colors.grey.withOpacity(0.75)
                      : Colors.red.withOpacity(0.75),
                ),
              ),
      ),
    );
  }
}

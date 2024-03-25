import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buy_request/buy_request.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import 'buy_request.dart';

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
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
      canPop: !buyRequestProvider.isLoadingInsertBuyRequest,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
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
                                  buyRequestProvider.productsInCartCount
                                      .toString(),
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
                      onPressed: (buyRequestProvider
                                          .observationsController.text ==
                                      "" &&
                                  buyRequestProvider.selectedBuyer == null &&
                                  buyRequestProvider.selectedRequestModel ==
                                      null &&
                                  buyRequestProvider.selectedSupplier ==
                                      null) ||
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
                                  buyRequestProvider.selectedRequestModel ==
                                      null &&
                                  buyRequestProvider.selectedSupplier ==
                                      null) ||
                              buyRequestProvider.isLoadingInsertBuyRequest
                          ? Colors.grey.withOpacity(0.75)
                          : Colors.red.withOpacity(0.75),
                    ),
                  ),
          ),
          loadingWidget(
            message: "Consultando compradores...",
            isLoading: buyRequestProvider.isLoadingBuyer,
          ),
          loadingWidget(
            message: "Consultando modelos de pedido...",
            isLoading: buyRequestProvider.isLoadingRequestsType,
          ),
          loadingWidget(
            message: "Consultando fornecedores...",
            isLoading: buyRequestProvider.isLoadingSupplier,
          ),
          loadingWidget(
            message: "Consultando empresas...",
            isLoading: buyRequestProvider.isLoadingEnterprises,
          ),
          loadingWidget(
            message: "Consultando produtos...",
            isLoading: buyRequestProvider.isLoadingProducts,
          ),
          loadingWidget(
            message: "Salvando pedido...",
            isLoading: buyRequestProvider.isLoadingInsertBuyRequest,
          ),
        ],
      ),
    );
  }
}

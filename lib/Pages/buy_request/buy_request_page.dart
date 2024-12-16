import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
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
    IdentificationPage(
      buyersKey: _buyersKey,
      requestsKey: _requestsKey,
    ),
    const EnterprisesPage(),
    const ProductsPage(),
    const DetailsPage(),
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
        ShowSnackbarMessage.show(
          message: "Selecione um comprador e um modelo de pedido",
          context: context,
        );
        return;
      } else if ((index == 1 || index == 2) &&
          buyRequestProvider.selectedSupplier == null) {
        ShowSnackbarMessage.show(
          message: "Selecione um fornecedor",
          context: context,
        );
        return;
      } else if ((index == 2) && !buyRequestProvider.hasSelectedEnterprise) {
        ShowSnackbarMessage.show(
          message: "Selecione pelo menos uma empresa",
          context: context,
        );
        return;
      }
    } else if (_selectedIndex == 1) {
      if (buyRequestProvider.isLoadingEnterprises) {
        return;
      } else if (!buyRequestProvider.hasSelectedEnterprise && index == 2) {
        ShowSnackbarMessage.show(
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
          ShowSnackbarMessage.show(
            message: "Informe os dados de identificação",
            context: context,
          );
          return;
        }
      } else if (index == 2) {
        if (buyRequestProvider.hasSelectedEnterprise == false) {
          ShowSnackbarMessage.show(
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

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: !buyRequestProvider.isLoadingInsertBuyRequest,
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(
                  appBarTitles.elementAt(_selectedIndex),
                ),
                actions: [const AppbarActions()],
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
                                ShowAlertDialog.show(
                                  context: context,
                                  title: "Apagar todos dados",
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      "Deseja realmente apagar todos dados do pedido de compras?",
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
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
                            ? Colors.grey.withAlpha(190)
                            : Colors.red.withAlpha(190),
                      ),
                    ),
            ),
            loadingWidget(buyRequestProvider.isLoadingBuyer),
            loadingWidget(buyRequestProvider.isLoadingRequestsType),
            loadingWidget(buyRequestProvider.isLoadingSupplier),
            loadingWidget(buyRequestProvider.isLoadingEnterprises),
            loadingWidget(buyRequestProvider.isLoadingProducts),
            loadingWidget(buyRequestProvider.isLoadingInsertBuyRequest),
          ],
        ),
      ),
    );
  }
}

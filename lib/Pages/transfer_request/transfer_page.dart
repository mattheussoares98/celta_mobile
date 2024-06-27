import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import 'transfer_request.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  int _selectedIndex = 0;

  static const List appBarTitles = [
    "Inserir produtos",
    "carrinho",
  ];

  void _onItemTapped({
    required int index,
    required TransferRequestProvider transferRequestProvider,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (transferRequestProvider.isLoadingSaveTransferRequest) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    TransferRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: false,
    );

    if (!_isLoaded) {
      _isLoaded = true;
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      await saleRequestProvider.restoreProducts(
        requestTypeCode: arguments["requestTypeCode"].toString(),
        enterpriseOriginCode: arguments["enterpriseOriginCode"].toString(),
        enterpriseDestinyCode: arguments["enterpriseDestinyCode"].toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    int cartProductsCount = transferRequestProvider.cartProductsCount(
      requestTypeCode: arguments["requestTypeCode"].toString(),
      enterpriseOriginCode: arguments["enterpriseOriginCode"].toString(),
      enterpriseDestinyCode: arguments["enterpriseDestinyCode"].toString(),
    );

    List<Widget> _pages = <Widget>[
      InsertProductsPage(
        requestTypeCode: arguments["requestTypeCode"].toString(),
        enterpriseOriginCode: arguments["enterpriseOriginCode"].toString(),
        enterpriseDestinyCode: arguments["enterpriseDestinyCode"].toString(),
      ),
      // SaleRequestInsertCostumer(enterpriseCode: 2),
      CartDetailsPage(
        requestTypeCode: arguments["requestTypeCode"].toString(),
        enterpriseOriginCode: arguments["enterpriseOriginCode"].toString(),
        enterpriseDestinyCode: arguments["enterpriseDestinyCode"].toString(),
        keyboardIsOpen: MediaQuery.of(context).viewInsets.bottom == 0,
      ),
    ];

    return Stack(
      children: [
        PopScope(
          canPop: !transferRequestProvider.isLoadingSaveTransferRequest &&
              !transferRequestProvider.isLoadingProducts,
          onPopInvoked: (value) {
            if (value == true) {
              transferRequestProvider.clearProducts();
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: kIsWeb ? false : true,
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                  appBarTitles[_selectedIndex],
                ),
              ),
              actions: [
                FittedBox(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                              size: 33,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3.0,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            //se não houver um modelo de pedido padrão informado,
                            //desativa o botão pra ir até o carrinho
                            onPressed: () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                              // saleRequestProvider.clearProducts();
                            },
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: FittedBox(
                                  child: Text(
                                    cartProductsCount.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              maxRadius: 11,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Text(
                          ConvertString.convertToBRL(
                            transferRequestProvider.getTotalCartPrice(
                              enterpriseOriginCode:
                                  arguments["enterpriseOriginCode"].toString(),
                              enterpriseDestinyCode:
                                  arguments["enterpriseDestinyCode"].toString(),
                              requestTypeCode:
                                  arguments["requestTypeCode"].toString(),
                            ),
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: Center(
              child: _pages.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_shopping_cart_sharp,
                    size: 35,
                  ),
                  label: 'Inserir produtos',
                ),
                BottomNavigationBarItem(
                  label: 'Carrinho',
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        size: 35,
                      ),
                      if (cartProductsCount > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: FittedBox(
                                child: Text(
                                  cartProductsCount.toString(),
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
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: (index) {
                _onItemTapped(
                  index: index,
                  transferRequestProvider: transferRequestProvider,
                );
              },
            ),
          ),
        ),
        loadingWidget(
          message: "Consultando produtos...",
          isLoading: transferRequestProvider.isLoadingProducts,
        ),
        loadingWidget(
          message: "Salvando pedido...",
          isLoading: transferRequestProvider.isLoadingSaveTransferRequest,
        ),
      ],
    );
  }
}

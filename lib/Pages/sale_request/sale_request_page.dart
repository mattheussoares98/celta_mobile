import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';
import 'sale_request.dart';

class SaleRequestPage extends StatefulWidget {
  const SaleRequestPage({Key? key}) : super(key: key);

  @override
  State<SaleRequestPage> createState() => _SaleRequestPageState();
}

class _SaleRequestPageState extends State<SaleRequestPage> {
  int _selectedIndex = 0;

  static const List appBarTitles = [
    "Inserir produtos",
    "cliente",
    "carrinho",
  ];

  void _onItemTapped({
    required int index,
    required SaleRequestProvider saleRequestProvider,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    if (saleRequestProvider.isLoadingSaveSaleRequest ||
        saleRequestProvider.isLoadingProcessCart) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget? _floatingActionButton(SaleRequestProvider saleRequestProvider) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    if (_selectedIndex == 1) {
      return FloatingActionButton(
        tooltip: "Cadastrar cliente",
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.person_add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed(
            APPROUTES.CUSTOMER_REGISTER,
          );
        },
      );
    } else if (_selectedIndex == 2) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          tooltip: "Limpar todos os dados do pedido",
          onPressed: (saleRequestProvider
                          .cartProductsCount(arguments["Code"].toString()) ==
                      0) ||
                  saleRequestProvider.isLoadingSaveSaleRequest ||
                  saleRequestProvider.isLoadingProcessCart
              ? null
              : () {
                  ShowAlertDialog.showAlertDialog(
                    context: context,
                    title: "Apagar TODOS dados",
                    subtitle:
                        "Deseja realmente limpar todos os dados do pedido?",
                    function: () {
                      saleRequestProvider
                          .clearCart(arguments["Code"].toString());
                    },
                  );
                },
          child: const Icon(Icons.delete, color: Colors.white),
          backgroundColor: (saleRequestProvider
                          .cartProductsCount(arguments["Code"].toString()) ==
                      0) ||
                  saleRequestProvider.isLoadingSaveSaleRequest ||
                  saleRequestProvider.isLoadingProcessCart
              ? Colors.grey.withOpacity(0.75)
              : Colors.red.withOpacity(0.75),
        ),
      );
    }
    return null;
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: false,
    );

    if (!_isLoaded) {
      _isLoaded = true;
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      await saleRequestProvider.restoreProducts(arguments["Code"].toString());
      await saleRequestProvider.restorecustomers(arguments["Code"].toString());

      int customersCount =
          saleRequestProvider.customersCount(arguments["Code"].toString());
      if (customersCount == 0) {
        //logo que entra na tela de pedido de vendas, o app recupera os clientes
        //que foram pesquisados e marcados. Caso consulte os clientes, vai
        //apagar esses dados, por isso só pode pesquisar automaticamente quando
        //entrar na página de pedido de vendas se não houver clientes
        await saleRequestProvider.getCustomers(
          context: context,
          controllerText: "-1",
          enterpriseCode: arguments["Code"].toString(),
          searchOnlyDefaultCustomer: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(arguments["Code"].toString());

    List<Widget> _pages = <Widget>[
      SaleRequestInsertProductsPage(
        enterpriseCode: arguments["Code"],
        requestTypeCode: arguments["SaleRequestTypeCode"],
      ),
      SaleRequestInsertCustomer(enterpriseCode: arguments["Code"]),
      SaleRequestCartDetailsPage(
        enterpriseCode: arguments["Code"],
        requestTypeCode: arguments["SaleRequestTypeCode"],
        keyboardIsOpen: MediaQuery.of(context).viewInsets.bottom == 0,
      ),
    ];

    return Stack(
      children: [
        PopScope(
          canPop: !saleRequestProvider.isLoadingSaveSaleRequest &&
              !saleRequestProvider.isLoadingProcessCart &&
              !saleRequestProvider.isLoadingProducts,
          onPopInvoked: (value) {
            if (value == true) {
              saleRequestProvider.clearProducts();
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
                                _selectedIndex = 2;
                              });
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
                            saleRequestProvider
                                .getTotalCartPrice(arguments["Code"].toString())
                                .toString(),
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
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_add,
                    size: 35,
                  ),
                  label: 'Cliente',
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
                  saleRequestProvider: saleRequestProvider,
                );
              },
            ),
            floatingActionButton: _floatingActionButton(saleRequestProvider),
          ),
        ),
        loadingWidget(
          message: "Calculando preços...",
          isLoading: saleRequestProvider.isLoadingProcessCart,
        ),
        loadingWidget(
          message: "Salvando pedido...",
          isLoading: saleRequestProvider.isLoadingSaveSaleRequest,
        ),
        loadingWidget(
          message: "Consultando clientes...",
          isLoading: saleRequestProvider.isLoadingCustomer,
        ),
        loadingWidget(
          message: "Consultando produtos...",
          isLoading: saleRequestProvider.isLoadingProducts,
        ),
      ],
    );
  }
}

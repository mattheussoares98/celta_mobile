import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../components/components.dart';
import '../../models/models.dart';
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
  final observationsController = TextEditingController();
  final instructionsController = TextEditingController();
  bool userCanChangePrices = false;

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

  Widget _clearAllDataIcon(SaleRequestProvider saleRequestProvider) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: IconButton(
        onPressed: () {
          ShowAlertDialog.show(
            context: context,
            title: "Apagar TODOS dados",
            content: const SingleChildScrollView(
              child: Text(
                "Deseja realmente limpar todos os dados do pedido?",
                textAlign: TextAlign.center,
              ),
            ),
            function: () {
              saleRequestProvider.clearCart(enterprise.Code.toString());
            },
          );
        },
        icon: FittedBox(
          child: Row(
            children: [
              Icon(
                Icons.delete,
                color: Colors.red[600],
                size: 30,
                shadows: [
                  const Shadow(
                    color: Colors.white70,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              Text(
                "LIMPAR\nPEDIDO",
                style: TextStyle(
                  color: Colors.red[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  shadows: [
                    const Shadow(
                      color: Colors.white38,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    super.dispose();
    observationsController.dispose();
    instructionsController.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await cleanSaleRequestBecauseVersionIncompatible();
        userCanChangePrices = await SoapHelper.userCanAccessResource(
          resourceCode: 666,
          routineInt: 0,
        );
        setState(() {});
      }
    });
  }

  Future<void> cleanSaleRequestBecauseVersionIncompatible() async {
    //usado somente a partir da versão 2.5.7 porque mudou a forma como grava os produtos

    bool isClean =
        await PrefsInstance.getBool(prefsKeys: PrefsKeys.cleanSaleRequest);

    if (!isClean) {
      await PrefsInstance.removeKey(PrefsKeys.cart);
      await PrefsInstance.setBool(
          prefsKeys: PrefsKeys.cleanSaleRequest, value: true);
    }
    await restoreSaleRequest();
  }

  Future<void> restoreSaleRequest() async {
    SaleRequestProvider saleRequestProvider = Provider.of(
      context,
      listen: false,
    );

    ConfigurationsProvider configurationsProvider = Provider.of(
      context,
      listen: false,
    );

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];

    await saleRequestProvider.restoreProducts(enterprise.Code.toString());
    await saleRequestProvider.restorecustomers(enterprise.Code.toString());

    int customersCount =
        saleRequestProvider.customersCount(enterprise.Code.toString());
    if (customersCount == 0) {
      //logo que entra na tela de pedido de vendas, o app recupera os clientes
      //que foram pesquisados e marcados. Caso consulte os clientes, vai
      //apagar esses dados, por isso só pode pesquisar automaticamente quando
      //entrar na página de pedido de vendas se não houver clientes
      await saleRequestProvider.getCustomers(
        context: context,
        controllerText: "-1",
        enterpriseCode: enterprise.Code.toString(),
        searchOnlyDefaultCustomer: true,
        configurationsProvider: configurationsProvider,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(enterprise.Code.toString());
    double totalCartPrice =
        saleRequestProvider.getTotalCartPrice(enterprise.Code.toString());

    List<Widget> _pages = <Widget>[
      InsertProductsPage(
        enterprise: enterprise,
        requestTypeCode: arguments["SaleRequestTypeCode"],
      ),
      InsertCustomerPage(enterpriseCode: enterprise.Code),
      CartDetailsPage(
        enterpriseCode: enterprise.Code,
        requestTypeCode: arguments["SaleRequestTypeCode"],
        keyboardIsOpen: MediaQuery.of(context).viewInsets.bottom == 0,
        observationsController: observationsController,
        instructionsController: instructionsController,
        userCanChangePrices: userCanChangePrices,
      ),
    ];
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Stack(
        children: [
          PopScope(
            onPopInvokedWithResult: (value, __) {
              saleRequestProvider.clearProducts();
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
                  if (_selectedIndex == _pages.length - 1)
                    _clearAllDataIcon(saleRequestProvider),
                  if (_selectedIndex < (_pages.length - 1))
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
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                totalCartPrice.toString(),
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
            ),
          ),
          loadingWidget(saleRequestProvider.isLoadingProcessCart),
          loadingWidget(saleRequestProvider.isLoadingSaveSaleRequest),
          loadingWidget(saleRequestProvider.isLoadingCustomer),
          loadingWidget(saleRequestProvider.isLoadingProducts),
        ],
      ),
    );
  }
}

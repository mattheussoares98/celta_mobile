import 'package:celta_inventario/Pages/sale_request/sale_request_insert_customer.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_insert_products_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_cart_details_page.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/convert_string.dart';

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
    if (saleRequestProvider.isLoadingSaveSaleRequest ||
        saleRequestProvider.isLoadingProcessCart) return;

    setState(() {
      _selectedIndex = index;
    });
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
      ),
      SaleRequestInsertCustomer(enterpriseCode: arguments["Code"]),
      SaleRequestCartDetailsPage(
        enterpriseCode: arguments["Code"],
        requestTypeCode: arguments["SaleRequestTypeCode"],
        keyboardIsOpen: MediaQuery.of(context).viewInsets.bottom == 0,
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (saleRequestProvider.isLoadingSaveSaleRequest ||
            saleRequestProvider.isLoadingProcessCart) return false;
        saleRequestProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: kIsWeb ? false : true,
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              appBarTitles[_selectedIndex],
            ),
          ),
          leading: IconButton(
            onPressed: saleRequestProvider.isLoadingSaveSaleRequest ||
                    saleRequestProvider.isLoadingProcessCart
                ? null
                : () {
                    saleRequestProvider.clearProducts();
                    Navigator.of(context).pop();
                  },
            icon: const Icon(
              Icons.arrow_back_outlined,
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
      ),
    );
  }
}

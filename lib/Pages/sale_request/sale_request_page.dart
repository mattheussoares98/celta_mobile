import 'package:celta_inventario/Pages/sale_request/sale_request_insert_costumer.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_insert_products_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_cart_details_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_manual_default_request_model_page.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
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
  bool _hasDefaultRequestModel = false;

  static const List appBarTitles = [
    "Inserir produtos",
    "cliente",
    "carrinho",
  ];

  void _onItemTapped({
    required int index,
    required SaleRequestProvider saleRequestProvider,
  }) {
    if (saleRequestProvider.isLoadingSaveSaleRequest) return;
    if (!_hasDefaultRequestModel) {
      return;
      //se não houver modelo de pedido padrão selecionado no BS, não permite alterar o bottomNavigationItem
    }
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
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      if (arguments["SaleRequestTypeCode"] == 0) {
        //significa que não possui um modelo de pedido de vendas padrão cadastrado no BS
        _hasDefaultRequestModel = false;
      } else {
        _hasDefaultRequestModel = true;
      }

      await saleRequestProvider.restoreProducts(arguments["Code"].toString());

      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    saleRequestProvider.insertDefaultCostumer(arguments["Code"]);

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(arguments["Code"]);

    List<Widget> _pages = <Widget>[
      _hasDefaultRequestModel
          ? SaleRequestInsertProductsPage(
              enterpriseCode: arguments["Code"],
            )
          : const SaleRequestManualDefaultRequestModelPage(),
      SaleRequestInsertCostumer(enterpriseCode: arguments["Code"]),
      SaleRequestCartDetailsPage(
        enterpriseCode: arguments["Code"],
        requestTypeCode: arguments["SaleRequestTypeCode"],
      ),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (saleRequestProvider.isLoadingSaveSaleRequest) return false;
        saleRequestProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              appBarTitles[_selectedIndex],
            ),
          ),
          leading: IconButton(
            onPressed: saleRequestProvider.isLoadingSaveSaleRequest
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
                        onPressed: _hasDefaultRequestModel
                            ? () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                                saleRequestProvider.clearProducts();
                              }
                            : null,
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

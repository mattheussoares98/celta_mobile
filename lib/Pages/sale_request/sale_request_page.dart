import 'package:celta_inventario/Components/Sale_request/sale_request_products_items.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_insert_costumer.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_insert_products_page.dart';
import 'package:celta_inventario/Pages/sale_request/sale_request_cart_details_page.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/convert_string.dart';

class SaleRequestPage extends StatefulWidget {
  const SaleRequestPage({Key? key}) : super(key: key);

  @override
  State<SaleRequestPage> createState() => _SaleRequestPageState();
}

class _SaleRequestPageState extends State<SaleRequestPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    SaleRequestInsertProductsPage(),
    SaleRequestInsertCostumer(),
    SaleRequestCartDetailsPage(),
  ];

  static const List appBarTitles = [
    "Inserir produtos",
    "Inserir cliente",
    "Produtos do carrinho",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

      if (arguments["SaleRequestTypeCode"] == 0) {
        print("precisa configurar");
      }

      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
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
            onPressed: () {
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
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 2;
                          });
                          saleRequestProvider.clearProducts();
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
                                saleRequestProvider.cartProducts.length
                                    .toString(),
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
                        saleRequestProvider.totalCartPrice,
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
                  if (saleRequestProvider.cartProducts.length > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FittedBox(
                            child: Text(
                              saleRequestProvider.cartProducts.length
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
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

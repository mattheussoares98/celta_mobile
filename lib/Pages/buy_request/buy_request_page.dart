import 'package:celta_inventario/Pages/buy_request/buy_request_details_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_enterprises_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_identification_page.dart';
import 'package:celta_inventario/Pages/buy_request/buy_request_insert_products_page.dart';
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
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);
    if (buyRequestProvider.buyersCount == 0) {
      buyRequestProvider.getBuyers(context: context);
    }
    if (buyRequestProvider.requestsTypeCount == 0) {
      buyRequestProvider.getRequestsType(context: context);
    }
  }

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

  bool _selectedBuyerAndRequestType() {
    bool buyersIsValid = _buyersKey.currentState?.validate() ?? false;
    bool requestsIsValid = _requestsKey.currentState?.validate() ?? false;

    return buyersIsValid && requestsIsValid;
  }

  void _onItemTapped({
    required int index,
    required BuyRequestProvider buyRequestProvider,
  }) {
    if (buyRequestProvider.isLoadingBuyer ||
        buyRequestProvider.isLoadingProducts ||
        buyRequestProvider.isLoadingRequestsType ||
        buyRequestProvider.isLoadingSupplier) return;

    if (_selectedIndex == 0) {
      if (!_selectedBuyerAndRequestType()) {
        ShowSnackbarMessage.showMessage(
          message: "Selecione um comprador e um modelo de pedido",
          context: context,
        );
        return;
      } else if (buyRequestProvider.selectedSupplier == null) {
        ShowSnackbarMessage.showMessage(
          message: "Selecione um fornecedor",
          context: context,
        );
        return;
      }
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: true);
    // Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appBarTitles.elementAt(_selectedIndex),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              await buyRequestProvider.getBuyers(
                isSearchingAgain: true,
                context: context,
              );
            },
            child: _pages.elementAt(_selectedIndex)

            // Column(
            //   children: [
            //     if (buyRequestProvider.isLoadingBuyer)
            //       Expanded(
            //         child: ConsultingWidget.consultingWidget(
            //             title: 'Consultando compradores'),
            //       ),
            //     if (buyRequestProvider.errorMessageBuyer != '' &&
            //         buyRequestProvider.buyersCount == 0 &&
            //         !buyRequestProvider.isLoadingBuyer)
            //       Expanded(
            //         child: TryAgainWidget.tryAgain(
            //             errorMessage: buyRequestProvider.errorMessageBuyer,
            //             request: () async {
            //               setState(() {});
            //               await buyRequestProvider.getBuyers(
            //                 // enterpriseCode: arguments["CodigoInterno_Empresa"],
            //                 // context: context,
            //                 isSearchingAgain: true,
            //               );
            //             }),
            //       ),
            //     // if (!buyRequestProvider.isLoadingBuyer &&
            //     //     buyRequestProvider.errorMessageBuyer == '')
            //     //   Expanded(
            //     //     child: ReceiptItems(
            //     //       enterpriseCode: arguments["CodigoInterno_Empresa"],
            //     //       // BuyRequestProvider: BuyRequestProvider,
            //     //     ),
            //     //   ),
            //   ],
            // ),
            ),
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
                Icons.r_mobiledata,
                size: 35,
              ),
              label: 'Empresas',
            ),
            const BottomNavigationBarItem(
              label: 'Produtos',
              icon: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    size: 35,
                  ),
                  // if (cartProductsCount > 0)
                  //   Positioned(
                  //     top: 0,
                  //     right: 0,
                  //     child: CircleAvatar(
                  //       backgroundColor: Colors.red,
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(2.0),
                  //         child: FittedBox(
                  //           child: Text(
                  //             cartProductsCount.toString(),
                  //             style: const TextStyle(
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       maxRadius: 9,
                  //     ),
                  //   ),
                ],
              ),
            ),
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.details,
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
      ),
    );
  }
}

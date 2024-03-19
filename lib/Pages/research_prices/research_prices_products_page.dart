import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../pages/research_prices/research_prices.dart';
import '../../providers/providers.dart';

class ResearchPricesProductsPage extends StatefulWidget {
  const ResearchPricesProductsPage({Key? key}) : super(key: key);

  @override
  State<ResearchPricesProductsPage> createState() =>
      _ResearchPricesProductsPageState();
}

class _ResearchPricesProductsPageState
    extends State<ResearchPricesProductsPage> {
  // TextEditingController _searchProductTextEditingController =
  //     TextEditingController();
  // TextEditingController _consultedProductController = TextEditingController();

  int _selectedIndex = 0;

  void _onItemTapped({
    required int index,
    // required SaleRequestProvider saleRequestProvider,
  }) {
    // if (saleRequestProvider.isLoadingSaveSaleRequest ||
    //     saleRequestProvider.isLoadingProcessCart) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchAssociatedsProductsController.dispose();
    _searchNotAssociatedsProductsController.dispose();
  }

  TextEditingController _searchAssociatedsProductsController =
      TextEditingController();
  TextEditingController _searchNotAssociatedsProductsController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    List<Widget> _pages = <Widget>[
      ResearchPricesInsertPricesPage(
        isAssociatedProducts: true,
        searchProductController: _searchAssociatedsProductsController,
      ),
      ResearchPricesInsertPricesPage(
        isAssociatedProducts: false,
        searchProductController: _searchNotAssociatedsProductsController,
      ),
    ];

    return Stack(
      children: [
        PopScope(
          onPopInvoked: (_) async {
            researchPricesProvider.clearAssociatedsProducts();
            researchPricesProvider.clearNotAssociatedsProducts();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: kIsWeb ? false : true,
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                    "Pesquisa ${researchPricesProvider.selectedResearch!.Code}"
                    " - Concorrente ${researchPricesProvider.selectedConcurrent!.ConcurrentCode}"),
              ),
              leading: IconButton(
                onPressed: researchPricesProvider.isLoadingGetProducts
                    ? null
                    : () {
                        researchPricesProvider.clearAssociatedsProducts();
                        researchPricesProvider.clearNotAssociatedsProducts();
                        Navigator.of(context).pop();
                      },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                ),
              ),
              actions: [],
            ),
            body: Center(
              child: _pages.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.manage_search,
                    size: 35,
                  ),
                  label: 'Associados',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 35,
                  ),
                  label: 'Não associados',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: researchPricesProvider.isLoadingGetProducts
                  ? null
                  : (index) {
                      _onItemTapped(
                        index: index,
                      );
                    },
            ),
          ),
        ),
        loadingWidget(
          message: "Consultando produto(s)...",
          isLoading: researchPricesProvider.isLoadingGetProducts,
        ),
        loadingWidget(
          message: "Confirmando preço(s)...",
          isLoading: researchPricesProvider.isLoadingInsertConcurrentPrices,
        ),
      ],
    );
  }
}

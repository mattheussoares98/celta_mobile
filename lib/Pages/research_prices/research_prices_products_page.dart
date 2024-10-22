import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'research_prices.dart';
import '../../providers/providers.dart';

class ResearchPricesProductsPage extends StatefulWidget {
  const ResearchPricesProductsPage({Key? key}) : super(key: key);

  @override
  State<ResearchPricesProductsPage> createState() =>
      _ResearchPricesProductsPageState();
}

class _ResearchPricesProductsPageState
    extends State<ResearchPricesProductsPage> {
  int _selectedIndex = 0;

  void _onItemTapped({
    required int index,
  }) {
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
        keyboardIsClosed: MediaQuery.of(context).viewInsets.bottom == 0,
      ),
      ResearchPricesInsertPricesPage(
        isAssociatedProducts: false,
        searchProductController: _searchNotAssociatedsProductsController,
        keyboardIsClosed: MediaQuery.of(context).viewInsets.bottom == 0,
      ),
    ];

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Stack(
        children: [
          PopScope(
            canPop: !researchPricesProvider.isLoadingGetProducts &&
                !researchPricesProvider.isLoadingInsertConcurrentPrices,
            onPopInvokedWithResult: (value, __) {
              if (value == true) {
                researchPricesProvider.clearAssociatedsProducts();
                researchPricesProvider.clearNotAssociatedsProducts();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: kIsWeb ? false : true,
              appBar: AppBar(
                title: FittedBox(
                  child: Text(
                      "Pesquisa ${researchPricesProvider.selectedResearch!.Code}"
                      " - Concorrente ${researchPricesProvider.selectedConcurrent!.ConcurrentCode}"),
                ),
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
                    label: 'Associados à pesquisa',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      size: 35,
                    ),
                    label: 'Não associados à pesquisa',
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
          loadingWidget(researchPricesProvider.isLoadingGetProducts),
          loadingWidget(researchPricesProvider.isLoadingInsertConcurrentPrices),
        ],
      ),
    );
  }
}

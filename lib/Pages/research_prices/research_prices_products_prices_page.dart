import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/research_prices/research_prices.dart';
import '../../providers/providers.dart';

class ResearchPricesProductsPricesPage extends StatefulWidget {
  const ResearchPricesProductsPricesPage({Key? key}) : super(key: key);

  @override
  State<ResearchPricesProductsPricesPage> createState() =>
      _ResearchPricesProductsPricesPageState();
}

class _ResearchPricesProductsPricesPageState
    extends State<ResearchPricesProductsPricesPage> {
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

  List<Widget> _pages = <Widget>[
    const ResearchPricesInsertProductsPrices(isAssociatedProducts: true),
    const ResearchPricesInsertProductsPrices(isAssociatedProducts: false),
  ];

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return PopScope(
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
    );
  }
}

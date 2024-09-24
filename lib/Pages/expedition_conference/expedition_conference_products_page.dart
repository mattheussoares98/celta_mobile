import 'package:celta_inventario/pages/expedition_conference/expedition_conference_pending_products_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/expedition_control/expedition_control.dart';
import '../../providers/providers.dart';

class ExpeditionConferenceProductsPage extends StatefulWidget {
  const ExpeditionConferenceProductsPage({Key? key}) : super(key: key);

  @override
  State<ExpeditionConferenceProductsPage> createState() =>
      _ExpeditionConferenceProductsPageState();
}

class _ExpeditionConferenceProductsPageState
    extends State<ExpeditionConferenceProductsPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ExpeditionConferenceProvider expeditionConferenceProvider =
            Provider.of(context, listen: false);
        ExpeditionControlModel expeditionControl = ModalRoute.of(context)!
            .settings
            .arguments as ExpeditionControlModel;

        await expeditionConferenceProvider.getProducts(
          expeditionControlCode: expeditionControl.ExpeditionControlCode!,
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      const ExpeditionConferencePendingProductsPage(),
    ];

    List<String> appBarTitles = [
      "Produtos pendentes",
      "Produtos conferidos",
    ];

    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              appBarTitles[_selectedIndex],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.error),
                label: 'Pendentes',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.verified_rounded),
                label: 'Conferidos',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
          body: _pages.elementAt(_selectedIndex),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: expeditionConferenceProvider.isLoading,
        ),
      ],
    );
  }
}

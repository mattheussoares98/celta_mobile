import 'package:celta_inventario/pages/web/clients/clients_page.dart';
import 'package:celta_inventario/pages/web/soap_actions/soap_actions_page.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/providers/providers.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List _pages = [
    const ClientsPage(),
    const SoapActionsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: (index) {
              _onItemTapped(index);
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: "Clientes",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.show_chart),
                label: "Requisições"
              ),
            ],
          ),
          body: _pages.elementAt(_selectedIndex),
        ),
        loadingWidget(
          message: "Consultando clientes...",
          isLoading: webProvider.isLoading,
        ),
      ],
    );
  }
}

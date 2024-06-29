import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../pages/web/clients/clients_page.dart';
import '../../pages/web/soap_actions/soap_actions_page.dart';
import '../../providers/providers.dart';

class WebHomePage extends StatefulWidget {
  const WebHomePage({super.key});

  @override
  State<WebHomePage> createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
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
          body: _pages.elementAt(webProvider.selectedBottomNavigationBarIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: webProvider.selectedBottomNavigationBarIndex,
            onTap: (index) {
              setState(() {
                webProvider.selectedBottomNavigationBarIndex = index;
              });
            },
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: "Clientes",
              ),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart), label: "Requisições"),
            ],
          ),
        ),
        loadingWidget(
          message: 'Aguarde...',
          isLoading: webProvider.isLoading,
        ),
      ],
    );
  }
}

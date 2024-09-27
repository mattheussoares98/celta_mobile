import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/expedition_control/expedition_control.dart';
import '../../pages/expedition_conference/expedition_conference.dart';
import '../../providers/providers.dart';

class ExpeditionConferenceProductsPage extends StatefulWidget {
  const ExpeditionConferenceProductsPage({Key? key}) : super(key: key);

  @override
  State<ExpeditionConferenceProductsPage> createState() =>
      _ExpeditionConferenceProductsPageState();
}

class _ExpeditionConferenceProductsPageState
    extends State<ExpeditionConferenceProductsPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        ExpeditionConferenceProvider expeditionConferenceProvider =
            Provider.of(context, listen: false);
        final arguments = ModalRoute.of(context)!.settings.arguments as Map;
        ExpeditionControlModel expeditionControl =
            arguments["expeditionControl"];

        await expeditionConferenceProvider.getPendingProducts(
          expeditionControlCode: expeditionControl.ExpeditionControlCode!,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      const ExpeditionConferencePendingProductsPage(),
      const ExpeditionConferenceCheckedProductsPage(),
    ];
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    ExpeditionControlModel expeditionControl = arguments["expeditionControl"];

    List<String> appBarTitles = [
      "Pendentes (${expeditionControl.DocumentNumber})",
      "Conferidos (${expeditionControl.DocumentNumber})",
    ];

    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: FittedBox(
                child: Text(
                  appBarTitles[_selectedIndex],
                ),
              ),
            ),
            body: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: BottomNavigationIcon(
                    icon: Icons.error,
                    quantity: expeditionConferenceProvider.pendingProducts.length,
                  ),
                  label: 'Produtos pendentes',
                ),
                BottomNavigationBarItem(
                  icon: BottomNavigationIcon(
                    icon: Icons.verified_rounded,
                    quantity: expeditionConferenceProvider.checkedProducts.length,
                  ),
                  label: 'Produtos conferidos',
                ),
              ],
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey,
              onTap: _onPageChanged,
            ),
          ),
          loadingWidget(
            message: "Aguarde...",
            isLoading: expeditionConferenceProvider.isLoading,
          ),
        ],
      ),
    );
  }
}

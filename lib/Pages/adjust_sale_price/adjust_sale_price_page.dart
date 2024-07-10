import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import 'adjust_sale_price.dart';

class AdjustSalePricePage extends StatefulWidget {
  const AdjustSalePricePage({super.key});

  @override
  State<AdjustSalePricePage> createState() => _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends State<AdjustSalePricePage> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  final PageController _pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: _onItemTapped,
            children: [
              const RetailPricePage(),
              Scaffold(
                appBar: AppBar(title: const Text("Atacado")),
              ),
              Scaffold(
                appBar: AppBar(title: const Text("Ecommerce")),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedLabelStyle: const TextStyle(color: Colors.black),
            unselectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Varejo',
                icon: _selectedIndex == 0
                    ? Image.asset(
                        "lib/assets/Images/retail_price_selected.png",
                        height: 35,
                        width: 35,
                      )
                    : Image.asset(
                        "lib/assets/Images/retail_price_not_selected.png",
                        height: 35,
                        width: 35,
                      ),
              ),
              BottomNavigationBarItem(
                label: 'Atacado',
                icon: _selectedIndex == 1
                    ? Image.asset(
                        "lib/assets/Images/whole_price_selected.png",
                        height: 35,
                        width: 35,
                      )
                    : Image.asset(
                        "lib/assets/Images/whole_price_not_selected.png",
                        height: 35,
                        width: 35,
                      ),
              ),
              BottomNavigationBarItem(
                label: 'Ecommerce',
                icon: _selectedIndex == 2
                    ? Image.asset(
                        "lib/assets/Images/ecommerce_selected.png",
                        height: 35,
                        width: 35,
                      )
                    : Image.asset(
                        "lib/assets/Images/ecommerce_not_selected.png",
                        height: 35,
                        width: 35,
                      ),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            onTap: _onItemTapped,
          ),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: adjustSalePriceProvider.isLoading,
        )
      ],
    );
  }
}

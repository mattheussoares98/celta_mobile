import 'package:flutter/material.dart';

class AdjustSalePricePage extends StatefulWidget {
  const AdjustSalePricePage({super.key});

  @override
  State<AdjustSalePricePage> createState() => _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends State<AdjustSalePricePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
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
          const BottomNavigationBarItem(
            label: 'Atacado',
            icon: Icon(
              Icons.business,
              size: 35,
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Ecommerce',
            icon: Stack(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  size: 35,
                ),
              ],
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

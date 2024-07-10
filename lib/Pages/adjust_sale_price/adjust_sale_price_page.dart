import 'package:flutter/material.dart';

class AdjustSalePricePage extends StatefulWidget {
  const AdjustSalePricePage({super.key});

  @override
  State<AdjustSalePricePage> createState() => _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends State<AdjustSalePricePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[];

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
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Varejo',
            icon: Image.asset("lib/assets/Images/retail_price.png"),
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

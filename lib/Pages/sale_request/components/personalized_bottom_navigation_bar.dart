import 'package:flutter/material.dart';

class PersonalizedBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final int cartProductsCount;
  final void Function(int index) onItemTapped;
  const PersonalizedBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.cartProductsCount,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.add_shopping_cart_sharp,
            size: 35,
          ),
          label: 'Inserir produtos',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            Icons.person_add,
            size: 35,
          ),
          label: 'Cliente',
        ),
        BottomNavigationBarItem(
          label: 'Carrinho',
          icon: Stack(
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 35,
              ),
              if (cartProductsCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        child: Text(
                          cartProductsCount.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    maxRadius: 9,
                  ),
                ),
            ],
          ),
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: (index) {
        onItemTapped(index);
      },
    );
  }
}

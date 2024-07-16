import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';
import 'components.dart';

class ProductsItems extends StatefulWidget {
  const ProductsItems({super.key});

  @override
  State<ProductsItems> createState() => _ProductsItemsState();
}

class _ProductsItemsState extends State<ProductsItems> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Expanded(
      child: ListView.builder(
        itemCount: adjustSalePriceProvider.products.length,
        itemBuilder: (context, index) {
          final product = adjustSalePriceProvider.products[index];

          return ProductItem(
            updateSelectedIndex: () {
              if (selectedIndex == index) {
                selectedIndex = null;
              } else {
                selectedIndex = index;
              }
              setState(() {});
            },
            product: product,
            index: index,
            selectedIndex: selectedIndex,
          );
        },
      ),
    );
  }
}

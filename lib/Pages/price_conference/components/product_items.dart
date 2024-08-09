import 'package:flutter/material.dart';

import '../../../providers/providers.dart';
import 'components.dart';

class ProductItems extends StatefulWidget {
  final PriceConferenceProvider priceConferenceProvider;
  final int internalEnterpriseCode;
  const ProductItems({
    required this.internalEnterpriseCode,
    required this.priceConferenceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductItems> createState() => _ProductItemsState();
}

class _ProductItemsState extends State<ProductItems> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: widget.priceConferenceProvider.productsCount,
          itemBuilder: (context, index) {
            return ProductItem(
              product: widget.priceConferenceProvider.products[index],
              internalEnterpriseCode: widget.internalEnterpriseCode,
              index: index,
            );
          },
        ),
      ),
    );
  }
}

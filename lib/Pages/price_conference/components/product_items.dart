import 'package:flutter/material.dart';

import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
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
    int itensPerLine = ResponsiveItems.getItensPerLine(context);
    int productsCount = widget.priceConferenceProvider.productsCount;

    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: ResponsiveItems.itemCount(
            itemsCount: productsCount,
            context: context,
          ),
          itemBuilder: (context, index) {
            final startIndex = index * itensPerLine;
            final endIndex = (startIndex + itensPerLine <= productsCount)
                ? startIndex + itensPerLine
                : productsCount;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = startIndex; i < endIndex; i++)
                  Expanded(
                    child: ProductItem(
                      product: widget.priceConferenceProvider.products[i],
                      internalEnterpriseCode: widget.internalEnterpriseCode,
                      index: index,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

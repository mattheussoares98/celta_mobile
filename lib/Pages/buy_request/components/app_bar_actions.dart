import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class AppbarActions extends StatefulWidget {
  const AppbarActions({Key? key}) : super(key: key);

  @override
  State<AppbarActions> createState() =>
      _AppbarActionsState();
}

class _AppbarActionsState
    extends State<AppbarActions> {
  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: true);

    return FittedBox(
      child: Column(
        children: [
          Stack(
            children: [
              const IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 33,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
                onPressed: null,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: FittedBox(
                      child: Text(
                        buyRequestProvider.productsInCartCount.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  maxRadius: 11,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              ConvertString.convertToBRL(
                buyRequestProvider.totalCartPrice.toString(),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

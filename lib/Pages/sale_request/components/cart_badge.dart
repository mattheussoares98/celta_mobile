import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class CartBadge extends StatelessWidget {
  final Function(int index) changeSelectedIndex;
  const CartBadge({
    super.key,
    required this.changeSelectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];

    int cartProductsCount =
        saleRequestProvider.cartProductsCount(enterprise.Code.toString());
    double totalCartPrice =
        saleRequestProvider.getTotalCartPrice(enterprise.Code.toString());

    return FittedBox(
      child: Column(
        children: [
          Stack(
            children: [
              IconButton(
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
                onPressed: () {
                  changeSelectedIndex(2);
                },
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
                        cartProductsCount.toString(),
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
                totalCartPrice.toString(),
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

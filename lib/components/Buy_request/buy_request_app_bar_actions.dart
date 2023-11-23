import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestCartAppbarAction extends StatefulWidget {
  const BuyRequestCartAppbarAction({Key? key}) : super(key: key);

  @override
  State<BuyRequestCartAppbarAction> createState() =>
      _BuyRequestCartAppbarActionState();
}

class _BuyRequestCartAppbarActionState
    extends State<BuyRequestCartAppbarAction> {
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
                        buyRequestProvider.cartProductsCount.toString(),
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

import 'package:celta_inventario/components/costs_stocks_last_buy/costs_stocks_last_buy.dart';
import 'package:celta_inventario/models/soap/products/products.dart';
import 'package:flutter/material.dart';

class CostsStocksLastBuyWidget extends StatelessWidget {
  final GetProductJsonModel product;
  const CostsStocksLastBuyWidget({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(3),
        child: const FittedBox(
          child: Row(
            children: [
              Icon(
                Icons.info,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                "Custos, estoques \ne última compra",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(20),
                insetPadding:
                    const EdgeInsets.symmetric(vertical: 70, horizontal: 20),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Costs(product: product),
                        Stocks(product: product),
                        LastBuyEntrance(product: product),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}

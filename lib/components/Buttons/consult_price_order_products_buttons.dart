import 'package:celta_inventario/providers/consult_price_provider.dart';
import 'package:flutter/material.dart';

class ConsultFilterProducts extends StatefulWidget {
  final ConsultPriceProvider consultPriceProvider;
  const ConsultFilterProducts({
    required this.consultPriceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultFilterProducts> createState() => _ConsultFilterProductsState();
}

class _ConsultFilterProductsState extends State<ConsultFilterProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: widget.consultPriceProvider.isLoading ||
                          widget.consultPriceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.consultPriceProvider.orderByDownPrice();
                        },
                  icon: const Icon(
                    Icons.arrow_upward,
                  ),
                ),
                const Text("Preço"),
                IconButton(
                  color: Colors.white,
                  onPressed: widget.consultPriceProvider.isLoading ||
                          widget.consultPriceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.consultPriceProvider.orderByUpPrice();
                        },
                  icon: const Icon(
                    Icons.arrow_downward,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: widget.consultPriceProvider.isLoading ||
                          widget.consultPriceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.consultPriceProvider.orderByDownName();
                        },
                  icon: const Icon(
                    Icons.arrow_upward,
                  ),
                ),
                const Text(
                  "Nome",
                  // style: TextStyle(color: ),
                ),
                IconButton(
                  color: Colors.white,
                  onPressed: widget.consultPriceProvider.isLoading ||
                          widget.consultPriceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.consultPriceProvider.orderByUpName();
                        },
                  icon: const Icon(
                    Icons.arrow_downward,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:celta_inventario/providers/price_conference_provider.dart';
import 'package:flutter/material.dart';

class PriceConferenceOrderProductsButtons extends StatefulWidget {
  final PriceConferenceProvider priceConferenceProvider;
  const PriceConferenceOrderProductsButtons({
    required this.priceConferenceProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<PriceConferenceOrderProductsButtons> createState() =>
      _PriceConferenceOrderProductsButtonsState();
}

class _PriceConferenceOrderProductsButtonsState
    extends State<PriceConferenceOrderProductsButtons> {
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
                  onPressed: widget.priceConferenceProvider.isLoading ||
                          widget.priceConferenceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.priceConferenceProvider.orderByDownPrice();
                        },
                  icon: const Icon(
                    Icons.arrow_upward,
                  ),
                ),
                const Text("Preço"),
                IconButton(
                  color: Colors.white,
                  onPressed: widget.priceConferenceProvider.isLoading ||
                          widget.priceConferenceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.priceConferenceProvider.orderByUpPrice();
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
                  onPressed: widget.priceConferenceProvider.isLoading ||
                          widget.priceConferenceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.priceConferenceProvider.orderByDownName();
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
                  onPressed: widget.priceConferenceProvider.isLoading ||
                          widget.priceConferenceProvider.isSendingToPrint
                      ? null
                      : () {
                          widget.priceConferenceProvider.orderByUpName();
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

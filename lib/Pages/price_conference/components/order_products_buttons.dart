import 'package:flutter/material.dart';

import '../../../providers/providers.dart';

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
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
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
                  ),
                  const FittedBox(child: Text("Preço")),
                  Expanded(
                    child: IconButton(
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
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: IconButton(
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
                  ),
                  const FittedBox(child: Text("Nome")),
                  Expanded(
                    child: IconButton(
                      color: Colors.white,
                      onPressed: widget.priceConferenceProvider.isLoading ||
                              widget.priceConferenceProvider.isSendingToPrint
                          ? null
                          : () {
                              widget.priceConferenceProvider.orderByUpName();
                            },
                      icon: const Icon(Icons.arrow_downward),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

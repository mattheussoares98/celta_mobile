import 'package:flutter/material.dart';

import '../../../providers/providers.dart';

class LastSaleRequestSaved extends StatelessWidget {
  final SaleRequestProvider saleRequestProvider;
  const LastSaleRequestSaved({
    required this.saleRequestProvider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: saleRequestProvider.lastSaleRequestSaved == ""
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                child: Text(
                  saleRequestProvider.lastSaleRequestSaved,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
            ),
    );
  }
}

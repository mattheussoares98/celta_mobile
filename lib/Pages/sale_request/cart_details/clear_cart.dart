import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class ClearCart extends StatelessWidget {
  final int enterpriseCode;

  const ClearCart({
    required this.enterpriseCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    return TextButton(
      onPressed: () {
        ShowAlertDialog.show(
          context: context,
          title: "Limpar carrinho",
          content: const SingleChildScrollView(
            child: Text(
              "Deseja realmente limpar todos produtos do carrinho?",
              textAlign: TextAlign.center,
            ),
          ),
          function: () {
            saleRequestProvider.clearCart(enterpriseCode.toString());
          },
        );
      },
      child: const Text(
        "Limpar carrinho",
        style: TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }
}

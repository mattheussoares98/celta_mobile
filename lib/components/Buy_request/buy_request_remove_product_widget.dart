import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';

buyRequestRemoveProduct({
  required BuyRequestProductsModel product,
  required BuyRequestProvider buyRequestProvider,
  required BuildContext context,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 7,
        child: TitleAndSubtitle.titleAndSubtitle(
          title: "Quantidade",
          value: ConvertString.convertToBrazilianNumber(product.quantity),
          subtitleColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        flex: 4,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            ShowAlertDialog.showAlertDialog(
              context: context,
              title: "Remover produto",
              subtitle: "Remover produto do carrinho?",
              function: () {
                buyRequestProvider.removeProductFromCart(product);
              },
            );
          },
          child: const FittedBox(
            child: Row(
              children: [
                Text(
                  "Remover ",
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

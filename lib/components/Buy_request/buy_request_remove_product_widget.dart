import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';

buyRequestRemoveProduct({
  required BuyRequestProductsModel product,
  required BuyRequestProvider buyRequestProvider,
  required BuildContext context,
  required int index,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 7,
        child: TitleAndSubtitle.titleAndSubtitle(
          fontSize: 15,
          title: "Quantidade",
          value: ConvertString.convertToBrazilianNumber(product.quantity),
          subtitleColor: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(width: 5),
      Icon(
        buyRequestProvider.indexOfSelectedProduct != index
            ? Icons.arrow_drop_down_sharp
            : Icons.arrow_drop_up_sharp,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
      ),
    ],
  );
}

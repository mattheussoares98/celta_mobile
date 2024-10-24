import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/soap/soap.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class CostsQuantityAndTotal extends StatelessWidget {
  final String practicedValue;
  final GetProductJsonModel product;
  final int index;
  const CostsQuantityAndTotal({
    required this.practicedValue,
    required this.product,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return Column(
      children: [
        TitleAndSubtitle.titleAndSubtitle(
          fontSize: 15,
          title: "Custo",
          subtitle: ConvertString.convertToBRL(practicedValue, decimalHouses: 4),
          subtitleColor:
              double.parse(practicedValue) == 0 ? Colors.red : Colors.green,
          otherWidget: Row(
            children: [
              if (product.quantity == 0)
                Icon(
                  buyRequestProvider.indexOfSelectedProduct != index
                      ? Icons.arrow_drop_down_sharp
                      : Icons.arrow_drop_up_sharp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              InkWell(
                child: Icon(
                  Icons.delete,
                  color: product.quantity! > 0 &&
                          !buyRequestProvider.isLoadingInsertBuyRequest
                      ? Colors.red
                      : Colors.grey,
                  size: 25,
                ),
                onTap: product.quantity == 0 ||
                        buyRequestProvider.isLoadingInsertBuyRequest
                    ? null
                    : () {
                        ShowAlertDialog.show(
                          context: context,
                          title: "Remover produto",
                          subtitle: "Remover produto do carrinho?",
                          function: () {
                            buyRequestProvider.removeProductFromCart(product);
                          },
                        );
                      },
              ),
            ],
          ),
        ),
        if (product.quantity! > 0)
          Column(
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "Quantidade",
                subtitle:
                    ConvertString.convertToBrazilianNumber(product.quantity),
                subtitleColor: Theme.of(context).colorScheme.primary,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Total",
                fontSize: 15,
                subtitle: ConvertString.convertToBRL(
                  product.valueTyped! * product.quantity!,
                  decimalHouses: 4,
                ),
                subtitleColor: Theme.of(context).colorScheme.primary,
                otherWidget: product.quantity == 0
                    ? null
                    : Icon(
                        buyRequestProvider.indexOfSelectedProduct != index
                            ? Icons.arrow_drop_down_sharp
                            : Icons.arrow_drop_up_sharp,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
              ),
            ],
          )
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../models/buy_request/buy_request.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../global_widgets/global_widgets.dart';
import '../buy_request.dart';

class BuyRequestProductsInformations extends StatelessWidget {
  final BuyRequestProvider buyRequestProvider;
  final BuyRequestProductsModel product;
  final String practicedValue;
  final int index;
  const BuyRequestProductsInformations({
    required this.buyRequestProvider,
    required this.index,
    required this.product,
    required this.practicedValue,
    Key? key,
  }) : super(key: key);

  String _enterprisePersonalizedCodeAndName({
    required BuyRequestProvider buyRequestProvider,
    required BuyRequestProductsModel product,
  }) {
    var enterprise = buyRequestProvider.enterprises.firstWhere(
      (element) => product.EnterpriseCode == element.Code,
    );

    return "(${enterprise.PersonalizedCode}) - " + enterprise.Name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleAndSubtitle.titleAndSubtitle(
          fontSize: 20,
          subtitleColor: Colors.yellow[900],
          value: _enterprisePersonalizedCodeAndName(
            buyRequestProvider: buyRequestProvider,
            product: product,
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          fontSize: 15,
          title: "PLU",
          value: product.PLU,
          otherWidget: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BuyRequestCostsAndStocks(
                product: product,
                context: context,
                isLoading: buyRequestProvider.isLoadingInsertBuyRequest,
              ),
            ],
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          fontSize: 15,
          title: "Nome",
          value: product.Name,
        ),
        TitleAndSubtitle.titleAndSubtitle(
          fontSize: 15,
          title: "Embalagem",
          value: product.PackingQuantity,
          otherWidget: InkWell(
            child: Icon(
              Icons.delete,
              color: product.quantity > 0 &&
                      !buyRequestProvider.isLoadingInsertBuyRequest
                  ? Colors.red
                  : Colors.grey,
              size: 25,
            ),
            onTap: product.quantity == 0 ||
                    buyRequestProvider.isLoadingInsertBuyRequest
                ? null
                : () {
                    ShowAlertDialog.showAlertDialog(
                      context: context,
                      title: "Remover produto",
                      subtitle: "Remover produto do carrinho?",
                      function: () {
                        buyRequestProvider.removeProductFromCart(product);
                      },
                    );
                  },
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          fontSize: 15,
          title: "Custo",
          value: ConvertString.convertToBRL(practicedValue),
          subtitleColor:
              double.parse(practicedValue) == 0 ? Colors.red : Colors.green,
          otherWidget: product.quantity > 0
              ? null
              : Icon(
                  buyRequestProvider.indexOfSelectedProduct != index
                      ? Icons.arrow_drop_down_sharp
                      : Icons.arrow_drop_up_sharp,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
        ),
        if (product.quantity > 0)
          Column(
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                fontSize: 15,
                title: "Quantidade",
                value: ConvertString.convertToBrazilianNumber(product.quantity),
                subtitleColor: Theme.of(context).colorScheme.primary,
              ),
              TitleAndSubtitle.titleAndSubtitle(
                title: "Total",
                fontSize: 15,
                value: ConvertString.convertToBRL(
                  product.ValueTyped * product.quantity,
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
          ),
      ],
    );
  }
}

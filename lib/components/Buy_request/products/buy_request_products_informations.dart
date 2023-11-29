import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
import 'package:celta_inventario/components/Buy_request/products/buy_request_costs_and_stocks.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/utils/convert_string.dart';
import 'package:flutter/material.dart';

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

  bool _productAlreadyInCart() {
    return buyRequestProvider.productsInCart.indexWhere(
            (element) => element.EnterpriseCode == product.EnterpriseCode) !=
        -1;
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
              color: _productAlreadyInCart() &&
                      !buyRequestProvider.isLoadingInsertBuyRequest
                  ? Colors.red
                  : Colors.grey,
              size: 25,
            ),
            onTap: buyRequestProvider.isLoadingInsertBuyRequest ||
                    buyRequestProvider.productsInCart.indexWhere((element) =>
                            element.EnterpriseCode == product.EnterpriseCode) ==
                        -1
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
          subtitleColor: product.ValueTyped == 0 ? Colors.red : Colors.green,
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

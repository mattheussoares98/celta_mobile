import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/providers/adjust_stock_provider.dart';
import 'package:flutter/material.dart';

class AdjustStockProductsItems extends StatefulWidget {
  final AdjustStockProvider adjustStockProvider;
  final int internalEnterpriseCode;
  const AdjustStockProductsItems({
    required this.internalEnterpriseCode,
    required this.adjustStockProvider,
    Key? key,
  }) : super(key: key);

  @override
  State<AdjustStockProductsItems> createState() =>
      _AdjustStockProductsItemsState();
}

class _AdjustStockProductsItemsState extends State<AdjustStockProductsItems> {
  int selectedIndex = -1;

  TextStyle _fontStyle = const TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontFamily: 'OpenSans',
  );
  TextStyle _fontBoldStyle = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  Widget values({
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "${title}: ",
          style: _fontStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            value,
            style: _fontBoldStyle,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  bool _isLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLoaded) {
      widget.adjustStockProvider.getStockTypeAndJustifications(context);
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: widget.adjustStockProvider.productsCount > 1
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        // if (widget.adjustStockProvider.productsCount > 1)
        if (widget.adjustStockProvider.productsCount > 1)
          PersonalizedCard.personalizedCard(
            context: context,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Selecione o produto para fazer a alteração",
                      textAlign: TextAlign.center,
                      style: _fontBoldStyle,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.adjustStockProvider.productsCount,
                      itemBuilder: (ctx, index) {
                        var product =
                            widget.adjustStockProvider.products[index];
                        return GestureDetector(
                          onTap: () async {
                            widget.adjustStockProvider.updateProduct(product);
                            // widget.adjustStockProvider.;
                          },
                          child: PersonalizedCard.personalizedCard(
                            context: context,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  values(
                                    title: "Nome",
                                    value: product.ProductName,
                                  ),
                                  values(
                                    title: "PLU",
                                    value: product.PriceLookUp,
                                  ),
                                  values(
                                    title: "Embalagem",
                                    value: product.PackingQuantity,
                                  ),
                                  values(
                                    title: "Estoque atual",
                                    value: product.CurrentStock,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (widget.adjustStockProvider.productsCount == 1)
          PersonalizedCard.personalizedCard(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  values(
                    title: "Nome",
                    value: widget.adjustStockProvider.products[0].Name,
                  ),
                  values(
                    title: "PLU",
                    value: widget.adjustStockProvider.products[0].PriceLookUp,
                  ),
                  values(
                    title: "Embalagem",
                    value:
                        widget.adjustStockProvider.products[0].PackingQuantity,
                  ),
                  values(
                    title: "Estoque atual",
                    value: widget.adjustStockProvider.products[0].CurrentStock,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

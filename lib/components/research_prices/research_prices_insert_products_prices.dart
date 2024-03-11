import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/research_prices/research_prices.dart';
import '../../providers/providers.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../utils/utils.dart';

class ResearchPricesInsertProductsPrices extends StatefulWidget {
  final bool isAssociatedProducts;
  const ResearchPricesInsertProductsPrices({
    required this.isAssociatedProducts,
    Key? key,
  }) : super(key: key);

  @override
  State<ResearchPricesInsertProductsPrices> createState() =>
      _ResearchPricesInsertProductsPricesState();
}

class _ResearchPricesInsertProductsPricesState
    extends State<ResearchPricesInsertProductsPrices> {
  TextEditingController _searchProductController = TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  void _clearSearchProductController(
      ResearchPricesProvider researchPricesProvider) {
    if (widget.isAssociatedProducts &&
        researchPricesProvider.associatedsProductsCount > 0) {
      _searchProductController.clear();
    } else if (!widget.isAssociatedProducts &&
        researchPricesProvider.notAssociatedProductsCount > 0) {
      _searchProductController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return PopScope(
      onPopInvoked: (_) async {
        if (widget.isAssociatedProducts) {
          researchPricesProvider.clearAssociatedsProducts();
        } else {
          researchPricesProvider.clearNotAssociatedsProducts();
        }
      },
      child: Column(
        children: [
          SearchWidget(
            showOnlyConfigurationOfSearch: true,
            consultProductController: _searchProductController,
            isLoading: false,
            autofocus: false,
            onPressSearch: () async {
              _consultedProductController.clear();

              await researchPricesProvider.getProduct(
                getAssociatedsProducts: widget.isAssociatedProducts,
                searchProductControllerText: _searchProductController.text,
                context: context,
                configurationsProvider: configurationsProvider,
              );

              _clearSearchProductController(researchPricesProvider);
            },
            focusNodeConsultProduct: FocusNode(),
          ),
          if (widget.isAssociatedProducts &&
              researchPricesProvider.errorGetAssociatedsProducts != "")
            ErrorMessage(
              errorMessage: researchPricesProvider.errorGetAssociatedsProducts,
            ),
          if (!widget.isAssociatedProducts &&
              researchPricesProvider.errorGetNotAssociatedsProducts != "")
            ErrorMessage(
              errorMessage:
                  researchPricesProvider.errorGetNotAssociatedsProducts,
            ),
          if (researchPricesProvider.associatedsProductsCount > 0 ||
              researchPricesProvider.notAssociatedProductsCount > 0)
            ResearchPricesProductsItems(
                isAssociatedProducts: widget.isAssociatedProducts,
                consultedProductController: _consultedProductController,
                getProductsWithCamera: () async {
                  FocusScope.of(context).unfocus();
                  _searchProductController.clear();

                  _searchProductController.text =
                      await ScanBarCode.scanBarcode(context);

                  if (_searchProductController.text == "") {
                    return;
                  }

                  await researchPricesProvider.getProduct(
                    getAssociatedsProducts: widget.isAssociatedProducts,
                    searchProductControllerText: _searchProductController.text,
                    context: context,
                    configurationsProvider: configurationsProvider,
                  );

                  if (widget.isAssociatedProducts &&
                      researchPricesProvider.associatedsProductsCount > 0) {
                    _searchProductController.clear();
                  } else if (!widget.isAssociatedProducts &&
                      researchPricesProvider.notAssociatedProductsCount > 0) {
                    _searchProductController.clear();
                  }
                }),
        ],
      ),
    );
  }
}

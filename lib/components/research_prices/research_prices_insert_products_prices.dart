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
    ResearchPricesProvider researchPricesProvider,
  ) {
    if (widget.isAssociatedProducts) {
      _searchProductController.clear();
    } else {
      _searchProductController.clear();
    }
  }

  bool? _isAll = true;
  bool? _withoutCounts = false;
  bool? _withCounts = false;

  _clearCheckValues() {
    _isAll = false;
    _withoutCounts = false;
    _withCounts = false;
  }
  

  void _changeIsAll(_) {
    setState(() {
      _clearCheckValues();
      _isAll = true;
    });
  }

  void _changeWithCounts(_) {
    setState(() {
      _clearCheckValues();
      _withCounts = true;
    });
  }

  void _changeWithoutCounts(_) {
    setState(() {
      _clearCheckValues();
      _withoutCounts = true;
    });
  }

  bool? _withPricesOption() {
    //Null (Todos os produtos)
    if (_isAll == true) return null;
    //True (Somente com preços informados)
    if (_withCounts == true) return true;
    //False (Somente sem preços informados)
    return false;
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

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

              await researchPricesProvider.getAssociatedProducts(
                searchProductControllerText: _searchProductController.text,
                context: context,
                withPrices: _withPricesOption(),
              );

              _clearSearchProductController(researchPricesProvider);
            },
            focusNodeConsultProduct: FocusNode(),
          ),
          if (widget.isAssociatedProducts)
            ResearchPricesFilterAssociatedsProducts(
              changeIsAll: _changeIsAll,
              changeWithCounts: _changeWithCounts,
              changeWithoutCounts: _changeWithoutCounts,
              isAll: _isAll,
              withCounts: _withCounts,
              withoutCounts: _withoutCounts,
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

                  await researchPricesProvider.getAssociatedProducts(
                    searchProductControllerText: _searchProductController.text,
                    context: context,
                    withPrices: _withPricesOption(),
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

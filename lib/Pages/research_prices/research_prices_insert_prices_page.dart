import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/research_prices/research_prices.dart';
import '../../providers/providers.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../utils/utils.dart';

class ResearchPricesInsertPricesPage extends StatefulWidget {
  final bool isAssociatedProducts;
  final TextEditingController searchProductController;
  const ResearchPricesInsertPricesPage({
    required this.isAssociatedProducts,
    required this.searchProductController,
    Key? key,
  }) : super(key: key);

  @override
  State<ResearchPricesInsertPricesPage> createState() =>
      _ResearchPricesInsertPricesPageState();
}

class _ResearchPricesInsertPricesPageState
    extends State<ResearchPricesInsertPricesPage> {
  void _clearSearchProductController(
    ResearchPricesProvider researchPricesProvider,
  ) {
    if (errorMessage(researchPricesProvider) == "") {
      widget.searchProductController.clear();
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

  String errorMessage(
    ResearchPricesProvider researchPricesProvider,
  ) {
    if (widget.isAssociatedProducts) {
      return researchPricesProvider.errorGetAssociatedsProducts;
    } else {
      return researchPricesProvider.errorGetNotAssociatedsProducts;
    }
  }

  Future<void> _getProducts(
    ResearchPricesProvider researchPricesProvider,
  ) async {
    if (widget.isAssociatedProducts) {
      await researchPricesProvider.getAssociatedProducts(
        searchProductControllerText: widget.searchProductController.text,
        context: context,
        withPrices: _withPricesOption(),
      );
    } else {
      await researchPricesProvider.getNotAssociatedProducts(
        searchProductControllerText: widget.searchProductController.text,
      );
    }

    _clearSearchProductController(researchPricesProvider);
  }

  @override
  Widget build(BuildContext context) {
    ResearchPricesProvider researchPricesProvider = Provider.of(context);

    return PopScope(
      onPopInvoked: (_) async {
        researchPricesProvider.clearAssociatedsProducts();
        researchPricesProvider.clearNotAssociatedsProducts();
      },
      child: Column(
        children: [
          SearchWidget(
            showConfigurationsIcon: false,
            consultProductController: widget.searchProductController,
            isLoading: false,
            autofocus: false,
            onPressSearch: () async {
              await _getProducts(researchPricesProvider);
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
          if (errorMessage(researchPricesProvider) != "")
            ErrorMessage(
              errorMessage: errorMessage(researchPricesProvider),
            ),
          if (!researchPricesProvider.isLoadingGetProducts)
            ResearchPricesProductsItems(
                isAssociatedProducts: widget.isAssociatedProducts,
                consultedProductController: widget.searchProductController,
                getProductsWithCamera: () async {
                  FocusScope.of(context).unfocus();
                  _clearSearchProductController(researchPricesProvider);

                  widget.searchProductController.text =
                      await ScanBarCode.scanBarcode(context);

                  if (widget.searchProductController.text == "") {
                    return;
                  }

                  await researchPricesProvider.getAssociatedProducts(
                    searchProductControllerText:
                        widget.searchProductController.text,
                    context: context,
                    withPrices: _withPricesOption(),
                  );

                  if (widget.isAssociatedProducts &&
                      researchPricesProvider.associatedsProductsCount > 0) {
                    _clearSearchProductController(researchPricesProvider);
                  } else if (!widget.isAssociatedProducts &&
                      researchPricesProvider.notAssociatedProductsCount > 0) {
                    _clearSearchProductController(researchPricesProvider);
                  }
                }),
        ],
      ),
    );
  }
}

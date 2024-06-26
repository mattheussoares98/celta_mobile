import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'insert_products.dart';

class InsertProductsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  const InsertProductsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<InsertProductsPage> createState() => _InsertProductsPageState();
}

class _InsertProductsPageState extends State<InsertProductsPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchProductTextEditingController.dispose();
    _consultedProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchWidget(
          consultProductController: _searchProductTextEditingController,
          isLoading: saleRequestProvider.isLoadingProducts,
          autofocus: false,
          onPressSearch: () async {
            _consultedProductController.clear();

            await saleRequestProvider.getProducts(
              context: context,
              configurationsProvider: configurationsProvider,
              enterpriseCode: widget.enterpriseCode,
              controllerText: _searchProductTextEditingController.text,
              requestTypeCode: widget.requestTypeCode,
            );

            if (saleRequestProvider.productsCount > 0) {
              _searchProductTextEditingController.clear();
            }
          },
          focusNodeConsultProduct: saleRequestProvider.searchProductFocusNode,
        ),
        if (saleRequestProvider.errorMessageProducts != "")
          ErrorMessage(
            errorMessage: saleRequestProvider.errorMessageProducts,
          ),
        ProductsItems(
            consultedProductController: _consultedProductController,
            enterpriseCode: widget.enterpriseCode,
            getProductsWithCamera: () async {
              FocusScope.of(context).unfocus();
              _searchProductTextEditingController.clear();

              _searchProductTextEditingController.text =
                  await ScanBarCode.scanBarcode(context);

              if (_searchProductTextEditingController.text == "") {
                return;
              }

              await saleRequestProvider.getProducts(
                configurationsProvider: configurationsProvider,
                context: context,
                enterpriseCode: widget.enterpriseCode,
                controllerText: _searchProductTextEditingController.text,
                requestTypeCode: widget.requestTypeCode,
              );

              if (saleRequestProvider.productsCount > 0) {
                _searchProductTextEditingController.clear();
              }
            }),
      ],
    );
  }
}

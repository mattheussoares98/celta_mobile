import 'package:celta_inventario/Components/Sale_request/sale_request_products_items.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Global_widgets/searching_widget.dart';

class SaleRequestInsertProductsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  const SaleRequestInsertProductsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestInsertProductsPage> createState() =>
      _SaleRequestInsertProductsPageState();
}

class _SaleRequestInsertProductsPageState
    extends State<SaleRequestInsertProductsPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);

    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        saleRequestProvider.clearProducts();
      },
      child: Column(
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
          if (saleRequestProvider.isLoadingProducts)
            Expanded(
              child: searchingWidget(title: "Consultando produtos"),
            ),
          if (saleRequestProvider.productsCount > 0)
            SaleRequestProductsItems(
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
      ),
    );
  }
}

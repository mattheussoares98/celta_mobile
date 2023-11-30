import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/components/Transfer_request/transfer_request_products_items.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Global_widgets/searching_widget.dart';

class TransferRequestInsertProductsPage extends StatefulWidget {
  final String requestTypeCode;
  final String enterpriseOriginCode;
  final String enterpriseDestinyCode;
  const TransferRequestInsertProductsPage({
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferRequestInsertProductsPage> createState() =>
      _TransferRequestInsertProductsPageState();
}

class _TransferRequestInsertProductsPageState
    extends State<TransferRequestInsertProductsPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        transferRequestProvider.clearProducts();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchWidget(
            consultProductController: _searchProductTextEditingController,
            isLoading: transferRequestProvider.isLoadingProducts,
            autofocus: false,
            onPressSearch: () async {
              _consultedProductController.clear();

              await transferRequestProvider.getProducts(
                requestTypeCode: widget.requestTypeCode.toString(),
                enterpriseOriginCode: widget.enterpriseOriginCode,
                enterpriseDestinyCode: widget.enterpriseDestinyCode,
                value: _searchProductTextEditingController.text,
                configurationsProvider: configurationsProvider,
              );

              if (transferRequestProvider.productsCount > 0) {
                _searchProductTextEditingController.clear();
              }
            },
            focusNodeConsultProduct:
                transferRequestProvider.searchProductFocusNode,
          ),
          if (transferRequestProvider.errorMessageProducts != "")
            ErrorMessage(
              errorMessage: transferRequestProvider.errorMessageProducts,
            ),
          if (transferRequestProvider.isLoadingProducts)
            Expanded(
              child: searchingWidget(title: "Consultando produtos"),
            ),
          if (transferRequestProvider.productsCount > 0)
            TransferRequestProductsItems(
              consultedProductController: _consultedProductController,
              getProductsWithCamera: () async {
                FocusScope.of(context).unfocus();
                _searchProductTextEditingController.clear();

                _searchProductTextEditingController.text =
                    await ScanBarCode.scanBarcode(context);

                if (_searchProductTextEditingController.text == "") {
                  return;
                }

                await transferRequestProvider.getProducts(
                  requestTypeCode: widget.requestTypeCode.toString(),
                  enterpriseOriginCode: widget.enterpriseOriginCode,
                  enterpriseDestinyCode: widget.enterpriseDestinyCode,
                  value: _searchProductTextEditingController.text,
                  configurationsProvider: configurationsProvider,
                );

                if (transferRequestProvider.productsCount > 0) {
                  _searchProductTextEditingController.clear();
                }
              },
            ),
        ],
      ),
    );
  }
}

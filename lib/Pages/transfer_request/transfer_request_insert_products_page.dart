import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/transfer_request/transfer_request.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

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

    return Column(
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
    );
  }
}

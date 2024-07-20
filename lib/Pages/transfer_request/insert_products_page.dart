import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class InsertProductsPage extends StatefulWidget {
  final String requestTypeCode;
  final String enterpriseOriginCode;
  final String enterpriseDestinyCode;
  const InsertProductsPage({
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
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
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
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
            ProductsItems(
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
      ),
    );
  }
}

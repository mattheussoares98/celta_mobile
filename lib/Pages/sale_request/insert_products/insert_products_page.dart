import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
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
  TextEditingController _newQuantityController = TextEditingController();
  FocusNode _searchProductFocusNode = FocusNode();
  FocusNode _consultedProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _searchProductTextEditingController.dispose();
    _newQuantityController.dispose();
    _searchProductFocusNode.dispose();
    _consultedProductFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchWidget(
              searchProductController: _searchProductTextEditingController,
              isLoading: saleRequestProvider.isLoadingProducts,
              autofocus: false,
              onPressSearch: () async {
                _newQuantityController.clear();

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
              searchProductFocusNode: _searchProductFocusNode,
            ),
            if (saleRequestProvider.errorMessageProducts != "")
              ErrorMessage(
                errorMessage: saleRequestProvider.errorMessageProducts,
              ),
            ProductsItems(
                newQuantityController: _newQuantityController,
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
      ),
    );
  }
}

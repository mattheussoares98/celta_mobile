import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/configurations/configurations.dart';
import '../../../models/enterprise/enterprise.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'insert_products.dart';

class InsertProductsPage extends StatefulWidget {
  final EnterpriseModel enterprise;
  final int requestTypeCode;
  const InsertProductsPage({
    required this.enterprise,
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
              configurations: [
                ConfigurationType.autoScan,
                ConfigurationType.legacyCode,
                ConfigurationType.personalizedCode,
              ],
              searchProductController: _searchProductTextEditingController,
              autofocus: false,
              onPressSearch: () async {
                _newQuantityController.clear();

                await saleRequestProvider.getProducts(
                  context: context,
                  configurationsProvider: configurationsProvider,
                  enterprise: widget.enterprise,
                  controllerText: _searchProductTextEditingController.text,
                  requestTypeCode: widget.requestTypeCode,
                );

                if (saleRequestProvider.productsCount > 0) {
                  _searchProductTextEditingController.clear();
                }
              },
              searchFocusNode: _searchProductFocusNode,
            ),
            if (saleRequestProvider.errorMessageProducts != "")
              ErrorMessage(
                errorMessage: saleRequestProvider.errorMessageProducts,
              ),
            ProductsItems(
                newQuantityController: _newQuantityController,
                enterprise: widget.enterprise,
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
                    enterprise: widget.enterprise,
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

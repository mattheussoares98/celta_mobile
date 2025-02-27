import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../models/configurations/configurations.dart';
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
  TextEditingController searchProductTextEditingController =
      TextEditingController();
  final searchProductFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    searchProductTextEditingController.dispose();
    searchProductFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    EnterpriseProvider enterpriseProvider = Provider.of(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchWidget(
              searchProductController: searchProductTextEditingController,
              autofocus: false,
              configurations: [
                ConfigurationType.autoScan,
                ConfigurationType.legacyCode,
                ConfigurationType.personalizedCode,
              ],
              onPressSearch: () async {
                await transferRequestProvider.getProducts(
                  requestTypeCode: widget.requestTypeCode.toString(),
                  enterpriseOriginCode: widget.enterpriseOriginCode,
                  enterpriseDestinyCode: widget.enterpriseDestinyCode,
                  value: searchProductTextEditingController.text,
                  configurationsProvider: configurationsProvider,
                  enterpriseProvider: enterpriseProvider,
                );

                if (transferRequestProvider.products.length > 0) {
                  searchProductTextEditingController.clear();
                }
              },
              searchFocusNode: searchProductFocusNode,
            ),
            if (transferRequestProvider.errorMessageProducts != "")
              ErrorMessage(
                errorMessage: transferRequestProvider.errorMessageProducts,
              ),
            ProductsItems(
              getProductsWithCamera: () async {
                FocusScope.of(context).unfocus();
                searchProductTextEditingController.clear();

                searchProductTextEditingController.text =
                    await ScanBarCode.scanBarcode(context);

                if (searchProductTextEditingController.text == "") {
                  return;
                }

                await transferRequestProvider.getProducts(
                  requestTypeCode: widget.requestTypeCode.toString(),
                  enterpriseOriginCode: widget.enterpriseOriginCode,
                  enterpriseDestinyCode: widget.enterpriseDestinyCode,
                  value: searchProductTextEditingController.text,
                  configurationsProvider: configurationsProvider,
                  enterpriseProvider: enterpriseProvider,
                );

                if (transferRequestProvider.products.length > 0) {
                  searchProductTextEditingController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

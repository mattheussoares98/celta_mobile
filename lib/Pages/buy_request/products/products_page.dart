import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import 'products.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  TextEditingController consultProductController = TextEditingController();

  Future<void> getProductWithCamera({
    required BuyRequestProvider buyRequestProvider,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    FocusScope.of(context).unfocus();
    consultProductController.clear();

    consultProductController.text = await ScanBarCode.scanBarcode(context);

    if (consultProductController.text == "") {
      return;
    }

    await buyRequestProvider.getProducts(
      searchValue: consultProductController.text,
      configurationsProvider: configurationsProvider,
    );

    if (buyRequestProvider.productsCount > 0) {
      consultProductController.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();

    consultProductController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    return SingleChildScrollView(
      primary: false,
      child: Column(
        children: [
          SearchWidget(
            autofocus: false,
            showConfigurationsIcon: true,
            searchProductController: consultProductController,
            isLoading: buyRequestProvider.isLoadingProducts,
            onPressSearch: () async {
              await buyRequestProvider.getProducts(
                configurationsProvider: configurationsProvider,
                searchValue: consultProductController.text,
              );

              if (buyRequestProvider.errorMessageGetProducts == "") {
                consultProductController.text = "";
              }
            },
            searchProductFocusNode: buyRequestProvider.focusNodeConsultProduct,
          ),
          if (buyRequestProvider.errorMessageGetProducts != "")
            ErrorMessage(
              errorMessage: buyRequestProvider.errorMessageGetProducts,
            ),
          const ProductsItems(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/global_widgets/global_widgets.dart';
import '../../components/buy_request/products/products.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class BuyRequestInsertProductsPage extends StatefulWidget {
  const BuyRequestInsertProductsPage({Key? key}) : super(key: key);

  @override
  State<BuyRequestInsertProductsPage> createState() =>
      _BuyRequestInsertProductsPageState();
}

class _BuyRequestInsertProductsPageState
    extends State<BuyRequestInsertProductsPage> {
  TextEditingController consultProductController = TextEditingController();

  getProductWithCamera({
    required BuyRequestProvider buyRequestProvider,
    required ConfigurationsProvider configurationsProvider,
  }) async {
    FocusScope.of(context).unfocus();
    consultProductController.clear();

    consultProductController.text = await ScanBarCode.scanBarcode(context);

    if (consultProductController.text == "") {
      return;
    }

    buyRequestProvider.getProducts(
      searchValue: consultProductController.text,
      context: context,
      configurationsProvider: configurationsProvider,
    );

    if (buyRequestProvider.productsCount > 0) {
      consultProductController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchWidget(
            autofocus: false,
            showConfigurationsIcon: true,
            consultProductController: consultProductController,
            isLoading: buyRequestProvider.isLoadingProducts,
            onPressSearch: () async {
              await buyRequestProvider.getProducts(
                configurationsProvider: configurationsProvider,
                searchValue: consultProductController.text,
                context: context,
              );

              if (buyRequestProvider.errorMessageGetProducts == "") {
                consultProductController.text = "";
              }
            },
            focusNodeConsultProduct: buyRequestProvider.focusNodeConsultProduct,
          ),
          if (buyRequestProvider.isLoadingProducts)
            SearchingWidget(title: "Consultando produtos"),
          const BuyRequestProductsItems(),
        ],
      ),
    );
  }
}

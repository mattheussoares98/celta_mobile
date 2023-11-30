import 'package:celta_inventario/components/Buy_request/products/buy_request_products_items.dart';
import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/components/Global_widgets/searching_widget.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            searchingWidget(title: "Consultando produtos"),
          const BuyRequestProductsItems(),
        ],
      ),
    );
  }
}

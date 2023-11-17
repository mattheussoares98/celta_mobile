import 'package:celta_inventario/components/Buy_request/buy_request_products_items.dart';
import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
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

  getProductWithCamera(BuyRequestProvider buyRequestProvider) async {
    FocusScope.of(context).unfocus();
    consultProductController.clear();

    consultProductController.text = await ScanBarCode.scanBarcode(context);

    if (consultProductController.text == "") {
      return;
    }

    buyRequestProvider.getProducts(
      searchValue: consultProductController.text,
      context: context,
    );

    if (buyRequestProvider.productsCount > 0) {
      consultProductController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchWidget(
            autofocus: false,
            showConfigurationsIcon: false,
            consultProductController: consultProductController,
            isLoading: buyRequestProvider.isLoadingProducts,
            onPressSearch: () async {
              await buyRequestProvider.getProducts(
                searchValue: consultProductController.text,
                context: context,
              );
            },
            focusNodeConsultProduct: buyRequestProvider.focusNodeConsultProduct,
          ),
          if (buyRequestProvider.isLoadingProducts)
            const CircularProgressIndicator(),
          const BuyRequestProductsItems(),
        ],
      ),
    );
  }
}

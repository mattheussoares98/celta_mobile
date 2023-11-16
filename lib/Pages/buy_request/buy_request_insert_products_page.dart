import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/buy_request_models/buy_request_product_model.dart';
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
  TextEditingController consultedProductController = TextEditingController();
  final GlobalKey<FormState> insertQuantityFormKey = GlobalKey();
  FocusNode focusNodeConsultProduct = FocusNode();
  FocusNode focusNodeConsultedProduct = FocusNode();

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SearchWidget(
            consultProductController: consultProductController,
            isLoading: buyRequestProvider.isLoadingProducts,
            onPressSearch: () async {
              await buyRequestProvider.getProducts(
                searchValue: consultProductController.text,
                context: context,
              );
            },
            focusNodeConsultProduct: focusNodeConsultProduct,
          ),
          if (buyRequestProvider.isLoadingProducts)
            const CircularProgressIndicator(),
          BuyRequestProductsItems(
            insertQuantityFormKey: insertQuantityFormKey,
            internalEnterpriseCode: 1,
            consultedProductController: consultedProductController,
            consultedProductFocusNode: focusNodeConsultedProduct,
            getProductWithCamera: () async {
              FocusScope.of(context).unfocus();
              consultProductController.clear();

              consultProductController.text =
                  await ScanBarCode.scanBarcode(context);

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
            },
          ),
        ],
      ),
    );
  }
}

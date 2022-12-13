import 'package:celta_inventario/Components/Sale_request/sale_request_products_items.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestInsertProductsPage extends StatefulWidget {
  const SaleRequestInsertProductsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestInsertProductsPage> createState() =>
      _SaleRequestInsertProductsPageState();
}

class _SaleRequestInsertProductsPageState
    extends State<SaleRequestInsertProductsPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        saleRequestProvider.clearProducts();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchWidget(
            consultProductController: _searchProductTextEditingController,
            isLoading: saleRequestProvider.isLoadingProducts,
            autofocus: false,
            onPressSearch: () async {
              _consultedProductController.clear();

              await saleRequestProvider.getProducts(
                context: context,
                enterpriseCode: 2,
                searchValueControllerText:
                    _searchProductTextEditingController.text,
              );

              if (saleRequestProvider.productsCount > 0) {
                _searchProductTextEditingController.clear();
              }
            },
            focusNodeConsultProduct: saleRequestProvider.searchProductFocusNode,
          ),
          if (saleRequestProvider.errorMessageProducts != "")
            ErrorMessage(
              errorMessage: saleRequestProvider.errorMessageProducts,
            ),
          if (saleRequestProvider.isLoadingProducts)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: "Consultando produtos"),
            ),
          if (saleRequestProvider.productsCount > 0)
            SaleRequestProductsItems(
              consultedProductController: _consultedProductController,
            ),
        ],
      ),
    );
  }
}

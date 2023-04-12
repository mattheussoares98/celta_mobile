import 'package:celta_inventario/Components/Sale_request/sale_request_products_items.dart';
import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleRequestInsertProductsPage extends StatefulWidget {
  final int enterpriseCode;
  const SaleRequestInsertProductsPage({
    required this.enterpriseCode,
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

  bool _legacyIsSelected = false;

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
            hasLegacyCodeSearch: true,
            legacyIsSelected: _legacyIsSelected,
            changeLegacyIsSelectedFunction: () {
              setState(() {
                _legacyIsSelected = !_legacyIsSelected;
              });
            },
            onPressSearch: () async {
              _consultedProductController.clear();

              await saleRequestProvider.getProducts(
                isLegacyCodeSearch: _legacyIsSelected,
                context: context,
                enterpriseCode: widget.enterpriseCode,
                controllerText: _searchProductTextEditingController.text,
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
              enterpriseCode: widget.enterpriseCode,
            ),
        ],
      ),
    );
  }
}

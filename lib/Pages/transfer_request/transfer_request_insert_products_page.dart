import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/components/Transfer_request/transfer_request_products_items.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransferRequestInsertProductsPage extends StatefulWidget {
  final String requestTypeCode;
  final String enterpriseOriginCode;
  final String enterpriseDestinyCode;
  const TransferRequestInsertProductsPage({
    required this.requestTypeCode,
    required this.enterpriseOriginCode,
    required this.enterpriseDestinyCode,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferRequestInsertProductsPage> createState() =>
      _TransferRequestInsertProductsPageState();
}

class _TransferRequestInsertProductsPageState
    extends State<TransferRequestInsertProductsPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

  bool _legacyIsSelected = false;

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        transferRequestProvider.clearProducts();
        return true;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchWidget(
            consultProductController: _searchProductTextEditingController,
            isLoading: transferRequestProvider.isLoadingProducts,
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

              await transferRequestProvider.getProducts(
                requestTypeCode: widget.requestTypeCode.toString(),
                enterpriseOriginCode: widget.enterpriseOriginCode,
                enterpriseDestinyCode: widget.enterpriseDestinyCode,
                value: _searchProductTextEditingController.text,
                isLegacyCodeSearch: _legacyIsSelected,
              );

              if (transferRequestProvider.productsCount > 0) {
                _searchProductTextEditingController.clear();
              }
            },
            focusNodeConsultProduct:
                transferRequestProvider.searchProductFocusNode,
          ),
          if (transferRequestProvider.errorMessageProducts != "")
            ErrorMessage(
              errorMessage: transferRequestProvider.errorMessageProducts,
            ),
          if (transferRequestProvider.isLoadingProducts)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: "Consultando produtos"),
            ),
          if (transferRequestProvider.productsCount > 0)
            TransferRequestProductsItems(
              consultedProductController: _consultedProductController,
            ),
        ],
      ),
    );
  }
}

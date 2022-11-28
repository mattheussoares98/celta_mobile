import 'package:celta_inventario/Components/Procedures_items_widgets/sale_request_products_items.dart';
import 'package:celta_inventario/Components/search_product_with_ean_plu_or_name_widget.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class SaleRequestPage extends StatefulWidget {
  const SaleRequestPage({Key? key}) : super(key: key);

  @override
  State<SaleRequestPage> createState() => _SaleRequestPageState();
}

class _SaleRequestPageState extends State<SaleRequestPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    int codigoInternoEmpresa =
        ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pedido de vendas",
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            tooltip: 'Open shopping cart',
            onPressed: () {
              // handle the press
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchProductWithEanPluOrNameWidget(
            consultProductController: _searchProductTextEditingController,
            isLoading: false,
            onPressSearch: () async {
              await saleRequestProvider.getProducts(
                context: context,
                enterpriseCode: codigoInternoEmpresa,
                searchValueControllerText:
                    _searchProductTextEditingController.text,
              );
            },
            focusNodeConsultProduct: saleRequestProvider.searchProductFocusNode,
          ),
          const SaleRequestProductsItems(),
          TextButton(
            onPressed: saleRequestProvider.isLoadingRequestType
                ? null
                : () async {
                    await saleRequestProvider.getRequestType(
                      enterpriseCode: codigoInternoEmpresa,
                      context: context,
                    );
                  },
            child: const Text("modelo de nota"),
          ),
          TextButton(
            onPressed: saleRequestProvider.isLoadingCostumer
                ? null
                : () async {
                    await saleRequestProvider.getCostumers(
                      searchValueControllerText: "",
                      context: context,
                    );
                  },
            child: const Text("cliente"),
          ),
        ],
      ),
    );
  }
}

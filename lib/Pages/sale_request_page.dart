import 'package:celta_inventario/Components/Procedures_items_widgets/sale_request_products_items.dart';
import 'package:celta_inventario/Components/search_product_with_ean_plu_or_name_widget.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
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
  TextEditingController _consultedProductController = TextEditingController();
  double _quantityToAdd = 0;

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    // int codigoInternoEmpresa =
    //     ModalRoute.of(context)!.settings.arguments as int;

    return WillPopScope(
      onWillPop: () async {
        saleRequestProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            "Pedido de vendas",
          ),
          leading: IconButton(
            onPressed: () {
              saleRequestProvider.clearProducts();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
          actions: [
            Stack(
              children: [
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
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FittedBox(
                        child: Text(
                          saleRequestProvider.products.length.toString(),
                        ),
                      ),
                    ),
                    maxRadius: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchProductWithEanPluOrNameWidget(
              consultProductController: _searchProductTextEditingController,
              isLoading: saleRequestProvider.isLoadingProducts,
              onPressSearch: () async {
                _consultedProductController.clear();

                await saleRequestProvider.getProducts(
                  context: context,
                  enterpriseCode: 2,
                  searchValueControllerText:
                      _searchProductTextEditingController.text,
                );
              },
              focusNodeConsultProduct:
                  saleRequestProvider.searchProductFocusNode,
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                maximumSize: const Size(double.infinity, 50),
                shape: const RoundedRectangleBorder(),
                primary: Colors.red,
              ),
              onPressed: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("Itens"),
                      const Text("1000"),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Total"),
                      const Text("10000 R\$"),
                    ],
                  ),
                  const Text(
                    "VISUALIZAR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

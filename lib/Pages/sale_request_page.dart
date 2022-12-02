import 'package:celta_inventario/Components/Procedures_items_widgets/sale_request_products_items.dart';
import 'package:celta_inventario/Components/search_product_with_ean_plu_or_name_widget.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/convert_string.dart';

class SaleRequestPage extends StatefulWidget {
  const SaleRequestPage({Key? key}) : super(key: key);

  @override
  State<SaleRequestPage> createState() => _SaleRequestPageState();
}

class _SaleRequestPageState extends State<SaleRequestPage> {
  TextEditingController _searchProductTextEditingController =
      TextEditingController();
  TextEditingController _consultedProductController = TextEditingController();

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
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const FittedBox(
            child: Text(
              "Inserção de produtos",
            ),
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
            FittedBox(
              child: Column(
                children: [
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
                                saleRequestProvider.cartProducts.length
                                    .toString(),
                              ),
                            ),
                          ),
                          maxRadius: 11,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      ConvertString.convertToBRL(
                        saleRequestProvider.totalCartPrice,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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

                if (saleRequestProvider.productsCount > 0) {
                  _searchProductTextEditingController.clear();
                }
              },
              focusNodeConsultProduct:
                  saleRequestProvider.searchProductFocusNode,
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
            if (MediaQuery.of(context).viewInsets.bottom ==
                0) //só exibe o botão se o teclado estiver fechado
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
                        Text(
                          saleRequestProvider.cartProducts.length.toString(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("Total"),
                        Text(
                          ConvertString.convertToBRL(
                            saleRequestProvider.totalCartPrice,
                          ),
                        ),
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

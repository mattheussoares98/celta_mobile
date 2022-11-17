import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_product_provider.dart';
import '../../Components/Inventory/inventory_consult_product_widget.dart';
import '../../Components/Inventory/inventory_consulted_product_widget.dart';

class InventoryProductsPage extends StatefulWidget {
  const InventoryProductsPage({Key? key}) : super(key: key);

  @override
  _InventoryProductsPageState createState() => _InventoryProductsPageState();
}

class _InventoryProductsPageState extends State<InventoryProductsPage> {
  bool _isIndividual = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _consultProductController =
      TextEditingController();

  final TextEditingController _consultedProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _consultProductController.dispose();
    _consultedProductController.dispose();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        inventoryProductProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Produtos',
          ),
          leading: IconButton(
            onPressed: () {
              inventoryProductProvider.clearProducts();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ConsultProductWidget(
                        formKey: _formKey,
                        isIndividual: _isIndividual,
                        consultProductController: _consultProductController,
                        consultedProductController: _consultedProductController,
                      ),
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FittedBox(
                              child: Text(
                                'Inserir produto individualmente',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Switch(
                              value: _isIndividual,
                              onChanged: inventoryProductProvider.isLoading ||
                                      inventoryProductProvider.isLoadingQuantity
                                  ? null
                                  : (value) {
                                      setState(() {
                                        _isIndividual = value;
                                      });
                                      if (_isIndividual) {
                                        inventoryProductProvider
                                            .alterFocusToConsultProduct(
                                          context: context,
                                        );
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (inventoryProductProvider.productsCount == 0 &&
                      inventoryProductProvider.errorMessage != "")
                    Container(
                      height: 300,
                      child: Column(
                        children: [
                          ErrorMessage(
                            errorMessage: inventoryProductProvider.errorMessage,
                          ),
                        ],
                      ),
                    ),
                  if (inventoryProductProvider.products.isNotEmpty)
                    ConsultedProductWidget(
                      isIndividual: _isIndividual,
                      countingCode: arguments["InventoryCountingsModel"]
                          .codigoInternoInvCont,
                      productPackingCode: arguments["InventoryCountingsModel"]
                          .numeroContagemInvCont,
                      consultedProductController: _consultedProductController,
                    ),
                  Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

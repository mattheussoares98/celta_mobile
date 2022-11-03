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
  final _consultProductFocusNode = FocusNode();

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
    _consultProductFocusNode.dispose();
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
              padding: const EdgeInsets.only(left: 8, right: 8, top: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConsultProductWidget(
                    formKey: _formKey,
                    isIndividual: _isIndividual,
                    consultProductFocusNode: _consultProductFocusNode,
                    consultProductController: _consultProductController,
                    consultedProductController: _consultedProductController,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Inserir produto individualmente',
                          style: TextStyle(
                            fontSize: 30,
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
                                      consultProductFocusNode:
                                          _consultProductFocusNode,
                                    );
                                  }
                                },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (inventoryProductProvider.products.isNotEmpty)
                    ConsultedProductWidget(
                      isIndividual: _isIndividual,
                      countingCode: arguments["InventoryCountingsModel"]
                          .codigoInternoInvCont,
                      productPackingCode: arguments["InventoryCountingsModel"]
                          .numeroContagemInvCont,
                      consultedProductController: _consultedProductController,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

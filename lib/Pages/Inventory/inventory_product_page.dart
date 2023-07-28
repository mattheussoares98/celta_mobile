import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/components/Inventory/inventory_products_items.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Components/Inventory/inventory_consult_product_widget.dart';

class InventoryProductsPage extends StatefulWidget {
  const InventoryProductsPage({Key? key}) : super(key: key);

  @override
  _InventoryProductsPageState createState() => _InventoryProductsPageState();
}

class _InventoryProductsPageState extends State<InventoryProductsPage> {
  bool _isIndividual = false;

  final TextEditingController _consultProductController =
      TextEditingController();

  final TextEditingController _consultedProductController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: () async {
        inventoryProvider.clearProducts();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'PRODUTOS',
          ),
          leading: IconButton(
            onPressed: () {
              inventoryProvider.clearProducts();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ConsultProductWidget(
                    isIndividual: _isIndividual,
                    consultProductController: _consultProductController,
                    consultedProductController: _consultedProductController,
                    changeIsIndividual: () {
                      setState(() {
                        _isIndividual = !_isIndividual;
                      });
                    }),
              ],
            ),
            if (inventoryProvider.productsCount == 0 &&
                inventoryProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage: inventoryProvider.errorMessageGetProducts,
              ),
            if (inventoryProvider.products.isNotEmpty)
              InventoryProductsItems(
                isIndividual: _isIndividual,
                countingCode:
                    arguments["InventoryCountingsModel"].codigoInternoInvCont,
                productPackingCode:
                    arguments["InventoryCountingsModel"].numeroContagemInvCont,
                consultedProductController: _consultedProductController,
              ),
            Container()
          ],
        ),
      ),
    );
  }
}

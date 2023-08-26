import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/components/Inventory/inventory_search_product_button.dart';
import 'package:celta_inventario/components/Inventory/inventory_insert_individual_product_switch.dart';
import 'package:celta_inventario/components/Inventory/inventory_products_items.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> _searchProduct({
    required InventoryProvider inventoryProvider,
    required dynamic arguments,
  }) async {
    _consultedProductController.clear();

    if (_consultProductController.text.isEmpty) {
      //se não digitar o ean ou plu, vai abrir a câmera
      _consultProductController.text = await ScanBarCode.scanBarcode();
    }

    if (_consultProductController.text.isEmpty) return;

    //se ler algum código, vai consultar o produto
    await inventoryProvider.getProductsAndAddIfIsIndividual(
      consultProductController: _consultProductController,
      isLegacyCodeSearch: inventoryProvider.useLegacyCode,
      enterpriseCode: arguments["codigoInternoEmpresa"],
      context: context,
      isIndividual: _isIndividual,
      consultedProductController: _consultProductController,
      indexOfProduct: 0, //não da pra obter por aqui o index do produto
      inventoryProcessCode:
          arguments["InventoryCountingsModel"].codigoInternoInventario,

      inventoryCountingCode:
          arguments["InventoryCountingsModel"].codigoInternoInvCont,
    );

    if (inventoryProvider.products.isNotEmpty && _isIndividual) {
      inventoryProvider.alterFocusToConsultProduct(
        context: context,
      );
    }

    if (_consultProductController.text.isEmpty) {
      _consultProductController.clear();
    }
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
                SearchWidget(
                  useAutoScan: inventoryProvider.useAutoScan,
                  useLegacyCode: inventoryProvider.useLegacyCode,
                  changeAutoScanValue: () {
                    setState(() {
                      inventoryProvider.useAutoScan =
                          !inventoryProvider.useAutoScan;
                    });
                  },
                  changeLegacyCodeValue: () {
                    setState(() {
                      inventoryProvider.useLegacyCode =
                          !inventoryProvider.useLegacyCode;
                    });
                  },
                  consultProductController: _consultProductController,
                  isLoading: inventoryProvider.isLoadingProducts ||
                      inventoryProvider.isLoadingQuantity,
                  onPressSearch: () async {
                    await _searchProduct(
                      inventoryProvider: inventoryProvider,
                      arguments: arguments,
                    );
                    if (inventoryProvider.productsCount > 0) {
                      setState(() {
                        _consultProductController.text = "";
                      });
                    }
                  },
                  focusNodeConsultProduct:
                      inventoryProvider.consultProductFocusNode,
                ),
                SearchProductButton(
                  isIndividual: _isIndividual,
                  searchProduct: () async {
                    await _searchProduct(
                      inventoryProvider: inventoryProvider,
                      arguments: arguments,
                    );
                    if (inventoryProvider.productsCount > 0) {
                      setState(() {
                        _consultProductController.text = "";
                      });
                    }
                  },
                ),
                InventoryInsertIndividualProductSwitch(
                  isIndividual: _isIndividual,
                  isLoading: inventoryProvider.isLoadingProducts ||
                      inventoryProvider.isLoadingQuantity,
                  changeValue: () {
                    setState(() {
                      _isIndividual = !_isIndividual;
                    });
                  },
                ),
              ],
            ),
            if (inventoryProvider.productsCount == 0 &&
                inventoryProvider.errorMessageGetProducts != "")
              ErrorMessage(
                errorMessage: inventoryProvider.errorMessageGetProducts,
              ),
            if (inventoryProvider.products.isNotEmpty)
              InventoryProductsItems(
                getProducts: () async {
                  await _searchProduct(
                    inventoryProvider: inventoryProvider,
                    arguments: arguments,
                  );
                },
                isIndividual: _isIndividual,
                inventoryProcessCode:
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

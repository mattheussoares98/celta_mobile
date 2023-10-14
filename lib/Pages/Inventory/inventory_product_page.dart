import 'package:celta_inventario/Components/Global_widgets/error_message.dart';
import 'package:celta_inventario/components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/components/Inventory/inventory_search_product_button.dart';
import 'package:celta_inventario/components/Inventory/inventory_insert_individual_product_switch.dart';
import 'package:celta_inventario/components/Inventory/inventory_products_items.dart';
import 'package:celta_inventario/providers/configurations_provider.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/foundation.dart';
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
    required ConfigurationsProvider configurationsProvider,
    required dynamic arguments,
  }) async {
    _consultedProductController.clear();

    if (_consultProductController.text.isEmpty) {
      //se não digitar o ean ou plu, vai abrir a câmera
      _consultProductController.text = await ScanBarCode.scanBarcode();
    }

    if (_consultProductController.text.isEmpty) return;

    //se ler algum código, vai consultar o produto
    await inventoryProvider.getProducts(
      consultProductController: _consultProductController,
      enterpriseCode: arguments["codigoInternoEmpresa"],
      context: context,
      isIndividual: _isIndividual,
      inventoryProcessCode:
          arguments["InventoryCountingsModel"].codigoInternoInventario,
      inventoryCountingCode:
          arguments["InventoryCountingsModel"].codigoInternoInvCont,
      configurationsProvider: configurationsProvider,
    );

    if (inventoryProvider.products.isNotEmpty &&
        _isIndividual &&
        !configurationsProvider.useAutoScan) {
      inventoryProvider.alterFocusToConsultProduct(
        context: context,
      );
    }

    if (inventoryProvider.productsCount > 0) {
      _consultProductController.clear();
    }

    if (inventoryProvider.errorMessageGetProducts == "" &&
        _isIndividual &&
        inventoryProvider.productsCount == 1) {
      await addQuantity(
        inventoryProvider: inventoryProvider,
        arguments: arguments,
        indexOfProduct: 0,
        configurationsProvider: configurationsProvider,
      );
    }
  }

  addQuantity({
    required InventoryProvider inventoryProvider,
    required ConfigurationsProvider configurationsProvider,
    required dynamic arguments,
    required int indexOfProduct,
  }) async {
    await inventoryProvider.addQuantity(
      indexOfProduct: indexOfProduct,
      isIndividual: _isIndividual,
      context: context,
      isSubtract: false,
      countingCode: arguments["InventoryCountingsModel"].codigoInternoInvCont,
      consultedProductController: _consultedProductController,
      configurationsProvider: configurationsProvider,
    );

    if (inventoryProvider.errorMessageGetProducts == '' &&
        configurationsProvider.useAutoScan) {
      await _searchProduct(
        inventoryProvider: inventoryProvider,
        arguments: arguments,
        configurationsProvider: configurationsProvider,
      );
    }
  }

  Widget searchButtonAndIndividualSwitch({
    required InventoryProvider inventoryProvider,
    required ConfigurationsProvider configurationsProvider,
  }) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return MediaQuery.of(context).size.width < 900
        ? Column(
            children: [
              SearchProductButton(
                isIndividual: _isIndividual,
                searchProduct: () async {
                  await _searchProduct(
                    inventoryProvider: inventoryProvider,
                    arguments: arguments,
                    configurationsProvider: configurationsProvider,
                  );
                  if (inventoryProvider.productsCount > 0) {
                    setState(() {
                      _consultProductController.text = "";
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
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
          )
        : Row(
            children: [
              Expanded(
                child: InventoryInsertIndividualProductSwitch(
                  isIndividual: _isIndividual,
                  isLoading: inventoryProvider.isLoadingProducts ||
                      inventoryProvider.isLoadingQuantity,
                  changeValue: () {
                    setState(() {
                      _isIndividual = !_isIndividual;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SearchProductButton(
                  isIndividual: _isIndividual,
                  searchProduct: () async {
                    await _searchProduct(
                      inventoryProvider: inventoryProvider,
                      arguments: arguments,
                      configurationsProvider: configurationsProvider,
                    );
                    if (inventoryProvider.productsCount > 0) {
                      setState(() {
                        _consultProductController.text = "";
                      });
                    }
                  },
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);
    ConfigurationsProvider configurationsProvider =
        Provider.of(context, listen: true);
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return WillPopScope(
      onWillPop: inventoryProvider.isLoadingQuantity
          ? null
          : () async {
              inventoryProvider.clearProducts();
              return true;
            },
      child: Scaffold(
        resizeToAvoidBottomInset: kIsWeb ? false : true,
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
                  consultProductController: _consultProductController,
                  isLoading: inventoryProvider.isLoadingProducts ||
                      inventoryProvider.isLoadingQuantity,
                  onPressSearch: () async {
                    await _searchProduct(
                      inventoryProvider: inventoryProvider,
                      arguments: arguments,
                      configurationsProvider: configurationsProvider,
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
                searchButtonAndIndividualSwitch(
                  inventoryProvider: inventoryProvider,
                  configurationsProvider: configurationsProvider,
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
                    configurationsProvider: configurationsProvider,
                  );
                },
                isIndividual: _isIndividual,
                inventoryCountingCode:
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

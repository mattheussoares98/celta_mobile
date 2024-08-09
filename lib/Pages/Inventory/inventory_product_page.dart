import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import 'components/components.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

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
    _consultProductController.dispose();
    _consultedProductController.dispose();
  }

  Future<void> _searchProduct({
    required InventoryProvider inventoryProvider,
    required ConfigurationsProvider configurationsProvider,
    required dynamic arguments,
  }) async {
    _consultedProductController.clear();

    if (_consultProductController.text.isEmpty) {
      //se não digitar o ean ou plu, vai abrir a câmera
      _consultProductController.text = await ScanBarCode.scanBarcode(context);
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

    if (inventoryProvider.errorMessageQuantity == "" &&
        _isIndividual &&
        inventoryProvider.productsCount == 1 &&
        configurationsProvider.autoScan?.value != true) {
      inventoryProvider.alterFocusToConsultProduct(
        context: context,
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
        configurationsProvider.autoScan?.value == true) {
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
              InsertIndividualProductSwitch(
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
                child: InsertIndividualProductSwitch(
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

    return PopScope(
      onPopInvoked: (value) {
        if (value == true) {
          inventoryProvider.clearProducts();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: kIsWeb ? false : true,
            appBar: AppBar(
              title: const Text(
                'PRODUTOS',
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SearchWidget(
                      searchProductController: _consultProductController,
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
                      searchProductFocusNode:
                          inventoryProvider.consultProductFocusNode,
                    ),
                    searchButtonAndIndividualSwitch(
                      inventoryProvider: inventoryProvider,
                      configurationsProvider: configurationsProvider,
                    ),
                  ],
                ),
                if (inventoryProvider.errorMessageGetProducts != "")
                  Expanded(
                    child: ErrorMessage(
                      errorMessage: inventoryProvider.errorMessageGetProducts,
                    ),
                  ),
                if (inventoryProvider.productsCount > 0)
                  ProductsItems(
                    getProducts: () async {
                      await _searchProduct(
                        inventoryProvider: inventoryProvider,
                        arguments: arguments,
                        configurationsProvider: configurationsProvider,
                      );
                    },
                    isIndividual: _isIndividual,
                    inventoryCountingCode: arguments["InventoryCountingsModel"]
                        .codigoInternoInvCont,
                    productPackingCode: arguments["InventoryCountingsModel"]
                        .numeroContagemInvCont,
                    consultedProductController: _consultedProductController,
                  ),
                Container()
              ],
            ),
          ),
          loadingWidget(
            message: "Consultando produtos...",
            isLoading: inventoryProvider.isLoadingProducts,
          ),
          loadingWidget(
            message: "Confirmando quantidade...",
            isLoading: inventoryProvider.isLoadingQuantity,
          ),
        ],
      ),
    );
  }
}

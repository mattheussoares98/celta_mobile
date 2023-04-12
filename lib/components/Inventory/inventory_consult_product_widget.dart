import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inventory_product_provider.dart';

class ConsultProductWidget extends StatefulWidget {
  final bool isIndividual;
  final TextEditingController consultProductController;
  final TextEditingController consultedProductController;
  const ConsultProductWidget({
    Key? key,
    required this.isIndividual,
    required this.consultedProductController,
    required this.consultProductController,
  }) : super(key: key);

  @override
  State<ConsultProductWidget> createState() => _ConsultProductWidgetState();
}

class _ConsultProductWidgetState extends State<ConsultProductWidget> {
  Future<void> _searchProduct({
    required InventoryProductProvider inventoryProductProvider,
    required dynamic arguments,
  }) async {
    widget.consultedProductController.clear();

    if (widget.consultProductController.text.isEmpty) {
      //se não digitar o ean ou plu, vai abrir a câmera
      widget.consultProductController.text = await ScanBarCode.scanBarcode();
    }

    if (widget.consultProductController.text.isEmpty) return;

    //se ler algum código, vai consultar o produto
    await inventoryProductProvider.getProductsAndAddIfIsIndividual(
      isLegacyCodeSearch: _isLegacyCodeSearch,
      controllerText: widget.consultProductController.text,
      enterpriseCode: arguments["codigoInternoEmpresa"],
      inventoryProcessCode:
          arguments["InventoryCountingsModel"].codigoInternoInventario,
      codigoInternoInvCont:
          arguments["InventoryCountingsModel"].codigoInternoInvCont,
      context: context,
      isIndividual: widget.isIndividual,
      consultedProductController: widget.consultProductController,
    );

    if (inventoryProductProvider.products.isNotEmpty && widget.isIndividual) {
      inventoryProductProvider.alterFocusToConsultProduct(
        context: context,
      );
    }

    if (widget.consultProductController.text.isEmpty) {
      widget.consultProductController.clear();
    }
  }

  bool _isLegacyCodeSearch = false;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        SearchWidget(
          changeLegacyIsSelectedFunction: () {
            setState(() {
              _isLegacyCodeSearch = !_isLegacyCodeSearch;
            });
          },
          legacyIsSelected: _isLegacyCodeSearch,
          hasLegacyCodeSearch: true,
          consultProductController: widget.consultProductController,
          isLoading: inventoryProductProvider.isLoading ||
              inventoryProductProvider.isLoadingQuantity,
          onPressSearch: () async {
            await _searchProduct(
              inventoryProductProvider: inventoryProductProvider,
              arguments: arguments,
            );
          },
          focusNodeConsultProduct:
              inventoryProductProvider.consultProductFocusNode,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 70),
                  maximumSize: const Size(double.infinity, 70),
                ),
                child: inventoryProductProvider.isLoading ||
                        inventoryProductProvider.isLoadingQuantity
                    ? FittedBox(
                        child: Row(
                          children: [
                            Text(
                              inventoryProductProvider.isLoadingQuantity
                                  ? 'ADICIONANDO QUANTIDADE...'
                                  : 'CONSULTANDO O PRODUTO...',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                                fontSize: 100,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Container(
                              height: 100,
                              width: 100,
                              child: const CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FittedBox(
                        child: Row(
                          children: [
                            Text(
                              widget.isIndividual
                                  ? 'CONSULTAR E INSERIR UNIDADE'
                                  : 'CONSULTAR OU ESCANEAR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 50,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              widget.isIndividual
                                  ? Icons.add
                                  : Icons.camera_alt_outlined,
                              size: 70,
                            ),
                            if (widget.isIndividual)
                              const Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 70,
                                ),
                              ),
                          ],
                        ),
                      ),
                onPressed: inventoryProductProvider.isLoading ||
                        inventoryProductProvider.isLoadingQuantity
                    ? null
                    : () async {
                        await _searchProduct(
                          inventoryProductProvider: inventoryProductProvider,
                          arguments: arguments,
                        );
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

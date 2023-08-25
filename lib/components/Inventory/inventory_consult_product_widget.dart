import 'package:celta_inventario/Components/Global_widgets/search_widget.dart';
import 'package:celta_inventario/providers/inventory_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'inventory_insert_individual_product_switch.dart';

class ConsultProductWidget extends StatefulWidget {
  final bool isIndividual;
  final bool isLegacyCodeSearch;
  final TextEditingController consultProductController;
  final TextEditingController consultedProductController;
  final Function changeIsIndividual;
  final Function changeIsLegacyCode;
  final Function searchProduct;
  const ConsultProductWidget({
    Key? key,
    required this.isIndividual,
    required this.searchProduct,
    required this.isLegacyCodeSearch,
    required this.changeIsLegacyCode,
    required this.consultedProductController,
    required this.consultProductController,
    required this.changeIsIndividual,
  }) : super(key: key);

  @override
  State<ConsultProductWidget> createState() => _ConsultProductWidgetState();
}

class _ConsultProductWidgetState extends State<ConsultProductWidget> {
  @override
  Widget build(BuildContext context) {
    InventoryProvider inventoryProvider = Provider.of(context, listen: true);

    return Column(
      children: [
        SearchWidget(
          changeLegacyIsSelectedFunction: () {
            widget.changeIsLegacyCode();
          },
          useLegacyCode: widget.isLegacyCodeSearch,
          hasLegacyCodeSearch: true,
          consultProductController: widget.consultProductController,
          isLoading: inventoryProvider.isLoadingProducts ||
              inventoryProvider.isLoadingQuantity,
          onPressSearch: () async {
            await widget.searchProduct();
          },
          focusNodeConsultProduct: inventoryProvider.consultProductFocusNode,
        ),
        // const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  maximumSize: const Size(double.infinity, 50),
                ),
                child: inventoryProvider.isLoadingProducts ||
                        inventoryProvider.isLoadingQuantity
                    ? FittedBox(
                        child: Row(
                          children: [
                            Text(
                              inventoryProvider.isLoadingQuantity
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
                onPressed: inventoryProvider.isLoadingProducts ||
                        inventoryProvider.isLoadingQuantity
                    ? null
                    : () async {
                        await widget.searchProduct();
                      },
              ),
            ),
          ],
        ),
        InventoryInsertIndividualProductSwitch(
          isIndividual: widget.isIndividual,
          isLoading: inventoryProvider.isLoadingProducts ||
              inventoryProvider.isLoadingQuantity,
          changeFocus: () {
            inventoryProvider.alterFocusToConsultProduct(
              context: context,
            );
          },
          changeValue: () {
            setState(() {
              widget.changeIsIndividual();
            });
          },
        ),
      ],
    );
  }
}

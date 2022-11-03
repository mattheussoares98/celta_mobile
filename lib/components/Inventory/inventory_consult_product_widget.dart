import 'package:celta_inventario/utils/scan_bar_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Models/countings_model.dart';
import '../../providers/inventory_product_provider.dart';

class ConsultProductWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool isIndividual;
  final FocusNode consultProductFocusNode;
  // final Function() consultAndAddProduct;
  final TextEditingController consultProductController;
  final TextEditingController consultedProductController;
  const ConsultProductWidget({
    Key? key,
    required this.formKey,
    required this.isIndividual,
    required this.consultProductFocusNode,
    required this.consultedProductController,
    // required this.consultAndAddProduct,
    required this.consultProductController,
  }) : super(key: key);

  @override
  State<ConsultProductWidget> createState() => _ConsultProductWidgetState();
}

class _ConsultProductWidgetState extends State<ConsultProductWidget> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    InventoryProductProvider inventoryProductProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Form(
                key: widget.formKey,
                child: TextFormField(
                  onFieldSubmitted: (value) async {
                    await inventoryProductProvider
                        .getProductsAndAddIfIsIndividual(
                      controllerText: widget.consultProductController.text,
                      enterpriseCode: arguments["codigoInternoEmpresa"],
                      inventoryProcessCode: arguments["InventoryCountingsModel"]
                          .codigoInternoInventario,
                      codigoInternoInvCont: arguments["InventoryCountingsModel"]
                          .codigoInternoInvCont,
                      context: context,
                      consultProductFocusNode: widget.consultProductFocusNode,
                      isIndividual: widget.isIndividual,
                      inventoryProductProvider: inventoryProductProvider,
                    );
                    widget.consultProductController.clear();
                    widget.consultedProductController.clear();
                  },
                  focusNode: widget.consultProductFocusNode,
                  enabled: inventoryProductProvider.isLoading ||
                          inventoryProductProvider.isLoadingQuantity
                      ? false
                      : true,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  inputFormatters: [LengthLimitingTextInputFormatter(14)],
                  controller: widget.consultProductController,
                  onChanged: (value) => setState(() {}),
                  validator: (value) {
                    if (value!.contains(',') ||
                        value.contains('.') ||
                        value.contains('-')) {
                      return 'Escreva somente números ou somente letras';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Digite o EAN ou o PLU',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
            IconButton(
              onPressed: inventoryProductProvider.isLoading ||
                      inventoryProductProvider.isLoadingQuantity
                  ? null
                  : () {
                      widget.consultProductController.clear();

                      inventoryProductProvider.alterFocusToConsultProduct(
                        context: context,
                        consultProductFocusNode: widget.consultProductFocusNode,
                      );
                    },
              icon: Icon(
                Icons.delete,
                color: inventoryProductProvider.isLoading ||
                        inventoryProductProvider.isLoadingQuantity
                    ? null
                    : Colors.red,
                size: 40,
              ),
            ),
          ],
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
                        widget.consultedProductController.clear();

                        if (widget.consultProductController.text.isEmpty) {
                          //se não digitar o ean ou plu, vai abrir a câmera
                          widget.consultProductController.text =
                              await ScanBarCode.scanBarcode();
                        }

                        //se ler algum código, vai consultar o produto
                        if (widget.consultProductController.text.isNotEmpty) {
                          await inventoryProductProvider
                              .getProductsAndAddIfIsIndividual(
                            controllerText:
                                widget.consultProductController.text,
                            enterpriseCode: arguments["codigoInternoEmpresa"],
                            inventoryProcessCode:
                                arguments["InventoryCountingsModel"]
                                    .codigoInternoInventario,
                            codigoInternoInvCont:
                                arguments["InventoryCountingsModel"]
                                    .codigoInternoInvCont,
                            context: context,
                            consultProductFocusNode:
                                widget.consultProductFocusNode,
                            isIndividual: widget.isIndividual,
                            inventoryProductProvider: inventoryProductProvider,
                          );
                        }

                        if (inventoryProductProvider.products.isNotEmpty &&
                            widget.isIndividual) {
                          widget.consultProductController.clear();

                          inventoryProductProvider.alterFocusToConsultProduct(
                            context: context,
                            consultProductFocusNode:
                                widget.consultProductFocusNode,
                          );
                        }
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

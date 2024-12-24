import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'insert_update_components.dart';

class Products extends StatefulWidget {
  final EnterpriseModel enterprise;
  const Products({
    required this.enterprise,
    super.key,
  });

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int? selectedProductIndex;
  List<TextEditingController> controllers = [];
  final searchProductController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        BuyQuotationProvider buyQuotationProvider =
            Provider.of(context, listen: false);

        createControllers(buyQuotationProvider);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
    searchProductController.dispose();
    searchFocusNode.dispose();
  }

  void createControllers(BuyQuotationProvider buyQuotationProvider) {
    if (buyQuotationProvider.selectedEnterprises.isEmpty) {
      return;
    } else {
      controllers = buyQuotationProvider.selectedEnterprises
          .map((e) => TextEditingController())
          .toList();
    }
  }

  void disposeControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  void updateSelectedIndex({
    required int productIndex,
    required BuyQuotationProvider buyQuotationProvider,
  }) {
    if (selectedProductIndex == productIndex) {
      setState(() {
        selectedProductIndex = null;
      });
    } else {
      setState(() {
        selectedProductIndex = productIndex;
        updateControllersQuantity(
          productIndex: productIndex,
          buyQuotationProvider: buyQuotationProvider,
        );
      });
    }
  }

  void updateControllersQuantity({
    required int productIndex,
    required BuyQuotationProvider buyQuotationProvider,
  }) {
    if (buyQuotationProvider
            .productsWithNewValues[productIndex].ProductEnterprises ==
        null) {
      return;
    }

    for (var x = 0; x < buyQuotationProvider.selectedEnterprises.length; x++) {
      //a quantidade de controllers é criado de acordo com a quantidade de empresas selecionadas
      final enterprise = buyQuotationProvider.selectedEnterprises[x];

      final productQuantity = buyQuotationProvider
          .productsWithNewValues[productIndex].ProductEnterprises!
          .where((e) => e.EnterpriseCode == enterprise.Code)
          .first
          .Quantity;

      if (productQuantity != null) {
        controllers[x].text = productQuantity
            .toString()
            .toBrazilianNumber(3)
            .replaceAll(RegExp(r'\.'), '');
      } else {
        controllers[x].text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Produtos"),
        SearchWidget(
          configurations: [
            ConfigurationType.legacyCode,
            ConfigurationType.personalizedCode,
          ],
          labelText: "Adicionar produto",
          searchProductController: searchProductController,
          onPressSearch: () async {
            await buyQuotationProvider.searchProductsToAdd(
              enterprise: widget.enterprise,
              searchProductController: searchProductController,
              configurationsProvider: configurationsProvider,
              context: context,
            );

            if (buyQuotationProvider.searchedProductsToAdd.length > 1 &&
                buyQuotationProvider.productToAdd == null) {
              ShowAlertDialog.show(
                context: context,
                title: "Selecione um produto",
                contentPadding: const EdgeInsets.all(3),
                insetPadding: const EdgeInsets.all(3),
                showConfirmAndCancelMessage: false,
                canCloseClickingOut: false,
                showCloseAlertDialogButton: true,
                content: Scaffold(
                  body: ListView.builder(
                    itemCount:
                        buyQuotationProvider.searchedProductsToAdd.length,
                    itemBuilder: (context, index) {
                      final product =
                          buyQuotationProvider.searchedProductsToAdd[index];

                      return InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await buyQuotationProvider
                              .getEnterprisesCodesByAProduct(
                            plu: product.plu!,
                            enterprise: widget.enterprise,
                            configurationsProvider: configurationsProvider,
                          );
                        },
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TitleAndSubtitle.titleAndSubtitle(
                                subtitle:
                                    "${product.name} (${product.packingQuantity})",
                              ),
                              TitleAndSubtitle.titleAndSubtitle(
                                title: "PLU",
                                subtitle: product.plu,
                              ),
                            ],
                          ),
                        )),
                      );
                    },
                  ),
                ),
                function: () async {},
              );
            }
          },
          searchFocusNode: searchFocusNode,
        ),
        if (buyQuotationProvider.productsWithNewValues.length == 0)
          const Text("Não há produtos na cotação"),
        ListView.builder(
          shrinkWrap: true,
          itemCount: buyQuotationProvider.productsWithNewValues.length,
          itemBuilder: (context, productIndex) {
            final product =
                buyQuotationProvider.productsWithNewValues[productIndex];

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: productIndex % 2 == 0
                    ? Theme.of(context).primaryColor.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        updateSelectedIndex(
                          productIndex: productIndex,
                          buyQuotationProvider: buyQuotationProvider,
                        );
                      },
                      child: Column(
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            subtitle: product.Product!.Name.toString(),
                            otherWidget: IconButton(
                              onPressed: () {
                                ShowAlertDialog.show(
                                  context: context,
                                  title: "Remover produto?",
                                  function: () async {},
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "PLU",
                            subtitle: product.Product!.PLU,
                            otherWidget: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: TextButton.icon(
                                onPressed: () {
                                  updateSelectedIndex(
                                    productIndex: productIndex,
                                    buyQuotationProvider: buyQuotationProvider,
                                  );
                                },
                                label: const Text("Qtd"),
                                iconAlignment: IconAlignment.end,
                                icon: Icon(
                                  selectedProductIndex == productIndex
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selectedProductIndex == productIndex)
                      UpdateQuantity(
                        controllers: controllers,
                        updateSelectedIndex: () {
                          updateSelectedIndex(
                            productIndex: productIndex,
                            buyQuotationProvider: buyQuotationProvider,
                          );
                        },
                        productIndex: productIndex,
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

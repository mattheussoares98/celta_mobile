import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int? selectedIndex;
  List<TextEditingController> controllers = [];

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
    if (selectedIndex == productIndex) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = productIndex;
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
            .selectedsProducts[productIndex].ProductEnterprises ==
        null) {
      return;
    }

    for (var x = 0; x < buyQuotationProvider.selectedEnterprises.length; x++) {
      //a quantidade de controllers é criado de acordo com a quantidade de empresas selecionadas
      final enterprise = buyQuotationProvider.selectedEnterprises[x];

      final productQuantity = buyQuotationProvider
          .selectedsProducts[productIndex].ProductEnterprises!
          .where((e) => e.EnterpriseCode == enterprise.Code)
          .first
          .Quantity;

      if (productQuantity != null) {
        controllers[x].text = productQuantity.toString().toBrazilianNumber(3);
      } else {
        controllers[x].text = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Produtos"),
        if (buyQuotationProvider.selectedsProducts.length == 0)
          const Text("Não há produtos na cotação"),
        ListView.builder(
          shrinkWrap: true,
          itemCount: buyQuotationProvider.selectedsProducts.length,
          itemBuilder: (context, index) {
            final product = buyQuotationProvider.selectedsProducts[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: index % 2 == 0
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
                          productIndex: index,
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
                                    productIndex: index,
                                    buyQuotationProvider: buyQuotationProvider,
                                  );
                                },
                                label: const Text("Qtd"),
                                iconAlignment: IconAlignment.end,
                                icon: Icon(
                                  selectedIndex == index
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
                    if (selectedIndex == index)
                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                buyQuotationProvider.selectedEnterprises.length,
                            itemBuilder: (context, index) {
                              final enterprise = buyQuotationProvider
                                  .selectedEnterprises[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TextFormField(
                                  controller: controllers[index],
                                  style: const TextStyle(fontSize: 14),
                                  decoration: FormFieldDecoration.decoration(
                                    context: context,
                                    labelText: "Qtd ${enterprise.Name}",
                                  ),
                                ),
                              );
                            },
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            label: const Text("Confirmar qtd"),
                            icon: const Icon(Icons.verified_rounded),
                          ),
                        ],
                      ),
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

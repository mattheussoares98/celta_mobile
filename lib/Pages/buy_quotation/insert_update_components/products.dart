import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  int? selectedIndex;

  void updateSelectedIndex(int index) {
    if (selectedIndex == index) {
      setState(() {
        selectedIndex = null;
      });
    } else {
      setState(() {
        selectedIndex = index;
      });
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
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Theme.of(context).primaryColor.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.2),
              ),
              child: InkWell(
                onTap: () {
                  updateSelectedIndex(index);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              updateSelectedIndex(index);
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
                      if (selectedIndex == index)
                        TextFormField(
                          style: const TextStyle(fontSize: 14),
                          decoration:
                              FormFieldDecoration.decoration(context: context),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

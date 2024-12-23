import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Produtos"),
        ListView.builder(
          shrinkWrap: true,
          itemCount:
              buyQuotationProvider.completeBuyQuotation!.Products?.length,
          itemBuilder: (context, index) {
            final product =
                buyQuotationProvider.completeBuyQuotation!.Products?[index];

            if (product == null) {
              return const Text("Não há produtos na cotação");
            }

            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Theme.of(context).primaryColor.withAlpha(30)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.Product!.Name.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "PLU",
                    subtitle: product.Product!.PLU,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

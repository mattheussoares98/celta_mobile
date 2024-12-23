import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class Enterprises extends StatelessWidget {
  const Enterprises({super.key});

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Empresas"),
        ListView.builder(
          shrinkWrap: true,
          itemCount:
              buyQuotationProvider.completeBuyQuotation!.Enterprises!.length,
          itemBuilder: (context, index) {
            final enterprise =
                buyQuotationProvider.completeBuyQuotation!.Enterprises![index];

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
                    enterprise.enterprise.Name.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "CNPJ",
                    subtitle: enterprise.enterprise.CnpjNumber,
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

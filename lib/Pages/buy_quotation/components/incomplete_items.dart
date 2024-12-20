import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class IncompleteItems extends StatelessWidget {
  const IncompleteItems({super.key});

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: buyQuotationProvider.incompletesBuyQuotations.length,
      itemBuilder: (context, index) {
        final buyQuotation =
            buyQuotationProvider.incompletesBuyQuotations[index];

        return InkWell(
          onTap: () {},
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Code",
                    subtitle: buyQuotation.Code.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de criação",
                    subtitle: buyQuotation.DateOfCreation,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de limite",
                    subtitle: buyQuotation.DateOfLimit,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Código personalizado",
                    subtitle: buyQuotation.PersonalizedCode,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: buyQuotation.Observations?.isEmpty == true
                        ? null
                        : buyQuotation.Observations,
                    subtitle: buyQuotation.Observations?.isEmpty == true
                        ? "Sem observações"
                        : buyQuotation.Observations,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

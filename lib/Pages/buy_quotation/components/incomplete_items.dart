import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';

class IncompleteItems extends StatelessWidget {
  final EnterpriseModel enterprise;
  const IncompleteItems({
    required this.enterprise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    if (buyQuotationProvider.incompletesBuyQuotations.length == 0) {
      return TextButton.icon(
        onPressed: () async {
          await buyQuotationProvider.getBuyQuotation(
            context: context,
            valueToSearch: "%",
            searchByPersonalizedCode: true,
            enterpriseCode: enterprise.Code,
          );
        },
        label: const Text(
          "Consultar todas cotações",
        ),
        icon: const Icon(Icons.replay),
      );
    }

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

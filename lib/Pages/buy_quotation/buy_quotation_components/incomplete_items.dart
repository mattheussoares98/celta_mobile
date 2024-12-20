import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

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
        final incompleteQuotation =
            buyQuotationProvider.incompletesBuyQuotations[index];

        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              APPROUTES.BUY_QUOTATION_INSERT_UPDATE,
              arguments: incompleteQuotation,
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Code",
                    subtitle: incompleteQuotation.Code.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de criação",
                    subtitle: incompleteQuotation.DateOfCreation,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de limite",
                    subtitle: incompleteQuotation.DateOfLimit,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Código personalizado",
                    subtitle: incompleteQuotation.PersonalizedCode,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: incompleteQuotation.Observations?.isEmpty == true
                        ? null
                        : incompleteQuotation.Observations,
                    subtitle: incompleteQuotation.Observations?.isEmpty == true
                        ? "Sem observações"
                        : incompleteQuotation.Observations,
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

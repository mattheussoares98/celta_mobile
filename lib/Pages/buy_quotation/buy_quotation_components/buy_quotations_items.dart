import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class BuyQuotationsItems extends StatelessWidget {
  final EnterpriseModel enterprise;
  const BuyQuotationsItems({
    required this.enterprise,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    if (buyQuotationProvider.buyQuotations.length == 0) {
      return TextButton.icon(
        onPressed: () async {
          await buyQuotationProvider.getBuyQuotation(
            context: context,
            valueToSearch: "%",
            searchByPersonalizedCode: true,
            enterpriseCode: enterprise.Code,
            searchAll: true,
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
      itemCount: buyQuotationProvider.buyQuotations.length,
      itemBuilder: (context, index) {
        final buyQuotation = buyQuotationProvider.buyQuotations[index];

        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              APPROUTES.BUY_QUOTATION_INSERT_UPDATE,
              arguments: {
                "enterprise": enterprise,
              },
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Code",
                    subtitle: buyQuotation?.Code.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de criação",
                    subtitle: buyQuotation?.DateOfCreation,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Data de limite",
                    subtitle: buyQuotation?.DateOfLimit,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Código personalizado",
                    subtitle: buyQuotation?.PersonalizedCode,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: buyQuotation?.Observations?.isEmpty == true
                        ? null
                        : buyQuotation?.Observations,
                    subtitle: buyQuotation?.Observations?.isEmpty == true
                        ? "Sem observações"
                        : buyQuotation?.Observations,
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

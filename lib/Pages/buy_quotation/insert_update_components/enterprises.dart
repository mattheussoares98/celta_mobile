import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class Enterprises extends StatelessWidget {
  const Enterprises({super.key});

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);
    EnterpriseProvider enterpriseProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Empresas"),
        ListView.builder(
          shrinkWrap: true,
          itemCount:
              buyQuotationProvider.completeBuyQuotation?.Enterprises?.length,
          itemBuilder: (context, index) {
            final buyQuotationEnterprise =
                buyQuotationProvider.completeBuyQuotation?.Enterprises?[index];

            final enterprise = enterpriseProvider.enterprises.firstWhere((e) =>
                e.CnpjNumber.toString() ==
                buyQuotationEnterprise?.enterprise.CnpjNumber);

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: index % 2 == 0
                    ? Theme.of(context).primaryColor.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.2),
              ),
              child: InkWell(
                onTap: () {
                  buyQuotationProvider
                      .addOrRemoveSelectedEnterprise(enterprise);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Código",
                              subtitle: enterprise.Code.toString(),
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              subtitle: enterprise.Name.toString(),
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "CNPJ",
                              subtitle: enterprise.CnpjNumber.toString(),
                            ),
                          ],
                        ),
                      ),
                      Checkbox(
                        value: buyQuotationProvider.selectedEnterprises
                            .contains(enterprise),
                        onChanged: (value) {
                          buyQuotationProvider
                              .addOrRemoveSelectedEnterprise(enterprise);
                        },
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
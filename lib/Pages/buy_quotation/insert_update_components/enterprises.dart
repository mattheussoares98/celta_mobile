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
          physics: const NeverScrollableScrollPhysics(),
          itemCount: buyQuotationProvider.allEnterprises.length,
          itemBuilder: (context, index) {
            final enterprise = buyQuotationProvider.allEnterprises[index];

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
                  buyQuotationProvider.updateEnterpriseIsSelected(enterprise);
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
                              subtitle: enterprise.PersonalizedCode.toString(),
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
                        value: enterprise.isSelected,
                        onChanged: (value) {
                          buyQuotationProvider
                              .updateEnterpriseIsSelected(enterprise);
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

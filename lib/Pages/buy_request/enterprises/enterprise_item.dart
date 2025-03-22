import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../Models/models.dart';
import '../../../providers/providers.dart';

class EnterpriseItem extends StatelessWidget {
  final BuyRequestEnterpriseModel enterpriseModel;
  final bool enableCheckBox;
  const EnterpriseItem({
    required this.enterpriseModel,
    required this.enableCheckBox,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);

    return Card(
      child: CheckboxListTile(
        enabled: enableCheckBox,
        value: enterpriseModel.selected,
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        onChanged: (bool? value) {
          buyRequestProvider.updateSelectedEnterprise(
            context: context,
            enterprise: enterpriseModel,
          );
        },
        subtitle: Column(
          children: [
            TitleAndSubtitle.titleAndSubtitle(
              title: "Código",
              subtitle: enterpriseModel.PersonalizedCode.toString(),
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Nome",
              subtitle: enterpriseModel.Name,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Nome fantasia",
              subtitle: enterpriseModel.FantasizesName,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "CPF/CNPJ",
              subtitle: enterpriseModel.CnpjNumber,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/global_widgets/global_widgets.dart';
import '../../../models/buy_request/buy_request.dart';

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
              value: enterpriseModel.PersonalizedCode.toString(),
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Nome",
              value: enterpriseModel.Name,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "Nome fantasia",
              value: enterpriseModel.FantasizesName,
            ),
            TitleAndSubtitle.titleAndSubtitle(
              title: "CPF/CNPJ",
              value: enterpriseModel.CnpjNumber,
            ),
          ],
        ),
      ),
    );
  }
}

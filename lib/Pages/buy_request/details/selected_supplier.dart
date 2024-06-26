import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/global_widgets/global_widgets.dart';

class SelectedSupplier extends StatelessWidget {
  const SelectedSupplier({super.key});

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            buyRequestProvider.selectedBuyer == null
                ? "Selecione o comprador"
                : "Comprador",
            style: TextStyle(
              color: buyRequestProvider.selectedBuyer == null
                  ? Colors.red
                  : Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        if (buyRequestProvider.selectedSupplier != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Código",
                    value: buyRequestProvider.selectedSupplier!.Code.toString(),
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome",
                    value: buyRequestProvider.selectedSupplier!.Name,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Nome fantasia",
                    value: buyRequestProvider.selectedSupplier!.FantasizesName,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "CPF/CNPJ",
                    value: buyRequestProvider.selectedSupplier!.CnpjCpfNumber,
                  ),
                  TitleAndSubtitle.titleAndSubtitle(
                    title: "Tipo de comércio",
                    value: buyRequestProvider.selectedSupplier!.SupplierType,
                  ),
                  if (buyRequestProvider.selectedSupplier!.Addresses != null)
                    Text(buyRequestProvider.selectedSupplier!.Addresses
                        .toString()),
                  if (buyRequestProvider.selectedSupplier!.Telephones != null)
                    Text(buyRequestProvider.selectedSupplier!.Telephones
                        .toString()),
                  if (buyRequestProvider.selectedSupplier!.Emails != null)
                    Text(
                        buyRequestProvider.selectedSupplier!.Emails.toString()),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

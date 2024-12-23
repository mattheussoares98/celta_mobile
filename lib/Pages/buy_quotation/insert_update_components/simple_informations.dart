import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';

class SimpleInformations extends StatelessWidget {
  final TextEditingController observationsController;
  final void Function() updateShowEditObservationFormField;
  final String? newObservation;
  final bool showEditObservationFormField;
  final FocusNode observationsFocusNode;
  final void Function() updateObservation;

  const SimpleInformations({
    required this.observationsController,
    required this.updateShowEditObservationFormField,
    required this.newObservation,
    required this.showEditObservationFormField,
    required this.observationsFocusNode,
    required this.updateObservation,
    super.key,
  });

  String getObservationsValue(BuyQuotationProvider buyQuotationProvider) {
    if (buyQuotationProvider.completeBuyQuotation!.Observations?.isEmpty ==
            true &&
        newObservation == null) {
      return "Sem observações";
    } else if (newObservation != null) {
      return newObservation!;
    } else {
      return buyQuotationProvider.completeBuyQuotation!.Observations.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      children: [
        TitleAndSubtitle.titleAndSubtitle(
          title: "Código",
          subtitle: buyQuotationProvider.completeBuyQuotation!.Code.toString(),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Data de criação",
          subtitle: buyQuotationProvider.completeBuyQuotation!.DateOfCreation
              .toString(),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Data limite",
          subtitle:
              buyQuotationProvider.completeBuyQuotation!.DateOfLimit.toString(),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Comprador",
          subtitle: buyQuotationProvider.completeBuyQuotation!.Buyer.Name,
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: buyQuotationProvider
                          .completeBuyQuotation!.Observations?.isEmpty ==
                      true &&
                  observationsController.text.isEmpty
              ? null
              : "Observações",
          subtitle: buyQuotationProvider
                          .completeBuyQuotation!.Observations?.isEmpty ==
                      true &&
                  observationsController.text.isEmpty
              ? "Sem observações"
              : getObservationsValue(buyQuotationProvider),
          otherWidget: TextButton.icon(
            onPressed: updateShowEditObservationFormField,
            icon: const Icon(Icons.edit),
            label: const Text("Alterar"),
          ),
        ),
        if (showEditObservationFormField)
          Column(
            children: [
              TextFormField(
                maxLines: 10,
                minLines: 1,
                focusNode: observationsFocusNode,
                style: const TextStyle(fontSize: 14),
                onFieldSubmitted: (_) {
                  updateObservation();
                },
                controller: observationsController,
                decoration: FormFieldDecoration.decoration(
                  context: context,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: updateObservation,
                  child: const Text("Alterar comentário"),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

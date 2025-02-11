import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import 'insert_update_components.dart';

class SimpleInformations extends StatefulWidget {
  final TextEditingController observationsController;
  final FocusNode observationsFocusNode;
  final bool isInserting;

  const SimpleInformations({
    required this.observationsController,
    required this.observationsFocusNode,
    required this.isInserting,
    super.key,
  });

  @override
  State<SimpleInformations> createState() => _SimpleInformationsState();
}

class _SimpleInformationsState extends State<SimpleInformations> {
  bool showEditObservationFormFields = false;

  String getObservationsValue(BuyQuotationProvider buyQuotationProvider) {
    if ((buyQuotationProvider.selectedBuyQuotation?.Observations == null ||
            buyQuotationProvider.selectedBuyQuotation?.Observations?.isEmpty ==
                true) &&
        widget.observationsController.text.isEmpty) {
      return "Sem observações";
    } else if (widget.observationsController.text.isNotEmpty) {
      return widget.observationsController.text;
    } else {
      return buyQuotationProvider.selectedBuyQuotation!.Observations.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyQuotationProvider buyQuotationProvider = Provider.of(context);

    return Column(
      children: [
        if (!widget.isInserting)
          TitleAndSubtitle.titleAndSubtitle(
            title: "Código",
            subtitle:
                buyQuotationProvider.selectedBuyQuotation?.Code.toString(),
          ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Comprador",
          subtitle: buyQuotationProvider.selectedBuyer?.Name,
          otherWidget: PopupMenuButton(
            tooltip: "Alterar comprador",
            child: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
            itemBuilder: (_) {
              return buyQuotationProvider.buyers
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e.Name),
                      onTap: () => buyQuotationProvider.updateSelectedBuyer(e),
                    ),
                  )
                  .toList();
            },
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Data de criação",
          subtitle: dateFormatted(
              buyQuotationProvider.selectedBuyQuotation?.DateOfCreation),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: dateFormatted(
                      buyQuotationProvider.selectedBuyQuotation?.DateOfLimit) ==
                  null
              ? null
              : "Data limite",
          subtitle: dateFormatted(
                      buyQuotationProvider.selectedBuyQuotation?.DateOfLimit) ==
                  null
              ? "Sem data de limite"
              : dateFormatted(
                  buyQuotationProvider.selectedBuyQuotation?.DateOfLimit),
          otherWidget: InkWell(
            onTap: () async {
              final newDate = await GetNewDate.get(
                context: context,
              );

              if (newDate != null) {
                buyQuotationProvider.updateDateOfLimit(newDate);
              }
            },
            child: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: buyQuotationProvider
                          .selectedBuyQuotation?.Observations?.isEmpty ==
                      true &&
                  widget.observationsController.text.isEmpty
              ? null
              : "Observações",
          subtitle: buyQuotationProvider
                          .selectedBuyQuotation?.Observations?.isEmpty ==
                      true &&
                  widget.observationsController.text.isEmpty
              ? "Sem observações"
              : getObservationsValue(buyQuotationProvider),
          otherWidget: TextButton.icon(
            onPressed: () {
              setState(() {
                showEditObservationFormFields = !showEditObservationFormFields;
              });
              widget.observationsFocusNode.requestFocus();
            },
            icon: const Icon(Icons.edit),
            label: const Text("Alterar"),
          ),
        ),
        if (showEditObservationFormFields)
          Column(
            children: [
              TextFormField(
                maxLines: 10,
                minLines: 1,
                focusNode: widget.observationsFocusNode,
                style: const TextStyle(fontSize: 14),
                onFieldSubmitted: (_) {},
                controller: widget.observationsController,
                decoration: FormFieldDecoration.decoration(
                  context: context,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showEditObservationFormFields = false;
                    });
                  },
                  child: const Text("Confirmar observação"),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';

class SimpleInformations extends StatefulWidget {
  final TextEditingController observationsController;
  final FocusNode observationsFocusNode;
  final bool isInserting;
  final DateTime? dateOfLimit;
  final void Function(DateTime date) updateDateOfLimit;
  final BuyerModel? buyer;
  final void Function(BuyerModel buyer) updateBuyer;

  const SimpleInformations({
    required this.observationsController,
    required this.observationsFocusNode,
    required this.isInserting,
    required this.dateOfLimit,
    required this.updateDateOfLimit,
    required this.buyer,
    required this.updateBuyer,
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
          subtitle: widget.buyer?.Name,
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
                      onTap: () => widget.updateBuyer(e),
                    ),
                  )
                  .toList();
            },
          ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Data de criação",
          subtitle: buyQuotationProvider.selectedBuyQuotation?.DateOfCreation
              .toString(),
          // otherWidget: InkWell(
          //   onTap: () async {
          //     final newDate = await GetNewDate.get(
          //       context: context,
          //     );

          //     if (newDate != null) {
          //       buyQuotationProvider.updateDates(dateOfCreation: newDate);
          //     }
          //   },
          //   child: Icon(
          //     Icons.edit,
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
        ),
        TitleAndSubtitle.titleAndSubtitle(
          title: "Data limite",
          subtitle: widget.dateOfLimit?.toIso8601String(),
          otherWidget: InkWell(
            onTap: () async {
              final newDate = await GetNewDate.get(
                context: context,
              );

              if (newDate != null) {
                widget.updateDateOfLimit(newDate);
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
                  child: const Text("Confirmar"),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

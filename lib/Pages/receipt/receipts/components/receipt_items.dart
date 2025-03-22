import 'package:flutter/material.dart';


import '../../../../Models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../components/components.dart';
import 'components.dart';

class ReceiptItems extends StatefulWidget {
  final ReceiptProvider receiptProvider;
  final EnterpriseModel enterprise;
  final TextEditingController observationsController;
  const ReceiptItems({
    required this.receiptProvider,
    required this.enterprise,
    required this.observationsController,
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptItems> createState() => _ReceiptItemsState();
}

class _ReceiptItemsState extends State<ReceiptItems> {
  int selectedIndex = -1;
  int selectedChangeObservationsIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.receiptProvider.receiptCount,
            itemBuilder: (context, index) {
              ReceiptModel receipt = widget.receiptProvider.receipts[index];
              return GestureDetector(
                onTap: () {
                  selectedChangeObservationsIndex = -1;
                  if (selectedIndex == index) {
                    setState(() {
                      selectedIndex = -1;
                    });
                  } else {
                    setState(() {
                      selectedIndex = index;
                      //isso faz com que apareça os botões de "conferir" e "liberar" somente no item selecionado
                    });
                  }
                },
                //sem esse Card, não funciona o gesture detector no campo inteiro
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Número do recebimento",
                          subtitle: receipt.Numero_ProcRecebDoc,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: receipt.EmitterName == "" ? null : "Emitente",
                          subtitle: receipt.EmitterName == ""
                              ? "Sem emitente"
                              : receipt.EmitterName,
                        ),
                        if (receipt.Grupo != "-1")
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Grupo",
                            subtitle: receipt.Grupo,
                            subtitleColor: Colors.amber,
                          ),
                        Observations(
                          receipt: receipt,
                          observationsController: widget.observationsController,
                          enterprise: widget.enterprise,
                          showObservationsField:
                              selectedChangeObservationsIndex == index,
                          updateShowObservationsField: () {
                            setState(() {
                              if (selectedChangeObservationsIndex == index) {
                                selectedChangeObservationsIndex = -1;
                              } else {
                                selectedChangeObservationsIndex = index;
                              }
                            });
                          },
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Status",
                          subtitle: receipt.Status.toString(),
                          subtitleColor: receipt.StatusColor,
                          otherWidget: Icon(
                            selectedIndex != index
                                ? Icons.arrow_drop_down_sharp
                                : Icons.arrow_drop_up_sharp,
                            color: Theme.of(context).colorScheme.primary,
                            size: 30,
                          ),
                        ),
                        if (selectedIndex == index)
                          LiberateCheckButtons(
                            receipt: receipt,
                            index: index,
                            enterprise: widget.enterprise,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

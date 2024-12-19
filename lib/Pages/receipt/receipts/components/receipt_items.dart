import 'package:flutter/material.dart';

import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/receipt/receipt.dart';
import '../../../../providers/providers.dart';
import '../../../../components/components.dart';
import 'components.dart';

class ReceiptItems extends StatefulWidget {
  final ReceiptProvider receiptProvider;
  final EnterpriseModel enterprise;
  const ReceiptItems({
    required this.receiptProvider,
    required this.enterprise,
    Key? key,
  }) : super(key: key);

  @override
  State<ReceiptItems> createState() => _ReceiptItemsState();
}

class _ReceiptItemsState extends State<ReceiptItems> {
  int selectedIndex = -1;

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
                  if (widget.receiptProvider.isLoadingLiberateCheck) {
                    //não permite mudar o recebimento enquanto está carregando uma liberação
                    return;
                  }
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
                        TitleAndSubtitle.titleAndSubtitle(
                          title: receipt.Observacoes_ProcRecebDoc != null
                              ? "Observações"
                              : null,
                          subtitle: receipt.Observacoes_ProcRecebDoc != null
                              ? receipt.Observacoes_ProcRecebDoc.toString()
                              : "Sem observações",
                          otherWidget: TextButton(
                            onPressed: () async {},
                            child: const Text("Alterar"),
                          ),
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

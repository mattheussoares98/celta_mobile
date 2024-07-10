import 'package:flutter/material.dart';

import '../../../models/receipt/receipt.dart';
import '../../../providers/providers.dart';
import '../../../components/components.dart';
import 'components.dart';

class ReceiptItems extends StatefulWidget {
  final ReceiptProvider receiptProvider;
  final int enterpriseCode;
  const ReceiptItems({
    required this.receiptProvider,
    required this.enterpriseCode,
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
              return InkWell(
                focusColor: Colors.white.withOpacity(0),
                hoverColor: Colors.white.withOpacity(0),
                splashColor: Colors.white.withOpacity(0),
                highlightColor: Colors.white.withOpacity(0),
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
                          title: "Emitente",
                          subtitle: receipt.EmitterName == ""
                              ? "Não há"
                              : receipt.EmitterName,
                        ),
                        if (receipt.Grupo != "-1")
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Grupo",
                            subtitle: receipt.Grupo,
                            subtitleColor: Colors.amber,
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
                            grDocCode: receipt.CodigoInterno_ProcRecebDoc,
                            emitterName: receipt.EmitterName,
                            numeroProcRecebDoc: receipt.Numero_ProcRecebDoc,
                            receiptProvider: widget.receiptProvider,
                            index: index,
                            enterpriseCode: widget.enterpriseCode,
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

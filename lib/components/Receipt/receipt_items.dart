import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/Components/Receipt/receipt_liberate_check_buttons.dart';
import 'package:celta_inventario/providers/receipt_provider.dart';
import 'package:flutter/material.dart';

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
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: FittedBox(
            child: Text(
              'Selecione o recebimento',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.receiptProvider.receiptCount,
            itemBuilder: (context, index) {
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
                child: PersonalizedCard.personalizedCard(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Número do recebimento",
                          value: widget.receiptProvider.receipts[index]
                              .Numero_ProcRecebDoc,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Emitente",
                          value: widget
                              .receiptProvider.receipts[index].EmitterName,
                        ),
                        TitleAndSubtitle.titleAndSubtitle(
                          title: "Status",
                          value: widget.receiptProvider.receipts[index].Status
                              .toString(),
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
                            grDocCode: widget.receiptProvider.receipts[index]
                                .CodigoInterno_ProcRecebDoc,
                            emitterName: widget
                                .receiptProvider.receipts[index].EmitterName,
                            numeroProcRecebDoc: widget.receiptProvider
                                .receipts[index].Numero_ProcRecebDoc,
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

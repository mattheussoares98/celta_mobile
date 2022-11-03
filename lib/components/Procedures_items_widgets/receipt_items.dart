import 'package:celta_inventario/components/personalized_card.dart';
import 'package:celta_inventario/Components/Buttons/receipt_liberate_check_buttons.dart';
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
    TextStyle _fontStyle = const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'OpenSans',
    );
    TextStyle _fontBoldStyle = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'Selecione o recebimento',
            style: Theme.of(context).textTheme.headline6,
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
                  setState(() {
                    selectedIndex = index;
                    //isso faz com que apareça os botões de "conferir" e "liberar" somente no item selecionado
                  });
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
                        Row(
                          children: [
                            Text(
                              'Número do recebimento: ',
                              style: _fontStyle,
                            ),
                            const SizedBox(height: 25),
                            Expanded(
                              child: Text(
                                widget.receiptProvider.receipts[index]
                                    .Numero_ProcRecebDoc,
                                style: _fontBoldStyle,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          child: Row(
                            children: [
                              Text(
                                'Emitente: ',
                                style: _fontStyle,
                              ),
                              Text(
                                widget.receiptProvider.receipts[index]
                                    .EmitterName,
                                style: _fontBoldStyle,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        FittedBox(
                          child: Row(
                            children: [
                              Text(
                                'Status: ',
                                style: _fontStyle,
                              ),
                              Text(
                                widget.receiptProvider.receipts[index].Status
                                    .toString(),
                                style: _fontBoldStyle,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
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

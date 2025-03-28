import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/transfer_request/transfer_request.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import '../../../components/components.dart';

class TransferRequestItems extends StatefulWidget {
  // final ReceiptProvider receiptProvider;
  // final int enterpriseCode;
  const TransferRequestItems({
    // required this.receiptProvider,
    // required this.enterpriseCode,
    Key? key,
  }) : super(key: key);

  @override
  State<TransferRequestItems> createState() => _TransferRequestItemsState();
}

class _TransferRequestItemsState extends State<TransferRequestItems> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider =
        Provider.of(context, listen: true);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: transferRequestProvider.requestModels.length,
              itemBuilder: (context, index) {
                TransferRequestModel transfer =
                    transferRequestProvider.requestModels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.TRANSFER_ORIGIN_ENTERPRISE,
                      arguments: transfer,
                    );
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
                            title: "Nome",
                            subtitle: transfer.Name,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Código personalizado",
                            subtitle: transfer.PersonalizedCode,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Número do pedido",
                            subtitle: transfer.Code.toString(),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Tipo de operação",
                            subtitle: transfer.OperationTypeString,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Utiliza preço de atacado",
                            subtitle: transfer.UseWholePriceString,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Preço praticado",
                            subtitle: transfer.UnitValueTypeString,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            subtitle: transfer.AllowAlterCostOrSalePrice == true
                                ? "Pode alterar preço de custo ou venda"
                                : "Não pode alterar preço de custo ou venda",
                            subtitleColor:
                                transfer.AllowAlterCostOrSalePrice == true
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.red,
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
      ),
    );
  }
}

import 'package:celta_inventario/Components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/Models/transfer_request/transfer_request_model.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/transfer_request_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Selecione o modelo de pedido',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transferRequestProvider.requestModelsCount,
              itemBuilder: (context, index) {
                TransferRequestModel transfer =
                    transferRequestProvider.requestModels[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      APPROUTES.TRANSFER_ORIGIN_ENTERPRISE,
                      arguments: transfer.Code,
                    );
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
                            title: "Nome",
                            value: transfer.Name,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Código personalizado",
                            value: transfer.PersonalizedCode,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Número do pedido",
                            value: transfer.Code.toString(),
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Tipo de operação",
                            value: transfer.OperationTypeString,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Utiliza preço de atacado",
                            value: transfer.UseWholePriceString,
                          ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Preço praticado",
                            value: transfer.UnitValueTypeString,
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
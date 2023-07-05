import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/sale_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_routes.dart';
import '../Global_widgets/personalized_card.dart';

class SaleRequestModelsItems extends StatefulWidget {
  final bool hasDefaultRequestModel;
  final int enterpriseCode;
  final int saleRequestTypeCode;
  const SaleRequestModelsItems({
    required this.hasDefaultRequestModel,
    required this.enterpriseCode,
    required this.saleRequestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<SaleRequestModelsItems> createState() => _SaleRequestModelsItemsState();
}

class _SaleRequestModelsItemsState extends State<SaleRequestModelsItems> {
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text(
                'Selecione o modelo de pedido',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: saleRequestProvider.requestsCount + 1,
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return PersonalizedCard.personalizedCard(
                    context: context,
                    child: ListTile(
                      title: const Text(
                        "Modelo de pedidos padrão",
                        textAlign: TextAlign.center,
                      ),
                      onTap: saleRequestProvider.isLoadingRequests
                          ? null
                          : () {
                              saleRequestProvider.updatedCart = true;
                              Navigator.of(context).pushNamed(
                                widget.hasDefaultRequestModel
                                    ? APPROUTES.SALE_REQUEST
                                    : APPROUTES
                                        .SALE_REQUEST_MANUAL_DEFAULT_REQUEST_MODEL,
                                arguments: {
                                  "SaleRequestTypeCode":
                                      widget.saleRequestTypeCode,
                                  "Code": widget.enterpriseCode,
                                  "UseWholePrice": true,
                                  "UnitValueType": 1, //preço de venda praticado
                                },
                              );
                            },
                    ),
                  );
                } else {
                  return PersonalizedCard.personalizedCard(
                    context: context,
                    child: GestureDetector(
                      onTap: () {
                        saleRequestProvider.updatedCart = true;
                        Navigator.of(context).pushNamed(
                          APPROUTES.SALE_REQUEST,
                          arguments: {
                            "Code": widget.enterpriseCode,
                            "SaleRequestTypeCode":
                                saleRequestProvider.requests[index - 1].Code,
                            "UseWholePrice": saleRequestProvider
                                .requests[index - 1].UseWholePrice,
                            "UnitValueType": saleRequestProvider
                                .requests[index - 1].UnitValueType,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Código do pedido",
                              value: saleRequestProvider
                                  .requests[index - 1].Code
                                  .toString(),
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Nome do pedido",
                              value:
                                  saleRequestProvider.requests[index - 1].Name,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Preço utilizado",
                              value: saleRequestProvider
                                  .requests[index - 1].UnitValueTypeString,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

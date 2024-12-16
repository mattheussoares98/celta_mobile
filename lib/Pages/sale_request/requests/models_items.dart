import '../../../models/enterprise/enterprise.dart';
import '../../../models/sale_request/sale_request.dart';
import '../../../providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../../components/components.dart';

class ModelsItems extends StatefulWidget {
  final bool hasDefaultRequestModel;
  final EnterpriseModel enterprise;
  final int saleRequestTypeCode;
  const ModelsItems({
    required this.hasDefaultRequestModel,
    required this.enterprise,
    required this.saleRequestTypeCode,
    Key? key,
  }) : super(key: key);

  @override
  State<ModelsItems> createState() => _ModelsItemsState();
}

class _ModelsItemsState extends State<ModelsItems> {
  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: saleRequestProvider.requestsCount + 1,
              itemBuilder: (ctx, index) {
                if (index == 0) {
                  return Card(
                    child: ListTile(
                      title: const Text(
                        "Modelo de pedido padrão",
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
                                  "enterprise": widget.enterprise,
                                  "UseWholePrice": true,
                                  "UnitValueType": 1, //preço de venda praticado
                                },
                              );
                            },
                    ),
                  );
                } else {
                  SaleRequestsModel request =
                      saleRequestProvider.requests[index - 1];

                  return Card(
                    child: GestureDetector(
                      onTap: () {
                        saleRequestProvider.updatedCart = true;
                        Navigator.of(context).pushNamed(
                          APPROUTES.SALE_REQUEST,
                          arguments: {
                            "enterprise": widget.enterprise,
                            "SaleRequestTypeCode": request.Code,
                            "UseWholePrice": request.UseWholePrice == 1,
                            "UnitValueType": request.UnitValueType,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Código do pedido",
                              subtitle: request.PersonalizedCode.toString(),
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Nome do pedido",
                              subtitle: request.Name,
                            ),
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Preço utilizado",
                              subtitle: request.UnitValueTypeString,
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

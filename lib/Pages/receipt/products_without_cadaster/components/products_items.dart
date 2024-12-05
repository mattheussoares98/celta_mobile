import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/soap/soap.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class ProductsItems extends StatelessWidget {
  final bool isInserting;
  final int docCode;
  const ProductsItems({
    required this.isInserting,
    required this.docCode,
    super.key,
  });

  void goToInsertUpdateProduct(
    ProductWithoutCadasterModel product,
    BuildContext context,
  ) {
    int docCode = ModalRoute.of(context)!.settings.arguments as int;
    Navigator.of(context).pushNamed(
        APPROUTES.RECEIPT_INSERT_PRODUCT_WITHOUT_CADASTER,
        arguments: {
          "isInserting": false,
          "docCode": docCode,
          "product": product,
        });
  }

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        await receiptProvider.getProductWithoutCadaster(docCode);
      },
      child: ListView.builder(
        itemCount: receiptProvider.productsWithoutCadaster.length,
        itemBuilder: (context, index) {
          final product = receiptProvider.productsWithoutCadaster[index];

          return InkWell(
            onTap: () {
              goToInsertUpdateProduct(product, context);
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "EAN",
                            subtitle: product.Ean_ProcRecebProNaoIden,
                          ),
                          if (product.Obs_ProcRecebProNaoIden.isNotEmpty)
                            TitleAndSubtitle.titleAndSubtitle(
                              title: "Observações",
                              subtitle: product.Obs_ProcRecebProNaoIden,
                            ),
                          TitleAndSubtitle.titleAndSubtitle(
                            title: "Quantidade",
                            subtitle: product.Quantidade_ProcRecebProNaoIden
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        goToInsertUpdateProduct(product, context);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        ShowAlertDialog.show(
                            context: context,
                            title: "Remover produto",
                            subtitle: "Deseja realmente remover o produto?",
                            function: () async {
                              await receiptProvider
                                  .deleteProductWithoutCadaster(
                                grDocCode: docCode,
                                grDocProductWithoutCadasterCode:
                                    product.CodigoInterno_ProcRecebProNaoIden,
                                context: context,
                              );

                              if (receiptProvider
                                      .errorLoadProductsWithoutCadaster ==
                                  "") {
                                await receiptProvider
                                    .getProductWithoutCadaster(docCode);
                              }
                            });
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

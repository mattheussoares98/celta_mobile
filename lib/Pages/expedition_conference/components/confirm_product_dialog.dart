import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/enterprise/enterprise.dart';
import '../../../providers/providers.dart';

class ConfirmProductDialog extends StatelessWidget {
  final int expeditionControlCode;
  final EnterpriseModel enterprise;
  final int stepCode;
  const ConfirmProductDialog({
    required this.expeditionControlCode,
    required this.enterprise,
    required this.stepCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AlertDialog(
        actions: [
          TextButton.icon(
            onPressed: Navigator.of(context).pop,
            label: const Text("Fechar"),
            icon: const Icon(Icons.close),
          ),
        ],
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              const Text(
                "Selecione o produto que deseja confirmar",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      expeditionConferenceProvider.searchedProducts.length,
                  itemBuilder: (context, index) {
                    final searchedProduct =
                        expeditionConferenceProvider.searchedProducts[index];

                    return InkWell(
                      onTap: () async {
                        await expeditionConferenceProvider.addConfirmedProduct(
                          indexOfSearchedProduct: index,
                          expeditionControlCode: expeditionControlCode,
                          enterprise: enterprise,
                          stepCode: stepCode,
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              TitleAndSubtitle.titleAndSubtitle(
                                subtitle: searchedProduct.name! +
                                    " (${searchedProduct.packingQuantity})",
                              ),
                              TitleAndSubtitle.titleAndSubtitle(
                                title: "PLU",
                                subtitle: searchedProduct.plu,
                              ),
                              // TitleAndSubtitle.titleAndSubtitle(
                              //   title: "EAN",
                              //   subtitle: searchedProduct.ean,
                              // ),
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
        ),
      ),
    );
  }
}

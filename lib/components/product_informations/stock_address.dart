import 'package:flutter/material.dart';

import '../../models/soap/soap.dart';

class StockAddress extends StatelessWidget {
  final GetProductJsonModel product;
  const StockAddress({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool _hasAreaAdressInAtualEnterprise() {
      return product.storageAreaAddress?.isNotEmpty == true &&
          product.storageAreaAddress!.length > 0;
    }

    bool _hasAssociatedStocks() {
      return product.stockByEnterpriseAssociateds?.isNotEmpty == true &&
          product.stockByEnterpriseAssociateds!.length > 1;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Endereço dos estoques",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: "Bebasneue",
            ),
            textAlign: TextAlign.center,
          ),
          if (!_hasAreaAdressInAtualEnterprise())
            const Text(
              'Não foram encontradas informações de endereço de estoque na empresa atual',
              textAlign: TextAlign.center,
            ),
          if (_hasAreaAdressInAtualEnterprise())
            Column(
              children: [
                FittedBox(
                  child: Row(
                    children: [
                      Text(
                        "Endereço na empresa atual: ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        product.storageAreaAddress!,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 20,
                  color: Colors.grey,
                ),
              ],
            ),
          if (!_hasAssociatedStocks())
            const Center(
              child: Text(
                'Não foram encontradas informações de estoques associados. Caso acredite que isso está errado, entre em contato com o suporte técnico',
              ),
            ),
          if (_hasAssociatedStocks())
            Column(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(
                      height: 20,
                      color: Colors.grey,
                    ),
                    FittedBox(
                      child: Text(
                        "Estoque nas empresas associadas",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: "BebasNeue",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: product.stockByEnterpriseAssociateds!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Empresa: ',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              TextSpan(
                                text: product
                                    .stockByEnterpriseAssociateds![index]
                                    .enterprise,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        FittedBox(
                          child: Row(
                            children: [
                              Text(
                                "Estoque de venda: ",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                (product.stockByEnterpriseAssociateds![index]
                                            .stockBalanceForSale ??
                                        0)
                                    .toStringAsFixed(3)
                                    .replaceAll(RegExp(r'\.'), ','),
                              ),
                            ],
                          ),
                        ),
                        FittedBox(
                          child: Row(
                            children: [
                              Text(
                                "Endereços: ",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                product.stockByEnterpriseAssociateds![index]
                                            .storageAreaAddress ==
                                        null
                                    ? "Não há"
                                    : product
                                        .stockByEnterpriseAssociateds![index]
                                        .storageAreaAddress
                                        .toString()
                                        .replaceAll(RegExp(r'\['), '- ')
                                        .replaceAll(RegExp(r'\]'), '')
                                        .replaceAll(RegExp(r'\, '), '\n- '),
                              ),
                            ],
                          ),
                        ),
                        if (index + 1 <
                            product.stockByEnterpriseAssociateds!.length)
                          const Divider()
                      ],
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

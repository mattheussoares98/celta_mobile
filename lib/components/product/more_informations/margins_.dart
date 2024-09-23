import 'package:flutter/material.dart';

import '../../../models/soap/soap.dart';
import '../../../utils/utils.dart';
import '../../components.dart';

class Margins extends StatelessWidget implements MoreInformationWidget {
  @override
  MoreInformationType get type => MoreInformationType.margins;
  @override
  String get moreInformationName => "Margens";

  final GetProductJsonModel product;
  const Margins({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            "MARGENS",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (product.priceCost == null)
          const Text(
            "Peça para o suporte atualizar o CeltaBS para exibir as margens corretamente",
            textAlign: TextAlign.center,
          ),
        if (product.priceCost != null)
          Column(
            children: [
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.RetailMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Varejo",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.RetailMinimumMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Mín varejo",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.RetailOfferMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Mín varejo oferta",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.WholeMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Atacado",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.WholeMinimumMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Mín atacado",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.WholeMinimumMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Mín atacado oferta",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.ECommerceMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Ecommerce",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.ECommerceMinimumMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Mín ecommerce",
              ),
              TitleAndSubtitle.titleAndSubtitle(
                subtitle: (product.priceCost?.ECommerceMinimumMargin
                            ?.toString()
                            .toBrazilianNumber() ??
                        "0") +
                    " %",
                title: "Mín ecommerce oferta",
              ),
            ],
          ),
      ],
    );
  }
}

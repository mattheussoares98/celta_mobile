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
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.RetailMargin,
          ),
          title: "Varejo",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.RetailMinimumMargin,
          ),
          title: "Mín varejo",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.RetailOfferMargin,
          ),
          title: "Mín varejo oferta",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.WholeMargin,
          ),
          title: "Atacado",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.WholeMinimumMargin,
          ),
          title: "Mín atacado",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.WholeMinimumMargin,
          ),
          title: "Mín atacado oferta",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.ECommerceMargin,
          ),
          title: "Ecommerce",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.ECommerceMinimumMargin,
          ),
          title: "Mín ecommerce",
        ),
        TitleAndSubtitle.titleAndSubtitle(
          subtitle: ConvertString.convertToBRL(
            product.priceCost?.ECommerceMinimumMargin,
          ),
          title: "Mín ecommerce oferta",
        ),
      ],
    );
  }
}

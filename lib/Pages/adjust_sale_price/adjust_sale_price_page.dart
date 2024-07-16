import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import 'adjust_sale_price.dart';

class AdjustSalePricePage extends StatefulWidget {
  const AdjustSalePricePage({super.key});

  @override
  State<AdjustSalePricePage> createState() => _AdjustSalePricePageState();
}

class _AdjustSalePricePageState extends State<AdjustSalePricePage> {
  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Stack(
      children: [
        const Scaffold(
          body: AdjustSalePriceProductsPage(),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: adjustSalePriceProvider.isLoading,
        )
      ],
    );
  }
}

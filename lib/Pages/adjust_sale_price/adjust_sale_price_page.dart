import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';

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
        Scaffold(
          appBar: AppBar(
            title: const Text("Alteração de preços"),
          ),
          body: const Column(
            children: [],
          ),
        ),
        loadingWidget(
          message: "Aguarde...",
          isLoading: adjustSalePriceProvider.isLoading,
        )
      ],
    );
  }
}

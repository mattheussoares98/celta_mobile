import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/expedition_control/expedition_control.dart';
import '../../providers/providers.dart';
import './components/components.dart';

class ExpeditionConferenceCheckedProductsPage extends StatelessWidget {
  const ExpeditionConferenceCheckedProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    ExpeditionConferenceProvider expeditionConferenceProvider =
        Provider.of(context);

    return ListView.builder(
      itemCount: expeditionConferenceProvider.checkedProducts.length,
      itemBuilder: (context, index) {
        ExpeditionControlProductModel product =
            expeditionConferenceProvider.checkedProducts[index];

        return ExpeditionControlProductItem(product: product);
      },
    );
  }
}

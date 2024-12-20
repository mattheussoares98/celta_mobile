import 'package:flutter/material.dart';

import '../../models/models.dart';

class InsertUpdateBuyQuotationPage extends StatelessWidget {
  const InsertUpdateBuyQuotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    BuyQuotationIncompleteModel? incompleteModel = ModalRoute.of(context)
        ?.settings
        .arguments as BuyQuotationIncompleteModel?;

    return Scaffold(
      appBar: AppBar(
        title: Text(incompleteModel == null ? "Inserindo" : "Alterando"),
      ),
    );
  }
}

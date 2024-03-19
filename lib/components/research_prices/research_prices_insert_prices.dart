import 'package:flutter/material.dart';

import '../../components/global_widgets/global_widgets.dart';

class ResearchPricesInsertPrices extends StatefulWidget {
  const ResearchPricesInsertPrices({super.key});

  @override
  State<ResearchPricesInsertPrices> createState() =>
      _ResearchPricesInsertPricesState();
}

class _ResearchPricesInsertPricesState
    extends State<ResearchPricesInsertPrices> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: FormFieldHelper.decoration(
              isLoading: false,
              context: context,
              labelText: "Preço de venda",
            ),
            validator: FormFieldHelper.validatorOfNumber(),
            style: FormFieldHelper.style(),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

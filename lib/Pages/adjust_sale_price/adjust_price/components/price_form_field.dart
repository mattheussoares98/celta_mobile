import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';

class PriceFormField extends StatelessWidget {
  final TextEditingController priceTextController;
  final GlobalKey<FormState> formKey;
  final Function() confirmAdjust;
  const PriceFormField({
    required this.priceTextController,
    required this.formKey,
    required this.confirmAdjust,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);

    return Column(
      children: [
        const Divider(),
        Form(
            key: formKey,
            child: TextFormField(
              controller: priceTextController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: const TextInputType.numberWithOptions(),
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              style: FormFieldHelper.style(),
              onFieldSubmitted: (value) async {
                await confirmAdjust();
              },
              decoration: FormFieldHelper.decoration(
                isLoading: adjustSalePriceProvider.isLoading,
                context: context,
              ),
              validator: FormFieldHelper.validatorOfNumber(maxDecimalPlaces: 2),
            )),
      ],
    );
  }
}

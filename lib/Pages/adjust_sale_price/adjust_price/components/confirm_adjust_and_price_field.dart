import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';

import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class PriceFieldAndConfirmAdjustButton extends StatefulWidget {
  const PriceFieldAndConfirmAdjustButton({
    super.key,
  });

  @override
  State<PriceFieldAndConfirmAdjustButton> createState() =>
      _PriceFieldAndConfirmAdjustButtonState();
}

class _PriceFieldAndConfirmAdjustButtonState
    extends State<PriceFieldAndConfirmAdjustButton> {
  final priceTextController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> confirmAdjust(
    AdjustSalePriceProvider adjustSalePriceProvider,
  ) async {
    final Map arguments = ModalRoute.of(context)!.settings.arguments! as Map;
    final EnterpriseModel enterprise = arguments["enterprise"];
    final GetProductJsonModel product = arguments["product"];

    if (!adjustSalePriceProvider.allObligatoryDataAreInformed()) {
      ShowSnackbarMessage.show(
        message: "Selecione o tipo de preço e o tipo de venda",
        context: context,
      );
      return;
    }

    bool? isValid = formKey.currentState?.validate();

    if (isValid == true) {
      ShowAlertDialog.show(
          context: context,
          title: "Confirmar ajuste?",
          function: () async {
            await adjustSalePriceProvider.confirmAdjust(
              productPackingCode: product.productPackingCode!,
              productCode: product.productCode!,
              enterpriseCode: enterprise.Code,
              price: priceTextController.text.toDouble(),
              effectuationDateOffer: adjustSalePriceProvider.initialDate,
              effectuationDatePrice: adjustSalePriceProvider.initialDate,
              endDateOffer: adjustSalePriceProvider.finishDate,
            );

            if (adjustSalePriceProvider.errorMessage == "") {
              Navigator.of(context).pop();
              ShowSnackbarMessage.show(
                message: "Ajuste confirmado com sucesso",
                context: context,
                backgroundColor: Theme.of(context).colorScheme.primary,
              );
            } else {
              ShowSnackbarMessage.show(
                message: adjustSalePriceProvider.errorMessage,
                context: context,
              );
            }
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
    priceTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdjustSalePriceProvider adjustSalePriceProvider = Provider.of(context);
    return Column(
      children: [
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: priceTextController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  style: FormFieldStyle.style(),
                  onFieldSubmitted: (value) async {
                    await confirmAdjust(adjustSalePriceProvider);
                  },
                  decoration: FormFieldDecoration.decoration(
                    context: context,
                    hintText: "Preço",
                    labelText: "Preço",
                  ),
                  validator: (value) {
                    return FormFieldValidations.number(
                      value: value,
                      maxDecimalPlaces: 2,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await confirmAdjust(adjustSalePriceProvider);
                },
                child: const FittedBox(child: Text("Confirmar ajuste")),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

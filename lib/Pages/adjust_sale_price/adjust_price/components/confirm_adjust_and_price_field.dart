import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/enterprise/enterprise.dart';
import '../../../../models/soap/soap.dart';
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
      ShowSnackbarMessage.showMessage(
        message: "Selecione o tipo de preço e o tipo de venda",
        context: context,
      );
      return;
    }

    bool? isValid = formKey.currentState?.validate();

    if (isValid == true) {
      ShowAlertDialog.showAlertDialog(
          context: context,
          title: "Confirmar ajuste?",
          function: () async {
            await adjustSalePriceProvider.confirmAdjust(
              productPackingCode: product.productPackingCode!,
              productCode: product.productCode!,
              enterpriseCode: enterprise.codigoInternoEmpresa,
              price: priceTextController.text.toDouble(),
              effectuationDateOffer: DateTime.now(),
              effectuationDatePrice: DateTime.now(),
              endDateOffer: DateTime.now(),
            );

            if (adjustSalePriceProvider.errorMessage == "") {
              Navigator.of(context).pop();
              ShowSnackbarMessage.showMessage(
                message: "Ajuste confirmado com sucesso",
                context: context,
                backgroundColor: Theme.of(context).colorScheme.primary,
              );
            } else {
              ShowSnackbarMessage.showMessage(
                message: adjustSalePriceProvider.errorMessage,
                context: context,
                backgroundColor: Theme.of(context).colorScheme.primary,
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
                  keyboardType: const TextInputType.numberWithOptions(),
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  style: FormFieldHelper.style(),
                  onFieldSubmitted: (value) async {
                    await confirmAdjust(adjustSalePriceProvider);
                  },
                  decoration: FormFieldHelper.decoration(
                    isLoading: adjustSalePriceProvider.isLoading,
                    context: context,
                    hintText: "Preço",
                    labelText: "Preço",
                  ),
                  validator:
                      FormFieldHelper.validatorOfNumber(maxDecimalPlaces: 2),
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

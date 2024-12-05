import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../models/soap/soap.dart';
import '../../../../providers/providers.dart';
import '../../../../utils/utils.dart';

class InsertButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final int docCode;
  final TextEditingController eanController;
  final TextEditingController observationsController;
  final TextEditingController quantityController;
  final bool isInserting;
  final ProductWithoutCadasterModel? product;
  const InsertButton({
    required this.formKey,
    required this.docCode,
    required this.eanController,
    required this.observationsController,
    required this.quantityController,
    required this.isInserting,
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ReceiptProvider receiptProvider = Provider.of(context);

    return ElevatedButton(
      onPressed: () async {
        bool? isValid = formKey.currentState?.validate();

        if (isValid != true) {
          return;
        }

        await receiptProvider.insertUpdateProductWithoutCadaster(
          grDocCode: docCode,
          ean: eanController.text,
          observations: observationsController.text,
          quantity: quantityController.text.toDouble(),
          context: context,
          grDocProductWithoutCadasterCode: product?.CodigoInterno_ProcRecebProNaoIden,
        );

        if (receiptProvider.errorInsertProductsWithoutCadaster == "") {
          Navigator.of(context).pop();
          ShowSnackbarMessage.show(
            message: "Produto inserido com sucesso",
            context: context,
            backgroundColor: Theme.of(context).colorScheme.primary,
          );
          receiptProvider.getProductWithoutCadaster(docCode);
        }
      },
      child: Text(isInserting ? "Inserir" : "Alterar"),
    );
  }
}

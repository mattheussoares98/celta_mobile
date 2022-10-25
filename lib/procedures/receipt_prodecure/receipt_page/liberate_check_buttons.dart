import 'package:celta_inventario/procedures/receipt_prodecure/models/enterprise_receipt_model.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/receipt_page/receipt_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';

class LiberateCheckButtons {
  static liberateCheckButtons({
    required int grDocCode,
    required ReceiptProvider receiptProvider,
    required BuildContext context,
    required EnterpriseReceiptModel enterprise,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: receiptProvider.isLoadingLiberateCheck
              ? null
              : () async {
                  // print(grDocCode);
                  await receiptProvider.liberate(grDocCode);

                  if (receiptProvider.liberateError != "") {
                    ShowErrorMessage().showErrorMessage(
                      error: receiptProvider.liberateError,
                      context: context,
                    );
                  } else {
                    receiptProvider.getReceipt(
                      enterpriseCode:
                          enterprise.codigoInternoEmpresa.toString(),
                    );
                  }
                },
          child: receiptProvider.isLoadingLiberateCheck
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'AGUARDE...',
                    ),
                    const SizedBox(width: 7),
                    Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : const Text("Liberar"),
        ),
        ElevatedButton(
          onPressed: receiptProvider.isLoadingLiberateCheck
              ? null
              : () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.CONFERENCE,
                    arguments: grDocCode,
                  );
                },
          child: receiptProvider.isLoadingLiberateCheck
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'AGUARDE...',
                    ),
                    const SizedBox(width: 7),
                    Container(
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : const Text("Conferir"),
        )
      ],
    );
  }
}

import 'package:celta_inventario/procedures/receipt_prodecure/models/enterprise_receipt_model.dart';
import 'package:celta_inventario/procedures/receipt_prodecure/receipt_page/receipt_provider.dart';
import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';

class LiberateCheckButtons extends StatefulWidget {
  final int grDocCode;
  final ReceiptProvider receiptProvider;
  final int index;
  const LiberateCheckButtons({
    required this.grDocCode,
    required this.receiptProvider,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  State<LiberateCheckButtons> createState() => _LiberateCheckButtonsState();
}

class _LiberateCheckButtonsState extends State<LiberateCheckButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: widget.receiptProvider.isLoadingLiberateCheck
              ? null
              : () async {
                  // print(grDocCode);
                  await widget.receiptProvider.liberate(
                    grDocCode: widget.grDocCode,
                    index: widget.index,
                  );

                  if (widget.receiptProvider.liberateError != "") {
                    ShowErrorMessage().showErrorMessage(
                      error: widget.receiptProvider.liberateError,
                      context: context,
                    );
                  }
                },
          child: widget.receiptProvider.isLoadingLiberateCheck
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
          onPressed: widget.receiptProvider.isLoadingLiberateCheck
              ? null
              : () {
                  Navigator.of(context).pushNamed(
                    APPROUTES.CONFERENCE,
                    arguments: widget.grDocCode,
                  );
                },
          child: widget.receiptProvider.isLoadingLiberateCheck
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

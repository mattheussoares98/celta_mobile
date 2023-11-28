import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BuyRequestObservations extends StatefulWidget {
  final FocusNode focusNode;
  const BuyRequestObservations({
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestObservations> createState() => _BuyRequestObservationsState();
}

class _BuyRequestObservationsState extends State<BuyRequestObservations> {
  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 200,
        ),
        child: TextField(
          focusNode: widget.focusNode,
          controller: buyRequestProvider.observationsController,
          enabled: !buyRequestProvider.isLoadingInsertBuyRequest,
          inputFormatters: [NoLineBreakFormatter()],
          onChanged: (value) {
            buyRequestProvider.updateObservationsControllerText(value);
          },
          maxLines: null,
          maxLength: 1000,
          decoration: FormFieldHelper.decoration(
            isLoading: false,
            context: context,
            labelText: 'Observações',
          ),
          style: FormFieldHelper.style(),
        ),
      ),
    );
  }
}

class NoLineBreakFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newString = newValue.text.replaceAll(RegExp(r'\n'), '');
    int selectionIndex = newValue.selection.baseOffset -
        (newValue.text.length - newString.length);

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../providers/providers.dart';
import '../../../components/components.dart';

class Observations extends StatefulWidget {
  final FocusNode focusNode;
  const Observations({
    required this.focusNode,
    Key? key,
  }) : super(key: key);

  @override
  State<Observations> createState() => _ObservationsState();
}

class _ObservationsState extends State<Observations> {
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
          decoration: FormFieldDecoration.decoration(
            context: context,
            labelText: 'Observações',
          ),
          style: FormFieldStyle.style(),
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

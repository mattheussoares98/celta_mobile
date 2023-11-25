import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BuyRequestObservations extends StatefulWidget {
  const BuyRequestObservations({Key? key}) : super(key: key);

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
          controller: buyRequestProvider.observationsController,
          enabled: !buyRequestProvider.isLoadingInsertBuyRequest,
          inputFormatters: [NoLineBreakFormatter()],
          onChanged: (value) {
            buyRequestProvider.observationsController.text = value;
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
    // Impede a quebra de linha substituindo qualquer caractere de quebra de linha por um espaço em branco.
    String newString = newValue.text.replaceAll(RegExp(r'\n'), '');
    return newValue.copyWith(text: newString);
  }
}

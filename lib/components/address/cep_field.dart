import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../components.dart';

class CepField extends StatelessWidget {
  final TextEditingController cepController;
  final FocusNode cepFocusNode;
  final Future<void> Function() getAdressByCep;
  const CepField({
    super.key,
    required this.cepController,
    required this.cepFocusNode,
    required this.getAdressByCep,
  });

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return FormFieldWidget(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: !customerRegisterProvider.isLoading,
      focusNode: cepFocusNode,
      onFieldSubmitted: (_) async {
        await getAdressByCep();
      },
      labelText: "CEP",
      textEditingController: cepController,
      limitOfCaracters: 8,
      validator: FormFieldValidations.cep,
      suffixWidget: TextButton(
        child: Text("Pesquisar CEP"),
        onPressed: getAdressByCep,
      ),
    );
  }
}

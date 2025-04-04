import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/models.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class LimitAndBindCovenantButton extends StatefulWidget {
  final CustomerRegisterCovenantModel covenant;
  const LimitAndBindCovenantButton({
    required this.covenant,
    super.key,
  });

  @override
  State<LimitAndBindCovenantButton> createState() =>
      _LimitAndBindCovenantButtonState();
}

class _LimitAndBindCovenantButtonState
    extends State<LimitAndBindCovenantButton> {
  final limitController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  dispose() {
    super.dispose();
    limitController.dispose();
  }

  void associateCovenant(
    CustomerRegisterProvider customerRegisterProvider,
  ) {
    bool? isValid = key.currentState?.validate();
    if (isValid == true) {
      customerRegisterProvider.bindCovenant(
        covenant: widget.covenant,
        limit: limitController.text.toDouble(),
      );
      limitController.clear();
      key.currentState?.reset();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return Form(
      key: key,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                autofocus: false,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: limitController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (_) {
                  associateCovenant(customerRegisterProvider);
                },
                validator: (value) => FormFieldValidations.number(
                  value,
                  maxDecimalPlaces: 2,
                ),
                decoration: FormFieldDecoration.decoration(
                  context: context,
                  hintText: "Limite R\$",
                  labelText: "Limite R\$",
                ),
              ),
            ),
            Flexible(
              child: Center(
                child: TextButton(
                  onPressed: () {
                    associateCovenant(customerRegisterProvider);
                  },
                  child: const Text(
                    "Vincular convênio",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class LimitAndBindCovenantButton extends StatefulWidget {
  final int index;
  const LimitAndBindCovenantButton({
    required this.index,
    super.key,
  });

  @override
  State<LimitAndBindCovenantButton> createState() =>
      _LimitAndBindCovenantButtonState();
}

class _LimitAndBindCovenantButtonState
    extends State<LimitAndBindCovenantButton> {
  final controller = TextEditingController();
  final key = GlobalKey<FormState>();

  void associateCovenant(
    GlobalKey<FormState> key,
    CustomerRegisterProvider customerRegisterProvider,
  ) {
    bool? isValid = key.currentState?.validate();
    if (isValid == true) {
      customerRegisterProvider.bindCovenant(
        index: widget.index,
        limit: controller.text.toDouble(),
      );
      controller.clear();
      key.currentState?.reset();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
                keyboardType: TextInputType.number,
                controller: controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (_) {
                  associateCovenant(key, customerRegisterProvider);
                },
                validator: (value) => FormFieldValidations.number(
                  value: value,
                  maxDecimalPlaces: 2,
                ),
                decoration: FormFieldDecoration.decoration(
                  isLoading: false,
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
                    associateCovenant(key, customerRegisterProvider);
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

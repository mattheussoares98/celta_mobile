import 'package:flutter/material.dart';

import '../../../components/components.dart';

class LimitAndBindCovenantButton extends StatefulWidget {
  const LimitAndBindCovenantButton({
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

  void associateCovenant(GlobalKey<FormState> key) {
    bool? isValid = key.currentState?.validate();
    if (isValid == true) {
      debugPrint("Correto, pode inserir");
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (_) {
                  associateCovenant(key);
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
                    associateCovenant(key);
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

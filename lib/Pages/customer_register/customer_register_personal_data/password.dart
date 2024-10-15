import 'package:flutter/material.dart';

import '../../../components/components.dart';

class Password extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;
  final Function() validateFormKey;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;

  const Password({
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
    required this.validateFormKey,
    required this.passwordController,
    required this.passwordConfirmationController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormFieldWidget(
          enabled: true,
          textEditingController: passwordController,
          labelText: "Senha",
          obscureText: true,
          focusNode: passwordFocusNode,
          suffixWidget: IconButton(
            onPressed: () {
              passwordController.clear();
              passwordFocusNode.requestFocus();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          onFieldSubmitted: (_) {
            if (passwordController.text.isNotEmpty) {
              passwordConfirmationFocusNode.requestFocus();
            }
          },
          validator: (value) => FormFieldValidations.minimumSize(
            value: value,
            minimumSize: 3,
          ),
          onChanged: (_) {
            validateFormKey();
          },
        ),
        FormFieldWidget(
          enabled: true,
          textEditingController: passwordConfirmationController,
          labelText: "Confirmar senha",
          obscureText: true,
          focusNode: passwordConfirmationFocusNode,
          suffixWidget: IconButton(
            onPressed: () {
              passwordConfirmationController.clear();
              passwordConfirmationFocusNode.requestFocus();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
          onChanged: (_) {
            validateFormKey();
          },
          validator: (value) {
            if (value != passwordController.text) {
              return "Senhas não conferem";
            }
            return null;
          },
        ),
      ],
    );
  }
}

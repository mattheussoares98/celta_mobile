import 'package:flutter/material.dart';

import '../../../components/components.dart';

class Password extends StatelessWidget {
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;
  final FocusNode sexTypeFocusNode;
  final Function() validateFormKey;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final bool cpfCnpjIsValid;

  const Password({
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
    required this.sexTypeFocusNode,
    required this.validateFormKey,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.cpfCnpjIsValid,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormFieldWidget(
          enabled: cpfCnpjIsValid,
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
            } else {
              passwordFocusNode.requestFocus();
            }
          },
          validator: (value) => FormFieldValidations.minimumSize(
            value: value,
            minimumSize: 3,
            canBeNullOrEmpty: true,
          ),
          onChanged: (_) {
            validateFormKey();
          },
        ),
        FormFieldWidget(
          enabled: cpfCnpjIsValid,
          textEditingController: passwordConfirmationController,
          labelText: "Confirmar senha",
          obscureText: true,
          focusNode: passwordConfirmationFocusNode,
          onFieldSubmitted: (_) {
            if (passwordConfirmationController.text.isEmpty) {
              passwordConfirmationFocusNode.requestFocus();
            } else {
              sexTypeFocusNode.requestFocus();
            }
          },
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

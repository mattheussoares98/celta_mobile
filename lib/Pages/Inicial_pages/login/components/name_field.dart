import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';

class NameField extends StatelessWidget {
  final Animation<double> animationWidth;
  final TextEditingController userController;
  final FocusNode userFocusNode;
  final FocusNode passwordFocusNode;
  final bool allControllersAreFilled;
  final Future<void> Function() doLogin;

  const NameField({
    required this.animationWidth,
    required this.userController,
    required this.userFocusNode,
    required this.passwordFocusNode,
    required this.allControllersAreFilled,
    required this.doLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);

    return SizedBox(
      width: animationWidth.value,
      child: TextFormField(
        enabled: loginProvider.isLoading ? false : true,
        controller: userController,
        focusNode: userFocusNode,
        onFieldSubmitted: (_) async {
          if (allControllersAreFilled) {
            await doLogin();
          } else {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          }
        },
        validator: (_name) {
          _name = userController.text;
          if (userController.text.trim().isEmpty) {
            return 'Preencha o nome';
          }

          userController.text = userController.text.trimRight();
          //fiz isso porque quando termina com espaço, a API retorna que a senha está
          //inválida ao invés do usuário inválido e ninguém cadastra usuário com
          //espaço no final do nome

          return null;
        },
        style: FormFieldStyle.style(),
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: "Usuário",
        ),
      ),
    );
  }
}

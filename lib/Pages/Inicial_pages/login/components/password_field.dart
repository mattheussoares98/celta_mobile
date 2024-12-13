import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/components.dart';
import '../../../../providers/providers.dart';

class PasswordField extends StatefulWidget {
  final Animation<double> animationWidth;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final FocusNode urlFocusNode;
  final bool allControllersAreFilled;
  final Future<void> Function() doLogin;
  const PasswordField({
    required this.animationWidth,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.urlFocusNode,
    required this.allControllersAreFilled,
    required this.doLogin,
    super.key,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);

    return SizedBox(
      width: widget.animationWidth.value,
      child: TextFormField(
        controller: widget.passwordController,
        enabled: loginProvider.isLoading ? false : true,
        focusNode: widget.passwordFocusNode,
        onFieldSubmitted: (_) async {
          if (widget.allControllersAreFilled) {
            await widget.doLogin();
          } else {
            FocusScope.of(context).requestFocus(widget.urlFocusNode);
          }
        },
        style: FormFieldStyle.style(),
        validator: (_name) {
          if (widget.passwordController.text.trim().isEmpty) {
            return 'Preencha a senha';
          }
          return null;
        },
        decoration: FormFieldDecoration.decoration(
          context: context,
          labelText: "Senha",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: _passwordVisible
                ? Icon(
                    Icons.remove_red_eye,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : const Icon(
                    Icons.visibility_off,
                  ),
          ),
        ),
        obscureText: _passwordVisible ? false : true,
      ),
    );
  }
}

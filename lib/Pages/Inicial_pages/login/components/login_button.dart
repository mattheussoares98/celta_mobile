import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/providers.dart';

class LoginButton extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animationWidth;
  final Animation<double> animationBorder;
  final Future<void> Function() doLogin;
  const LoginButton({
    required this.animationController,
    required this.animationWidth,
    required this.animationBorder,
    required this.doLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context);

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, widget) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(animationWidth.value, 60),
          backgroundColor: loginProvider.isLoading
              ? Colors.grey
              : Theme.of(context).colorScheme.primary,
          maximumSize: Size(animationWidth.value, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(animationBorder.value),
          ),
        ),
        onPressed: loginProvider.isLoading
            ? null
            : () async {
                await doLogin();
              },
        child: loginProvider.isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 4,
                color: Colors.grey,
              )
            : const FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Login',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

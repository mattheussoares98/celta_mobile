import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final String textButton;
  const ActionButton({
    required this.pageIndex,
    required this.pageController,
    required this.textButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      child: FittedBox(
        child: Text(
          textButton,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

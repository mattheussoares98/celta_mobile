import 'package:flutter/material.dart';

import '../../providers/providers.dart';

floatingPersonalizedButton({
  required BuildContext context,
  required ResearchPricesProvider researchPricesProvider,
  required String nextRoute,
  required bool isLoading,
  required String messageButton,
  required void Function()? onTap,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isLoading
              ? [
                  const Color.fromARGB(255, 200, 198, 198),
                  const Color.fromARGB(255, 200, 198, 198),
                ]
              : [
                  Theme.of(context).colorScheme.primary,
                  const Color.fromARGB(255, 51, 111, 53),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: FittedBox(
          child: Center(
            child: Text(
              messageButton,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

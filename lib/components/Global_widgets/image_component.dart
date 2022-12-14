import 'package:flutter/material.dart';

class ImageComponent {
  static InkWell image({
    required String imagePath,
    required String routine,
    required String route,
    required BuildContext context,
    required String nextRoute,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          route,
          arguments: nextRoute,
        );
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          side: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                imagePath,
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  border: Border.all(
                    style: BorderStyle.none,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    routine,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                    ),
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

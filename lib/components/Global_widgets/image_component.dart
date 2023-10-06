import 'package:flutter/material.dart';

class ImageComponent {
  static InkWell image({
    required String imagePath,
    required String routine,
    required String route,
    required BuildContext context,
    String? nextRoute,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          route,
          arguments: nextRoute,
        );
      },
      child: Card(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(
                        style: BorderStyle.none,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        routine,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 15,
                        ),
                      ),
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

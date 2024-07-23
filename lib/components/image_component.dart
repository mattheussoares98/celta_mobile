import 'package:flutter/material.dart';

class ImageComponent {
  static Widget image({
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.fill,
                alignment: Alignment.topCenter,
                height: double.infinity,
              ),
            ),
            Positioned.fill(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black26,
                        Colors.black54,
                      ],
                    ),
                    border: Border.all(
                      style: BorderStyle.none,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        routine,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black38, offset: Offset(1, 1)),
                              BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(1.5, 1.5)),
                            ]),
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

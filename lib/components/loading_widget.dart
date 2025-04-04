import 'package:flutter/material.dart';

PopScope loadingWidget(bool isLoading) {
  return PopScope(
    canPop: !isLoading,
    child: Visibility(
      visible: isLoading,
      child: Positioned.fill(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withAlpha(170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Aguarde...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        decoration: TextDecoration.none,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 30,
                      width: 30,
                      child: const CircularProgressIndicator(
                        color: Colors.grey,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

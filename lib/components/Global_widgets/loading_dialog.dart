import 'package:flutter/material.dart';

// import 'loading_image.dart';

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const PopScope(
      canPop: false,
      child: SimpleDialog(
        surfaceTintColor: Colors.white,
        children: <Widget>[
          Column(
            key: Key("loading"),
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Aguarde...", textAlign: TextAlign.center),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

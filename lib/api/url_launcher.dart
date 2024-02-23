import 'package:url_launcher/url_launcher.dart';
import "package:flutter/material.dart";

class UrlLauncher {
  static Future<void> searchAndLaunchUrl({
    required String url,
    required BuildContext context,
  }) async {
    // Navigator.of(context).pop();

    final Uri _url = Uri.parse(url);
    try {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

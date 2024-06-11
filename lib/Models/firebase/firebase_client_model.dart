import 'package:flutter/foundation.dart';

class FirebaseClientModel {
  final String enterpriseName;
  final String urlCCS;
  FirebaseClientModel({
    this.enterpriseName = "undefined",
    required this.urlCCS,
  });

  Map<String, dynamic> toJson() {
    if (kIsWeb) {
      return {
        'enterpriseName':
            enterpriseName.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        'urlCCSWeb': urlCCS.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
      };
    } else {
      return {
        'enterpriseName':
            enterpriseName.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
        'urlCCS': urlCCS.toLowerCase().replaceAll(RegExp(r'\s+'), ''),
      };
    }
  }

  factory FirebaseClientModel.fromJson(Map json) => FirebaseClientModel(
        urlCCS: json["urlCCS"] ?? json["urlCCSWeb"],
        enterpriseName: json["enterpriseName"],
      );
}

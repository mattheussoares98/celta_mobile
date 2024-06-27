import 'package:flutter/foundation.dart';

class FirebaseClientModel {
  final String enterpriseName;
  final String urlCCS;
  final String? id;
  final List? usersInformations;
  FirebaseClientModel({
    this.enterpriseName = "undefined",
    required this.id,
    required this.urlCCS,
    required this.usersInformations,
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

  factory FirebaseClientModel.fromJson(
          {required Map json, required String id}) =>
      FirebaseClientModel(
        urlCCS: json["urlCCS"] ?? json["urlCCSWeb"],
        enterpriseName: json["enterpriseName"],
        id: id,
        usersInformations: json["usersInformations"],
      );
}

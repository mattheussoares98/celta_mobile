import 'firebase.dart';
import '../../utils/utils.dart';

class FirebaseEnterpriseModel {
  final String enterpriseName;
  final String urlCCS;
  final String? id;
  final List<UserInformationsModel>? usersInformations;
  FirebaseEnterpriseModel({
    this.enterpriseName = "undefined",
    required this.id,
    required this.urlCCS,
    required this.usersInformations,
  });

  Map<String, dynamic> toJson() {
    return {
      'enterpriseName': enterpriseName.toLowerCase().removeWhiteSpaces(),
      'urlCCS': urlCCS.toLowerCase().removeWhiteSpaces(),
    };
  }

  factory FirebaseEnterpriseModel.fromJson(
      {required Map json, required String id}) {
    var newClient = FirebaseEnterpriseModel(
      urlCCS: json["urlCCS"] ?? json["urlCCSWeb"],
      enterpriseName: json["enterpriseName"],
      id: id,
      usersInformations: json["usersInformations"] == null
          ? json["usersInformations"]
          : json["usersInformations"]
              .map<UserInformationsModel>(
                  (element) => UserInformationsModel.fromJson(element))
              .toList(),
    );

    if (newClient.usersInformations != null) {
      newClient.usersInformations!.sort((a, b) => a.dateOfLastUpdatedInFirebase
          .compareTo(b.dateOfLastUpdatedInFirebase));
    }

    return newClient;
  }
}

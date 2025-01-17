import '../models.dart';
import '../../utils/utils.dart';

class FirebaseEnterpriseModel {
  final String enterpriseName;
  final String urlCCS;
  final String? id;
  final List<UserInformationsModel>? usersInformations;
  final List<ModuleModel>? modules;
  final List<CnpjModel> cnpjs;
  FirebaseEnterpriseModel({
    this.enterpriseName = "undefined",
    required this.id,
    required this.urlCCS,
    required this.usersInformations,
    required this.modules,
    required this.cnpjs,
  });

  Map<String, dynamic> toJson() {
    return {
      'enterpriseName': enterpriseName.toLowerCase().removeWhiteSpaces(),
      'urlCCS': urlCCS.toLowerCase().removeWhiteSpaces(),
      'modules': modules?.map((e) => e.toJson()).toList(),
      'cnpjs': cnpjs.map((e) => e.toJson()).toList(),
    };
  }

  factory FirebaseEnterpriseModel.fromJson({
    required Map json,
    required String id,
  }) {
    var newClient = FirebaseEnterpriseModel(
      cnpjs: json["cnpjs"]
              ?.map((e) => CnpjModel.fromJson(e))
              .toList()
              .cast<CnpjModel>() ??
          <CnpjModel>[],
      modules: json["modules"] == null
          ? []
          : json["modules"]
              .map<ModuleModel>((e) => ModuleModel.fromJson(e))
              .toList(),
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

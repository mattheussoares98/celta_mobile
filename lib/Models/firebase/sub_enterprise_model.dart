import '../models.dart';

class SubEnterpriseModel {
  final List<ModuleModel>? modules;
  final String? cnpj;
  final String? surname;

  const SubEnterpriseModel({
    required this.modules,
    required this.cnpj,
    required this.surname,
  });

  factory SubEnterpriseModel.fromJson(Map data) => SubEnterpriseModel(
        modules: data["modules"]
                ?.map((e) => ModuleModel.fromJson(e))
                .toList()
                .cast<ModuleModel>() ??
            <ModuleModel>[],
        cnpj: data["cnpj"],
        surname: data["surname"],
      );

  Map<String, dynamic> toJson() => {
        "modules": modules?.map((e) => e.toJson()).toList(),
        "cnpj": cnpj,
        "surname": surname,
      };
}

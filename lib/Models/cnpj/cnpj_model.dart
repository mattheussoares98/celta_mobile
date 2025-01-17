class CnpjModel {
  final String surname;
  final int cnpj;

  CnpjModel({
    required this.surname,
    required this.cnpj,
  });

  factory CnpjModel.fromJson(Map data) => CnpjModel(
        surname: data["surname"],
        cnpj: data["cnpj"],
      );

  Map<String, dynamic> toJson() => {
        "surname": surname,
        "cnpj": cnpj,
      };
}

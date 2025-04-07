class AddressModel {
  String? Zip;
  String? Address;
  String? Number;
  String? District;
  String? City;
  String? State;
  String? Complement;
  String? Reference;

  AddressModel({
    required this.Zip,
    required this.Address,
    required this.Number,
    required this.District,
    required this.City,
    required this.State,
    required this.Complement,
    required this.Reference,
  });

  static List<AddressModel> convertToAdresses(
    List<Map<String, dynamic>> adresses,
  ) {
    List<AddressModel> list = [];
    adresses.forEach((element) {
      list.add(AddressModel.fromJson(element));
    });

    return list;
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      Zip: json["Zip"],
      Address: json["Address"],
      Number: json["Number"],
      District: json["District"],
      City: json["City"],
      State: json["State"],
      Complement: json["Complement"],
      Reference: json["Reference"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Zip'] = this.Zip;
    data['Address'] = this.Address;
    data['Complement'] = this.Complement;
    data['District'] = this.District;
    data['City'] = this.City;
    data['State'] =
        _states.entries.where((e) => e.value == this.State).first.key;
    data['Reference'] = this.Reference;
    data['Number'] = this.Number;
    return data;
  }

  factory AddressModel.fromViaCepJson({
    required Map data,
    required Map<String, String> states,
  }) =>
      AddressModel(
        Zip: data["cep"],
        Address: data["logradouro"],
        Complement: data["complemento"],
        District: data["bairro"],
        City: data["localidade"],
        State: states[data["uf"]],
        Number: null,
        Reference: null,
      );

  static final Map<String, String> _states = {
    "AC": "Acre",
    "AL": "Alagoas",
    "AP": "Amapá",
    "AM": "Amazonas",
    "BA": "Bahia",
    "CE": "Ceará",
    "DF": "Distrito Federal",
    "ES": "Espírito Santo",
    "GO": "Goiás",
    "MA": "Maranhão",
    "MT": "Mato Grosso",
    "MS": "Mato Grosso do Sul",
    "MG": "Minas Gerais",
    "PA": "Pará",
    "PB": "Paraíba",
    "PR": "Paraná",
    "PE": "Pernambuco",
    "PI": "Piauí",
    "RJ": "Rio de Janeiro",
    "RN": "Rio Grande do Norte",
    "RS": "Rio Grande do Sul",
    "RO": "Rondônia",
    "RR": "Roraima",
    "SC": "Santa Catarina",
    "SP": "São Paulo",
    "SE": "Sergipe",
    "TO": "Tocantins",
  };
}

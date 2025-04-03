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
    data['State'] = this.State;
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
}

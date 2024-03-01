class AdressModel {
  final String Zip;
  final String Address;
  final String Number;
  final String District;
  final String City;
  final String State;
  final String Complement;
  final String Reference;

  AdressModel({
    required this.Zip,
    required this.Address,
    required this.Number,
    required this.District,
    required this.City,
    required this.State,
    required this.Complement,
    required this.Reference,
  });

  static List<AdressModel> convertToAdresses(
    List<Map<String, dynamic>> adresses,
  ) {
    List<AdressModel> list = [];
    adresses.forEach((element) {
      list.add(AdressModel.fromJson(element));
    });

    return list;
  }

  factory AdressModel.fromJson(Map<String, dynamic> json) {
    return AdressModel(
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
}

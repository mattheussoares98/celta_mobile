class CustomerAdressesModel {
  final String? Zip;
  final String? Address;
  final String? Number;
  final String? District;
  final String? City;
  final String? State;
  final String? Complement;
  final String? Reference;

  CustomerAdressesModel({
    required this.Zip,
    required this.Address,
    required this.Number,
    required this.District,
    required this.City,
    required this.State,
    required this.Complement,
    required this.Reference,
  });

  factory CustomerAdressesModel.fromJson(Map<String, dynamic> json) {
    return CustomerAdressesModel(
      Zip: json['Zip'],
      Address: json['Address'],
      Number: json['Number'],
      District: json['District'],
      City: json['City'],
      State: json['State'],
      Complement: json['Complement'],
      Reference: json['Reference'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Zip': Zip,
        'Address': Address,
        'Number': Number,
        'District': District,
        'City': City,
        'State': State,
        'Complement': Complement,
        'Reference': Reference,
      };
}

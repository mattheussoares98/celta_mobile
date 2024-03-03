import 'package:flutter/material.dart';

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

  static resultAsStringAddressCustomerModel({
    required Map data,
    required AddressModel? addressModel,
    required TextEditingController addressController,
    required TextEditingController districtController,
    required TextEditingController complementController,
    required TextEditingController cityController,
    required ValueNotifier<String?> selectedStateDropDown,
    required Map<String, String> states,
  }) {
    if (addressModel != null) {
      addressModel.Zip = data["cep"];
      addressModel.Address = data["logradouro"];
      addressModel.Complement = data["complemento"];
      addressModel.District = data["bairro"];
      addressModel.City = data["localidade"];
      addressModel.State = data["uf"];
    }

    addressController.text = data["logradouro"];
    complementController.text = data["complemento"];
    districtController.text = data["bairro"];
    cityController.text = data["localidade"];
    selectedStateDropDown.value = states[data["uf"]];
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
}

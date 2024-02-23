
import 'package:flutter/material.dart';

class CustomerRegisterCepModel {
  String? Zip; /*  "01001-000", */
  String? Address; /*  "Praça da Sé", */
  String? Complement; /*  "lado ímpar", */
  String? District; /*  "Sé", */
  String? City; /*  "São Paulo", */
  String? State; /*  "SP", */
  String? Reference;
  String? Number;

  CustomerRegisterCepModel({
    this.Zip,
    this.Address,
    this.Complement,
    this.District,
    this.City,
    this.State,
    this.Number,
    this.Reference,
  });

  static resultAsStringToCustomerRegisterCepModel({
    required Map data,
    required CustomerRegisterCepModel customerRegisterCepModel,
    required TextEditingController adressController,
    required TextEditingController districtController,
    required TextEditingController complementController,
    required TextEditingController cityController,
    required ValueNotifier<String?> selectedStateDropDown,
    required Map<String, String> states,
  }) {
    customerRegisterCepModel.Zip = data["cep"];

    customerRegisterCepModel.Address = data["logradouro"];
    adressController.text = data["logradouro"];

    customerRegisterCepModel.Complement = data["complemento"];
    complementController.text = data["complemento"];

    customerRegisterCepModel.District = data["bairro"];
    districtController.text = data["bairro"];

    customerRegisterCepModel.City = data["localidade"];
    cityController.text = data["localidade"];

    customerRegisterCepModel.State = data["uf"];
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

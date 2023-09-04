import 'package:flutter/material.dart';

class CustomerRegisterCepModel {
  String? zip; /*  "01001-000", */
  String? Address; /*  "Praça da Sé", */
  String? Complement; /*  "lado ímpar", */
  String? District; /*  "Sé", */
  String? City; /*  "São Paulo", */
  String? State; /*  "SP", */
  String? ibge; /*  "3550308", */
  String? gia; /*  "1004", */
  String? ddd; /*  "11", */
  String? siafi; /*  "7107" */
  String? reference;
  int? number;

  CustomerRegisterCepModel({
    this.zip,
    this.Address,
    this.Complement,
    this.District,
    this.City,
    this.State,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
    this.number,
    this.reference,
  });

  static resultAsStringToCustomerRegisterCepModel({
    required Map data,
    required CustomerRegisterCepModel customerRegisterCepModel,
    required TextEditingController adressController,
    required TextEditingController districtController,
    required TextEditingController complementController,
    required TextEditingController cityController,
    required TextEditingController stateController,
  }) {
    customerRegisterCepModel.zip = data["cep"];

    customerRegisterCepModel.Address = data["logradouro"];
    adressController.text = data["logradouro"];

    customerRegisterCepModel.Complement = data["complemento"];
    complementController.text = data["complemento"];

    customerRegisterCepModel.District = data["bairro"];
    districtController.text = data["bairro"];

    customerRegisterCepModel.City = data["localidade"];
    cityController.text = data["localidade"];

    customerRegisterCepModel.State = data["uf"];
    stateController.text = data["uf"];

    customerRegisterCepModel.ibge = data["ibge"];
    customerRegisterCepModel.gia = data["gia"];
    customerRegisterCepModel.ddd = data["ddd"];
    customerRegisterCepModel.siafi = data["siafi"];
  }
}

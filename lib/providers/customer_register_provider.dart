import 'dart:convert';

import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/Models/customer_register_models/customer_register_cep.dart';
import 'package:celta_inventario/api/requests_http.dart';
import 'package:flutter/material.dart';

class CustomerRegisterProvider with ChangeNotifier {
  List<String> _emails = [];
  List<String> get emails => [..._emails];
  int get emailsCount => _emails.length;

  static const List<String> _states = [
    "Acre",
    "Alagoas",
    "Amapá",
    "Amazonas",
    "Bahia",
    "Ceará",
    "Distrito Federal",
    "Espírito Santo",
    "Goiás",
    "Maranhão",
    "Mato Grosso",
    "Mato Grosso do Sul",
    "Minas Gerais",
    "Pará",
    "Paraíba",
    "Paraná",
    "Pernambuco",
    "Piauí",
    "Rio de Janeiro",
    "Rio Grande do Norte",
    "Rio Grande do Sul",
    "Rondônia",
    "Roraima",
    "Santa Catarina",
    "São Paulo",
    "Sergipe",
    "Tocantins"
  ];

  List<String> get states => [..._states];

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

  String _errorMessageGetAdressByCep = "";
  String get errorMessageGetAdressByCep => _errorMessageGetAdressByCep;

  CustomerRegisterCepModel _customerRegisterCepModel =
      CustomerRegisterCepModel();
  get customerRegisterCepModel => _customerRegisterCepModel;

  void addEmail({
    required BuildContext context,
    required TextEditingController emailController,
  }) {
    if (!_emails.contains(emailController.text)) {
      _emails.add(emailController.text);

      emailController.text = "";
    } else {
      ShowErrorMessage.showErrorMessage(
        error: "Esse e-mail já está na lista de e-mails",
        context: context,
      );
    }
    notifyListeners();
  }

  void removeEmail(int index) {
    _emails.removeAt(index);
    notifyListeners();
  }

  Future<void> getAddressByCep({
    required BuildContext context,
    required String cepControllerText,
    required TextEditingController adressController,
    required TextEditingController districtController,
    required TextEditingController complementController,
    required TextEditingController cityController,
    required TextEditingController stateController,
  }) async {
    _errorMessageGetAdressByCep = "";
    _isLoadingCep = true;
    _triedGetCep = true;
    notifyListeners();
    Map response = await RequestsHttp.get(
      url: "https://viacep.com.br/ws/$cepControllerText/json/",
    );

    if (response["error"] != "") {
      _errorMessageGetAdressByCep = response["error"];

      ShowErrorMessage.showErrorMessage(
        error:
            "Ocorreu um erro para consultar o CEP. Insira os dados do endereço manualmente",
        context: context,
      );
    } else {
      CustomerRegisterCepModel.resultAsStringToCustomerRegisterCepModel(
        data: json.decode(response["success"]),
        customerRegisterCepModel: _customerRegisterCepModel,
        adressController: adressController,
        districtController: districtController,
        complementController: complementController,
        cityController: cityController,
        stateController: stateController,
      );

      cepControllerText = _customerRegisterCepModel.Address ?? "";
    }

    _isLoadingCep = false;
    notifyListeners();
  }
}

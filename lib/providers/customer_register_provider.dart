import 'dart:convert';

import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/Models/customer_register_models/customer_register_cep.dart';
import 'package:celta_inventario/api/requests_http.dart';
import 'package:flutter/material.dart';

class CustomerRegisterProvider with ChangeNotifier {
  List<String> _emails = [];
  List<String> get emails => [..._emails];
  int get emailsCount => _emails.length;

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  bool _successToGetAdressByCep = false;
  bool get successToGetAdressByCep => _successToGetAdressByCep;

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

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
    _isLoadingCep = true;
    _successToGetAdressByCep = false;
    _triedGetCep = true;
    notifyListeners();
    Map response = await RequestsHttp.get(
      url: "https://viacep.com.br/ws/$cepControllerText/json/",
    );

    if (response["error"] != "") {
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

      _successToGetAdressByCep = true;
      cepControllerText = _customerRegisterCepModel.Address ?? "";
    }

    _isLoadingCep = false;
    notifyListeners();
  }
}

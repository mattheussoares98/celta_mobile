import 'dart:convert';

import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/Models/customer_register_models/customer_register_cep.dart';
import 'package:celta_inventario/api/requests_http.dart';
import 'package:flutter/material.dart';

class CustomerRegisterProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController reducedNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<String?> _selectedSexDropDown =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _selectedStateDropDown =
      ValueNotifier<String?>(null);

  ValueNotifier<String?> get selectedSexDropDown => _selectedSexDropDown;
  set selectedSexDropDown(ValueNotifier<String?> newValue) {
    _selectedSexDropDown.value = newValue.value;
  }

  ValueNotifier<String?> get selectedStateDropDown => _selectedStateDropDown;
  set selectedStateDropDown(ValueNotifier<String?> newValue) {
    _selectedStateDropDown.value = newValue.value;
  }

  List<String> _emails = [];
  List<String> get emails => [..._emails];
  int get emailsCount => _emails.length;

  List<CustomerRegisterCepModel> _adressess = [];
  List<CustomerRegisterCepModel> get adressess => [..._adressess];
  int get adressessCount => _adressess.length;

  List<String> _telephone = [];
  List<String> get telephone => [..._telephone];
  int get telephoneCount => _telephone.length;

  static const Map<String, String> _states = {
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

  List<String> get states {
    return [..._states.values];
  }

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

  String _errorMessageGetAdressByCep = "";
  String get errorMessageGetAdressByCep => _errorMessageGetAdressByCep;

  CustomerRegisterCepModel _customerRegisterCepModel =
      CustomerRegisterCepModel();
  get customerRegisterCepModel => _customerRegisterCepModel;

  void addAdress() {
    _adressess.add(CustomerRegisterCepModel(
      Address: adressController.text,
      City: cityController.text,
      Complement: complementController.text,
      District: districtController.text,
      number: int.parse(numberController.text),
      reference: referenceController.text,
      zip: cepController.text,
    ));
    adressController.text = "";
    cityController.text = "";
    complementController.text = "";
    districtController.text = "";
    numberController.text = "";
    referenceController.text = "";
    cepController.text = "";
    _selectedStateDropDown.value = null;
    notifyListeners();
  }

  void removeAdress(int index) {
    _adressess.removeAt(index);
    notifyListeners();
  }

  void clearAdressControllers() {
    adressController.text = "";
    cityController.text = "";
    complementController.text = "";
    districtController.text = "";
    numberController.text = "";
    referenceController.text = "";
    cepController.text = "";
    _selectedStateDropDown.value = null;
    notifyListeners();
  }

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

  void clearEmailController() {
    emailController.text = "";
    notifyListeners();
  }

  Future<void> getAddressByCep({
    required BuildContext context,
  }) async {
    _errorMessageGetAdressByCep = "";
    _isLoadingCep = true;
    _triedGetCep = true;
    notifyListeners();
    Map response = await RequestsHttp.get(
      url: "https://viacep.com.br/ws/${cepController.text}/json/",
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
        selectedStateDropDown: _selectedStateDropDown,
        states: _states,
      );
    }

    _isLoadingCep = false;
    notifyListeners();
  }
}

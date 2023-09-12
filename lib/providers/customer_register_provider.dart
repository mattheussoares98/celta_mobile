import 'dart:convert';

import 'package:celta_inventario/Components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/Models/customer_register_models/customer_register_cep.dart';
import 'package:celta_inventario/api/requests_http.dart';
import 'package:celta_inventario/api/soap_helper.dart';
import 'package:celta_inventario/utils/default_error_message_to_find_server.dart';
import 'package:celta_inventario/utils/user_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController dddController = TextEditingController();
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

  List<CustomerRegisterCepModel> _adresses = [];
  List<CustomerRegisterCepModel> get adresses => [..._adresses];
  int get adressesCount => _adresses.length;

  List<Map<String, String>> _telephones = [];
  List<Map<String, String>> get telephones => [..._telephones];
  int get telephonesCount => _telephones.length;

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

  List<String> get states => [..._states.values];

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

  String _errorMessageGetAdressByCep = "";
  String get errorMessageGetAdressByCep => _errorMessageGetAdressByCep;

  String _errorMessageAddEmail = "";
  String get errorMessageAddEmail => _errorMessageAddEmail;

  String _errorMessageAddTelephone = "";
  String get errorMessageAddTelephone => _errorMessageAddTelephone;

  CustomerRegisterCepModel _customerRegisterCepModel =
      CustomerRegisterCepModel();
  get customerRegisterCepModel => _customerRegisterCepModel;

  Map<String, dynamic> _jsonInsertCustomer = {};

  String _errorMessageInsertCustomer = "";
  String get errorMessageInsertCustomer => _errorMessageInsertCustomer;

  bool _isLoadingInsertCustomer = false;
  bool get isLoadingInsertCustomer => _isLoadingInsertCustomer;

  String _getKeyByValue(String value) {
    for (var entry in _states.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return "null"; // Valor não encontrado
  }

  void addAdress() {
    _adresses.add(CustomerRegisterCepModel(
      Address: adressController.text,
      City: cityController.text,
      Complement: complementController.text,
      District: districtController.text,
      Number: numberController.text,
      Reference: referenceController.text,
      Zip: cepController.text,
      State: _getKeyByValue(selectedStateDropDown.value!),
    ));

    adressController.text = "";
    cityController.text = "";
    complementController.text = "";
    districtController.text = "";
    numberController.text = "";
    referenceController.text = "";
    cepController.text = "";
    _selectedStateDropDown.value = null;
    _triedGetCep = false; //para deixar somente o campo de CEP aberto
    notifyListeners();
  }

  void removeAdress(int index) {
    _adresses.removeAt(index);
    notifyListeners();
  }

  void clearAdressControllers({bool? clearCep = true}) {
    if (clearCep == true) {
      cepController.text = "";
    }
    adressController.text = "";
    cityController.text = "";
    complementController.text = "";
    districtController.text = "";
    numberController.text = "";
    referenceController.text = "";
    _selectedStateDropDown.value = null;
    _triedGetCep = false; //para deixar somente o campo de CEP aberto
    notifyListeners();
  }

  void clearEmailControllers() {
    emailController.text = "";
  }

  void clearTelephoneControllers() {
    telephoneController.text = "";
    dddController.text = "";
  }

  void addEmail() {
    _errorMessageAddEmail = "";
    if (!_emails.contains(emailController.text)) {
      _emails.add(emailController.text);

      emailController.text = "";
      notifyListeners();
    } else {
      _errorMessageAddEmail = "Esse e-mail já existe na lista de e-mails!";
    }
    notifyListeners();
  }

  void addTelephone() {
    _errorMessageAddTelephone = "";
    Map<String, String> newTelephone = {
      "AreaCode": dddController.text,
      "PhoneNumber": telephoneController.text,
    };

    bool hasEqualTelephone = false;
    _telephones.forEach((element) {
      if (element["AreaCode"] == newTelephone["AreaCode"] &&
          element["PhoneNumber"] == newTelephone["PhoneNumber"]) {
        hasEqualTelephone = true;
      }
    });

    if (!hasEqualTelephone) {
      _telephones.add(newTelephone);
      clearTelephoneControllers();
    } else {
      _errorMessageAddTelephone =
          "Esse telefone já existe na lista de telefones!";
    }
    notifyListeners();
  }

  void removeEmail(int index) {
    _emails.removeAt(index);
    notifyListeners();
  }

  void removeTelephone(int index) {
    _telephones.removeAt(index);
    notifyListeners();
  }

  void _clearAllDataInformed() {
    clearPersonalDataControllers();
    clearAdressControllers(clearCep: true);
    clearEmailControllers();
    clearTelephoneControllers();

    _adresses.clear();
    _emails.clear();
    _telephones.clear();

    notifyListeners();
  }

  Future<void> getAddressByCep({
    required BuildContext context,
  }) async {
    clearAdressControllers(clearCep: false);
    _errorMessageGetAdressByCep = "";
    _isLoadingCep = true;
    notifyListeners();
    Map response = await RequestsHttp.get(
      url: "https://viacep.com.br/ws/${cepController.text}/json/",
    );

    _triedGetCep = true;
    notifyListeners();

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

  String _formatDate() {
    DateFormat inputFormat = DateFormat("dd/MM/yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.");

    DateTime date = inputFormat.parse(dateOfBirthController.text);
    String formatedDate = outputFormat.format(date);
    return formatedDate;
  }

  // void clearSelectedSexDropDown() {
  //   selectedSexDropDown.value = null;
  // }

  void clearPersonalDataControllers() {
    nameController.text = "";
    reducedNameController.text = "";
    cpfCnpjController.text = "";
    dateOfBirthController.text = "";
    selectedSexDropDown.value = null;
    notifyListeners();
  }

  void _updateJsonInsertCustomer() {
    _jsonInsertCustomer.clear();
    _jsonInsertCustomer["Name"] = nameController.text;
    _jsonInsertCustomer["ReducedName"] = reducedNameController.text;
    _jsonInsertCustomer["CpfCnpjNumber"] = cpfCnpjController.text;
    _jsonInsertCustomer["PersonType"] =
        cpfCnpjController.text.length == 11 ? "F" : "J";
    _jsonInsertCustomer["RegistrationNumber"] = "";
    if (dateOfBirthController.text != "") {
      String formatedDate = _formatDate();

      _jsonInsertCustomer["DateOfBirth"] = formatedDate;
    }

    if (selectedSexDropDown.value != null) {
      _jsonInsertCustomer["SexType"] =
          selectedSexDropDown.value!.substring(0, 1).toUpperCase();
    }
    _jsonInsertCustomer["Emails"] = _emails;
    _jsonInsertCustomer["Telephones"] = _telephones;
    _jsonInsertCustomer["Addresses"] =
        _adresses.map((address) => address.toJson()).toList();
    _jsonInsertCustomer["Covenants"] = null;
  }

  changeIsLoadingInsertCustomer() {
    _isLoadingInsertCustomer = false;
  }

  Future<void> insertCustomer() async {
    _isLoadingInsertCustomer = true;
    _errorMessageInsertCustomer = "";
    notifyListeners();

    try {
      _updateJsonInsertCustomer();
      String jsonInsertCustomerEncoded = json.encode(_jsonInsertCustomer);
      await SoapHelper.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "json": jsonInsertCustomerEncoded,
        },
        typeOfResponse: "InsertUpdateCustomerResponse",
        SOAPAction: "InsertUpdateCustomer",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "InsertUpdateCustomerResult",
      );

      _errorMessageInsertCustomer = SoapHelperResponseParameters.errorMessage;

      if (_errorMessageInsertCustomer == "") {
        _clearAllDataInformed();
      }
    } catch (e) {
      print('Erro para cadastrar o cliente: $e');
      _errorMessageInsertCustomer =
          DefaultErrorMessageToFindServer.ERROR_MESSAGE;
    } finally {}
    _isLoadingInsertCustomer = false;
    notifyListeners();
  }
}

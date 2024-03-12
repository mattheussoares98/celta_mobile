import 'dart:convert';
import 'package:celta_inventario/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';
import '../utils/utils.dart';
import './address_provider.dart';

class CustomerRegisterProvider with ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cpfCnpjController = TextEditingController();
  final TextEditingController reducedNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController dddController = TextEditingController();
  final ValueNotifier<String?> _selectedSexDropDown =
      ValueNotifier<String?>(null);

  ValueNotifier<String?> get selectedSexDropDown => _selectedSexDropDown;
  set selectedSexDropDown(ValueNotifier<String?> newValue) {
    _selectedSexDropDown.value = newValue.value;
  }

  List<String> _emails = [];
  List<String> get emails => [..._emails];
  int get emailsCount => _emails.length;

  List<Map<String, String>> _telephones = [];
  List<Map<String, String>> get telephones => [..._telephones];
  int get telephonesCount => _telephones.length;

  bool _personFormKeyIsValid = false;
  bool get personFormKeyIsValid => _personFormKeyIsValid;
  set personFormKeyIsValid(bool newValue) {
    _personFormKeyIsValid = newValue;
  }

  bool _emailFormKeyIsValid = false;
  bool get emailFormKeyIsValid => _emailFormKeyIsValid;
  set emailFormKeyIsValid(bool newValue) {
    _emailFormKeyIsValid = newValue;
  }

  bool _telephoneFormKeyIsValid = false;
  bool get telephoneFormKeyIsValid => _telephoneFormKeyIsValid;
  set telephoneFormKeyIsValid(bool newValue) {
    _telephoneFormKeyIsValid = newValue;
  }

  String _errorMessageAddEmail = "";
  String get errorMessageAddEmail => _errorMessageAddEmail;

  String _errorMessageAddTelephone = "";
  String get errorMessageAddTelephone => _errorMessageAddTelephone;

  Map<String, dynamic> _jsonInsertCustomer = {};

  String _errorMessageInsertCustomer = "";
  String get errorMessageInsertCustomer => _errorMessageInsertCustomer;

  bool _isLoadingInsertCustomer = false;
  bool get isLoadingInsertCustomer => _isLoadingInsertCustomer;

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

  void clearAllDataInformed(AddressProvider addressProvider) {
    clearPersonalDataControllers();
    clearEmailControllers();
    clearTelephoneControllers();

    addressProvider.clearAddressControllers(clearCep: true);
    addressProvider.clearAddresses();
    _emails.clear();
    _telephones.clear();

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

  void _updateJsonInsertCustomer(AddressProvider addressProvider) {
    _jsonInsertCustomer.clear();
    _jsonInsertCustomer = {
      "Name": nameController.text,
      "ReducedName": reducedNameController.text,
      "CpfCnpjNumber": cpfCnpjController.text,
      "PersonType": cpfCnpjController.text.length == 11 ? "F" : "J",
      "RegistrationNumber": "",
      "SexType": selectedSexDropDown.value != null
          ? selectedSexDropDown.value!.substring(0, 1).toUpperCase()
          : "M",
      "Emails": _emails,
      "Telephones": _telephones,
      "Addresses": addressProvider.addresses.map((e) => e.toJson()).toList(),
      "Covenants": null,
    };
    if (dateOfBirthController.text != "") {
      _jsonInsertCustomer["DateOfBirth"] = _formatDate();
    }
  }

  changeIsLoadingInsertCustomer() {
    _isLoadingInsertCustomer = false;
  }

  Future<void> insertCustomer(AddressProvider addressProvider) async {
    _isLoadingInsertCustomer = true;
    _errorMessageInsertCustomer = "";
    notifyListeners();

    try {
      _updateJsonInsertCustomer(addressProvider);
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
        clearAllDataInformed(addressProvider);
        FirebaseHelper.addSoapCallInFirebase(
            firebaseCallEnum: FirebaseCallEnum.customerRegister);
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

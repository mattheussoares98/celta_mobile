import 'dart:convert';
import '../Models/models.dart';
import '../components/components.dart';
import '../providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/api.dart';
import '../utils/utils.dart';
import './address_provider.dart';

class CustomerRegisterProvider with ChangeNotifier {
  CustomerModel? _customer;
  CustomerModel? get customer => _customer;

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

  List<CustomerRegisterCovenantModel> _covenants = [];
  List<CustomerRegisterCovenantModel> get covenants => [..._covenants];

  List<CustomerRegisterBindedCovenantModel> _bindedCovenants = [];
  List<CustomerRegisterBindedCovenantModel> get bindedCovenants =>
      [..._bindedCovenants];

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

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void clearTelephoneControllers({
    required TextEditingController telephoneController,
    required TextEditingController dddController,
  }) {
    telephoneController.text = "";
    dddController.text = "";
  }

  void addEmail(TextEditingController emailController) {
    _errorMessage = "";
    if (!_emails.contains(emailController.text)) {
      _emails.add(emailController.text);

      emailController.text = "";
      notifyListeners();
    } else {
      _errorMessage = "Esse e-mail já existe na lista de e-mails!";
    }
    notifyListeners();
  }

  void addTelephone({
    required TextEditingController telephoneController,
    required TextEditingController dddController,
  }) {
    _errorMessage = "";

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
      clearTelephoneControllers(
        telephoneController: telephoneController,
        dddController: dddController,
      );
    } else {
      _errorMessage = "Esse telefone já existe na lista de telefones!";
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

  void clearAllDataInformed({
    required AddressProvider addressProvider,
    required TextEditingController emailController,
    required TextEditingController telephoneController,
    required TextEditingController dddController,
    required TextEditingController nameController,
    required TextEditingController reducedNameController,
    required TextEditingController cpfCnpjController,
    required TextEditingController dateOfBirthController,
    required TextEditingController passwordController,
    required TextEditingController passwordConfirmationController,
  }) {
    nameController.clear();
    reducedNameController.clear();
    cpfCnpjController.clear();
    dateOfBirthController.clear();
    emailController.clear();
    telephoneController.clear();
    dddController.clear();
    addressProvider.clearAddressControllers(clearCep: true);
    addressProvider.clearAddresses();
    _emails.clear();
    _telephones.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    _selectedSexDropDown.value = null;
    _covenants.clear();
    _bindedCovenants.clear();

    notifyListeners();
  }

  String _formatDate(TextEditingController dateOfBirthController) {
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
    //TODO remove this function
    selectedSexDropDown.value = null;
    notifyListeners();
  }

  Map<String, dynamic> _getJsonInsertCustomer({
    required AddressProvider addressProvider,
    required TextEditingController nameController,
    required TextEditingController reducedNameController,
    required TextEditingController cpfCnpjController,
    required TextEditingController dateOfBirthController,
    required TextEditingController passwordController,
  }) {
    Map<String, dynamic> _jsonInsertCustomer = {
      "Name": nameController.text,
      "ReducedName": reducedNameController.text,
      "CpfCnpjNumber": cpfCnpjController.text,
      "Password": passwordController.text,
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
    if (_bindedCovenants.isNotEmpty) {
      _jsonInsertCustomer["CustomerCovenants"] = _bindedCovenants
          .map(
            (e) => CustomerRegisterCustomerCovenantModel(
              Code: e.customerRegisterCovenantModel.Codigo_Convenio!.toInt(),
              Matriculate: "99",
              LimitOfPurchase: e.limit,
            ).toJson(),
          )
          .toList();
    }
    if (dateOfBirthController.text != "") {
      _jsonInsertCustomer["DateOfBirth"] = _formatDate(dateOfBirthController);
    }

    return _jsonInsertCustomer;
  }

  void changeIsLoadingInsertCustomer() {
    _isLoading = false;
  }

  Future<void> insertCustomer({
    required AddressProvider addressProvider,
    required TextEditingController nameController,
    required TextEditingController reducedNameController,
    required TextEditingController cpfCnpjController,
    required TextEditingController dateOfBirthController,
    required TextEditingController emailController,
    required TextEditingController telephoneController,
    required TextEditingController dddController,
    required TextEditingController passwordController,
    required TextEditingController passwordConfirmationController,
  }) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final jsonInsertCustomer = _getJsonInsertCustomer(
        addressProvider: addressProvider,
        nameController: nameController,
        reducedNameController: reducedNameController,
        cpfCnpjController: cpfCnpjController,
        dateOfBirthController: dateOfBirthController,
        passwordController: passwordController,
      );

      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "json": json.encode(jsonInsertCustomer),
        },
        typeOfResponse: "InsertUpdateCustomerResponse",
        SOAPAction: "InsertUpdateCustomer",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "InsertUpdateCustomerResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage == "") {
        clearAllDataInformed(
          addressProvider: addressProvider,
          emailController: emailController,
          telephoneController: telephoneController,
          dddController: dddController,
          nameController: nameController,
          reducedNameController: reducedNameController,
          cpfCnpjController: cpfCnpjController,
          dateOfBirthController: dateOfBirthController,
          passwordController: passwordController,
          passwordConfirmationController: passwordConfirmationController,
        );
        FirebaseHelper.addSoapCallInFirebase(FirebaseCallEnum.customerRegister);
      }
    } catch (e) {
      //print('Erro para cadastrar o cliente: $e');
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCovenants() async {
    if (_covenants.isNotEmpty) {
      //não precisa consultar novamente se já houver dados
      return;
    }
    _isLoading = true;
    _errorMessage = "";
    _covenants.clear();
    notifyListeners();

    try {
      await SoapRequest.soapPost(
        parameters: {
          "crossIdentity": UserData.crossIdentity,
          "covenantData": "%",
          "covenantDataType": 3, //approximate name
        },
        typeOfResponse: "GetCovenantJsonResponse",
        SOAPAction: "GetCovenantJson",
        serviceASMX: "CeltaCustomerService.asmx",
        typeOfResult: "GetCovenantJsonResult",
      );

      _errorMessage = SoapRequestResponse.errorMessage;

      if (_errorMessage == "") {
        CustomerRegisterCovenantModel.responseAsStringToModel(
          listToAdd: _covenants,
          response: SoapRequestResponse.responseAsString,
        );
      }
    } catch (e) {
      _errorMessage = DefaultErrorMessage.ERROR;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void bindCovenant({
    required int index,
    required double limit,
  }) {
    final covenant = _covenants[index];
    _bindedCovenants.add(CustomerRegisterBindedCovenantModel(
      customerRegisterCovenantModel: covenant,
      limit: limit,
    ));
    _covenants.removeAt(index);
    notifyListeners();
  }

  void unbindCovenant(int index) {
    final bindedCovenant =
        _bindedCovenants[index].customerRegisterCovenantModel;
    _covenants.add(bindedCovenant);
    _bindedCovenants.removeAt(index);
    notifyListeners();
  }

  Future<void> getCustomer(String cpfCnpjText) async {
    _isLoading = true;
    _errorMessage = "";
    _customer = null;
    notifyListeners();

    try {
      _customer = await SoapHelper.getCustomer(
        searchTypeInt: 1, //cpf/cnpj
        controllerText: cpfCnpjText,
        enterpriseCode: "1", //TODO test if always work
      );
    } catch (e) {
      debugPrint(SoapRequestResponse.errorMessage);
      _errorMessage = SoapRequestResponse.errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool addAddress(AddressModel address) {
    if (_customer?.Addresses
            ?.where((e) => e.Zip == address.Zip && e.Number == address.Number)
            .isEmpty ==
        false) {
      ShowSnackbarMessage.show(
        message: "Esse endereço já foi adicionado",
        context: NavigatorKey.navigatorKey.currentState!.context,
      );
      return false;
    }

    final oldCustomer = _customer;

    _customer = CustomerModel(
      Addresses: [
        ...oldCustomer?.Addresses ?? [],
        address,
      ],
      Name: oldCustomer?.Name ?? "",
      Code: oldCustomer?.Code,
      PersonalizedCode: oldCustomer?.PersonalizedCode,
      ReducedName: oldCustomer?.ReducedName,
      CpfCnpjNumber: oldCustomer?.CpfCnpjNumber ?? "",
      RegistrationNumber: oldCustomer?.RegistrationNumber,
      DateOfBirth: oldCustomer?.DateOfBirth,
      SexType: oldCustomer?.SexType ?? "M",
      PersonType: oldCustomer?.PersonType ?? "M",
      Emails: oldCustomer?.Emails,
      Telephones: oldCustomer?.Telephones,
      selected: oldCustomer?.selected == true,
      CustomerCovenants: oldCustomer?.CustomerCovenants,
      password: oldCustomer?.password,
    );
    notifyListeners();
    return true;
  }

  void removeAddress(AddressModel address) {
    if (_customer?.Addresses?.isEmpty == true) {
      debugPrint("Não deveria estar vazio");
      return;
    }
    _customer?.Addresses!.removeWhere((e) => e == address);
    notifyListeners();
  }
}

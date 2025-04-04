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
  int get emailsCount => _emails.length; //TODO remove this

  List<Map<String, String>> _telephones = []; //TODO remove this
  List<Map<String, String>> get telephones => [..._telephones];
  int get telephonesCount => _telephones.length;

  List<CustomerRegisterCovenantModel> _covenants = []; //TODO remove this
  List<CustomerRegisterCovenantModel> get covenants => [..._covenants];

  List<CustomerRegisterBindedCovenantModel> _bindedCovenants =
      []; //TODO remove this
  List<CustomerRegisterBindedCovenantModel> get bindedCovenants =>
      [..._bindedCovenants];

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
    _errorMessage = ""; //TODO change this function
    if (!_emails.contains(emailController.text)) {
      _emails.add(emailController.text);

      emailController.text = "";
      notifyListeners();
    } else {
      _errorMessage = "Esse e-mail já existe na lista de e-mails!";
    }
    notifyListeners();
  }

  bool addTelephone({
    required String phoneNumber,
    required String areaCode,
  }) {
    final newTelephone = CustomerTelephoneModel(
      AreaCode: areaCode,
      PhoneNumber: phoneNumber,
    );

    if (_customer?.Telephones
            ?.where((e) =>
                e.AreaCode == newTelephone.AreaCode &&
                e.PhoneNumber == newTelephone.PhoneNumber)
            .isNotEmpty ==
        true) {
      ShowSnackbarMessage.show(
          message: "Esse telefone já foi inserido!",
          context: NavigatorKey.key.currentState!.context);
      return false;
    }
    final oldCustomer = _customer;

    _customer = CustomerModel(
      Telephones: [
        ...oldCustomer?.Telephones ?? [],
        newTelephone,
      ],
      Name: oldCustomer?.Name,
      Code: oldCustomer?.Code,
      PersonalizedCode: oldCustomer?.PersonalizedCode,
      ReducedName: oldCustomer?.ReducedName,
      CpfCnpjNumber: oldCustomer?.CpfCnpjNumber,
      RegistrationNumber: oldCustomer?.RegistrationNumber,
      DateOfBirth: oldCustomer?.DateOfBirth,
      SexType: oldCustomer?.SexType,
      PersonType: oldCustomer?.PersonType,
      Emails: oldCustomer?.Emails,
      Addresses: oldCustomer?.Addresses,
      selected: oldCustomer?.selected == true,
      password: oldCustomer?.password,
      CustomerCovenants: oldCustomer?.CustomerCovenants,
    );

    notifyListeners();

    return true;
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
    required CustomerRegisterCovenantModel covenant,
    required double limit,
  }) {
    final oldCustomer = _customer;
    _customer = CustomerModel(
      CustomerCovenants: [
        ..._customer?.CustomerCovenants ?? [],
        CustomerCovenantModel(
          covenant: CovenantModel(
            Code: covenant.Codigo_Convenio?.toInt(),
            PersonalizedCode: covenant.CodigoLegado_Convenio?.toString(),
            Name: covenant.Nome_Convenio,
          ),
          Matriculate: "99",
          LimitOfPurchase: limit,
          isSelected: true,
        )
      ],
      Name: oldCustomer?.Name,
      Code: oldCustomer?.Code,
      PersonalizedCode: oldCustomer?.PersonalizedCode,
      ReducedName: oldCustomer?.ReducedName,
      CpfCnpjNumber: oldCustomer?.CpfCnpjNumber,
      RegistrationNumber: oldCustomer?.RegistrationNumber,
      DateOfBirth: oldCustomer?.DateOfBirth,
      SexType: oldCustomer?.SexType,
      PersonType: oldCustomer?.PersonType,
      Emails: oldCustomer?.Emails,
      Telephones: oldCustomer?.Telephones,
      Addresses: oldCustomer?.Addresses,
      selected: oldCustomer?.selected == true,
      password: oldCustomer?.password,
    );

    notifyListeners();
  }

  void unbindCovenant(int index) {
    final oldCustomer = _customer;
    oldCustomer?.CustomerCovenants?.removeAt(index);

    _customer = CustomerModel(
      Name: oldCustomer?.Name,
      Code: oldCustomer?.Code,
      PersonalizedCode: oldCustomer?.PersonalizedCode,
      ReducedName: oldCustomer?.ReducedName,
      CpfCnpjNumber: oldCustomer?.CpfCnpjNumber,
      RegistrationNumber: oldCustomer?.RegistrationNumber,
      DateOfBirth: oldCustomer?.DateOfBirth,
      SexType: oldCustomer?.SexType,
      PersonType: oldCustomer?.PersonType,
      Emails: oldCustomer?.Emails,
      Telephones: oldCustomer?.Telephones,
      Addresses: oldCustomer?.Addresses,
      selected: oldCustomer?.selected == true,
      password: oldCustomer?.password,
      CustomerCovenants: oldCustomer?.CustomerCovenants,
    );
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
        context: NavigatorKey.key.currentState!.context,
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

  void changePersonalData({
    required String cpfCnpj,
    required String name,
    required String sexType,
    String? reducedName,
    DateTime? birthDate,
    String? password,
  }) {
    final oldCustomer = _customer;
    _customer = CustomerModel(
      CpfCnpjNumber: cpfCnpj,
      Name: name,
      SexType: sexType,
      ReducedName: reducedName,
      DateOfBirth: birthDate?.toIso8601String(),
      password: password,
      Addresses: oldCustomer?.Addresses,
      Code: oldCustomer?.Code,
      PersonalizedCode: oldCustomer?.PersonalizedCode,
      RegistrationNumber: oldCustomer?.RegistrationNumber,
      PersonType: oldCustomer?.PersonType ?? "F",
      Emails: oldCustomer?.Emails,
      Telephones: oldCustomer?.Telephones,
      selected: oldCustomer?.selected == true,
      CustomerCovenants: oldCustomer?.CustomerCovenants,
    );
    notifyListeners();
  }
}

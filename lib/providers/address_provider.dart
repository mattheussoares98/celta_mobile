import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/global_widgets/global_widgets.dart';
import '../models/address/address.dart';

class AddressProvider with ChangeNotifier {
  final TextEditingController cepController = TextEditingController();
  final TextEditingController adressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  List<AddressModel> _addresses = [];
  List<AddressModel> get addresses => [..._addresses];
  int get addressesCount => _addresses.length;

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

  ValueNotifier<String?> get selectedStateDropDown => _selectedStateDropDown;
  set selectedStateDropDown(ValueNotifier<String?> newValue) {
    _selectedStateDropDown.value = newValue.value;
  }

  bool _adressFormKeyIsValid = false;
  bool get adressFormKeyIsValid => _adressFormKeyIsValid;
  set adressFormKeyIsValid(bool newValue) {
    _adressFormKeyIsValid = newValue;
  }

  List<String> get states => [..._states.values];

  String _errorMessageGetAdressByCep = "";
  String get errorMessageGetAdressByCep => _errorMessageGetAdressByCep;

  final ValueNotifier<String?> _selectedStateDropDown =
      ValueNotifier<String?>(null);

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  String _errorMessageAddAddres = "";
  String get errorMessageAddAddres => _errorMessageAddAddres;

  void clearAdressControllers({required bool clearCep}) {
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

  String _getKeyByValue(String value) {
    for (var entry in _states.entries) {
      if (entry.value == value) {
        return entry.key;
      }
    }
    return "null"; // Valor não encontrado
  }

  void addAdress() {
    _errorMessageAddAddres = "";
    _addresses.forEach((element) {
      if (element.Zip == cepController.text &&
          element.Number == numberController.text) {
        _errorMessageAddAddres = "Já existe um endereço com esse CEP e número!";
      }
    });

    if (_errorMessageAddAddres == "") {
      _addresses.add(AddressModel(
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
    }
    notifyListeners();
  }

  void removeAdress(int index) {
    _addresses.removeAt(index);
    notifyListeners();
  }

  AddressModel? _addressCustomerModel;
  get addressCustomerModel => _addressCustomerModel;

  void clearAddresses() {
    _addresses.clear();
  }

  Future<void> getAddressByCep({
    required BuildContext context,
  }) async {
    clearAdressControllers(clearCep: false);
    _errorMessageGetAdressByCep = "";
    _isLoadingCep = true;
    notifyListeners();

    try {
      Map response = await RequestsHttp.get(
        url: "https://viacep.com.br/ws/${cepController.text}/json/",
      );

      _triedGetCep = true;
      notifyListeners();

      if (response["error"] != "") {
        _errorMessageGetAdressByCep = response["error"];

        ShowSnackbarMessage.showMessage(
          message:
              "Ocorreu um erro para consultar o CEP. Insira os dados do endereço manualmente",
          context: context,
        );
      } else {
        AddressModel.resultAsStringAdressCustomerModel(
          data: json.decode(response["success"]),
          addressModel: _addressCustomerModel,
          adressController: adressController,
          districtController: districtController,
          complementController: complementController,
          cityController: cityController,
          selectedStateDropDown: _selectedStateDropDown,
          states: _states,
        );
      }
    } catch (e) {
      print("Erro para consultar o CEP: $e");
      _errorMessageGetAdressByCep =
          "Ocorreu um erro para consultar o CEP. Insira os dados do endereço manualmente";
    }

    _isLoadingCep = false;
    notifyListeners();
  }
}

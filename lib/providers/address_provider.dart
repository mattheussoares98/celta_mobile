import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api.dart';
import '../components/components.dart';
import '../Models/address/address.dart';

class AddressProvider with ChangeNotifier {
  final TextEditingController cepController = TextEditingController(); //TODO remove all
  final TextEditingController addressController = TextEditingController(); //TODO remove all
  final TextEditingController districtController = TextEditingController(); //TODO remove all
  final TextEditingController complementController = TextEditingController(); //TODO remove all
  final TextEditingController referenceController = TextEditingController(); //TODO remove all
  final TextEditingController cityController = TextEditingController(); //TODO remove all
  final TextEditingController numberController = TextEditingController(); //TODO remove all

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

  bool _addressFormKeyIsValid = false;
  bool get addressFormKeyIsValid => _addressFormKeyIsValid;
  set addressFormKeyIsValid(bool newValue) {
    _addressFormKeyIsValid = newValue;
  }

  List<String> get states => [..._states.values];

  String _errorMessageGetAddressByCep = "";
  String get errorMessageGetAddressByCep => _errorMessageGetAddressByCep;

  final ValueNotifier<String?> _selectedStateDropDown =
      ValueNotifier<String?>(null);

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  String _errorMessageAddAddres = "";
  String get errorMessageAddAddres => _errorMessageAddAddres;

  void clearAddressControllers({required bool clearCep}) {
    if (clearCep == true) {
      cepController.text = "";
    }

    addressController.text = "";
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

  void addAddress({AddressModel? addressModel}) {
    _errorMessageAddAddres = "";
    _addresses.forEach((element) {
      if (element.Zip == cepController.text &&
          element.Number == numberController.text) {
        _errorMessageAddAddres = "Já existe um endereço com esse CEP e número!";
      }
    });

    if (_errorMessageAddAddres == "") {
      if (addressModel != null) {
        _addresses.add(addressModel);
      } else {
        _addresses.add(AddressModel(
          Address: addressController.text,
          City: cityController.text,
          Complement: complementController.text,
          District: districtController.text,
          Number: numberController.text,
          Reference: referenceController.text,
          Zip: cepController.text,
          State: _getKeyByValue(selectedStateDropDown.value!),
        ));
      }

      addressController.text = "";
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

  void removeAddress(int index) {
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
    required String cep,
  }) async {
    clearAddressControllers(clearCep: false);
    _errorMessageGetAddressByCep = "";
    _isLoadingCep = true;
    notifyListeners();

    try {
      Map response = await RequestsHttp.get(
        url: "https://viacep.com.br/ws/$cep/json/",
      );

      _triedGetCep = true;
      notifyListeners();

      if (response["error"] != "") {
        _errorMessageGetAddressByCep = response["error"];

        ShowSnackbarMessage.show(
          message:
              "Ocorreu um erro para consultar o CEP. Insira os dados do endereço manualmente",
          context: context,
        );
      } else {
        AddressModel.resultAsStringAddressCustomerModel(
          data: json.decode(response["success"]),
          addressModel: _addressCustomerModel,
          addressController: addressController,
          districtController: districtController,
          complementController: complementController,
          cityController: cityController,
          selectedStateDropDown: _selectedStateDropDown,
          states: _states,
        );
      }
    } catch (e) {
      //print("Erro para consultar o CEP: $e");
      _errorMessageGetAddressByCep =
          "Ocorreu um erro para consultar o CEP. Insira os dados do endereço manualmente";
    }

    _isLoadingCep = false;
    notifyListeners();
  }
}

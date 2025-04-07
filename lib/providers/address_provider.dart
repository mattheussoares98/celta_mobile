import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../api/api.dart';
import '../components/components.dart';
import '../Models/address/address.dart';

class AddressProvider with ChangeNotifier {
  List<AddressModel> _addresses = []; //TODO remove this
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

  bool _addressFormKeyIsValid = false;
  bool get addressFormKeyIsValid => _addressFormKeyIsValid;
  set addressFormKeyIsValid(bool newValue) {
    _addressFormKeyIsValid = newValue;
  }

  List<String> get states => [..._states.values];

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  bool _triedGetCep = false;
  bool get triedGetCep => _triedGetCep;

  bool _isLoadingCep = false;
  bool get isLoadingCep => _isLoadingCep;

  String _errorMessageAddAddres = "";
  String get errorMessageAddAddres => _errorMessageAddAddres;

  // String _getKeyByValue(String value) {
  //   for (var entry in _states.entries) {
  //     if (entry.value == value) {
  //       return entry.key;
  //     }
  //   }
  //   return "null"; // Valor não encontrado
  // }

  // void addAddress({AddressModel? addressModel}) {
  //   _errorMessageAddAddres = "";
  //   _addresses.forEach((element) {
  //     if (element.Zip == cepController.text &&
  //         element.Number == numberController.text) {
  //       _errorMessageAddAddres = "Já existe um endereço com esse CEP e número!";
  //     }
  //   });

  //   if (_errorMessageAddAddres == "") {
  //     if (addressModel != null) {
  //       _addresses.add(addressModel);
  //     } else {
  //       _addresses.add(AddressModel(
  //         Address: addressController.text,
  //         City: cityController.text,
  //         Complement: complementController.text,
  //         District: districtController.text,
  //         Number: numberController.text,
  //         Reference: referenceController.text,
  //         Zip: cepController.text,
  //         State: _getKeyByValue(selectedStateDropDown.value!),
  //       ));
  //     }
  //   }
  //   notifyListeners();
  // }

  void removeAddress(int index) {
    _addresses.removeAt(index);
    notifyListeners();
  }

  AddressModel? _addressCustomerModel;
  get addressCustomerModel => _addressCustomerModel;

  void clearAddresses() {
    _addresses.clear();
  }

  Future<AddressModel?> getAddressByCep({
    required BuildContext context,
    required String cep,
  }) async {
    _errorMessage = "";
    _isLoadingCep = true;
    notifyListeners();

    try {
      Map response = await RequestsHttp.get(
        url: "https://viacep.com.br/ws/$cep/json/",
      );

      _triedGetCep = true;
      notifyListeners();

      if (response["error"] != "") {
        _errorMessage = response["error"];
        throw Exception();
      } else {
        final decoded = json.decode(response["success"]
            .toString()
            .removeBreakLines()
            .removeWhiteSpaces());
        if (decoded.toString().contains("erro")) {
          throw Exception();
        }

        return AddressModel.fromViaCepJson(
          data: json.decode(response["success"]),
          states: _states,
        );
      }
    } catch (e) {
      //print("Erro para consultar o CEP: $e");
      ShowSnackbarMessage.show(
        message:
            "Ocorreu um erro para consultar o CEP. Insira os dados do endereço manualmente",
        context: context,
      );
      return null;
    } finally {
      _isLoadingCep = false;
      notifyListeners();
    }
  }
}

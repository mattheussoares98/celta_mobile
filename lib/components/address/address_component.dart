import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Pages/customer_register/customer_register.dart';
import '../components.dart';
import '../../providers/providers.dart';

class AddressComponent extends StatefulWidget {
  final GlobalKey<FormState> adressFormKey;
  final bool Function() validateAdressFormKey;
  final bool canInsertMoreThanOneAddress;
  final bool? isLoading;
  const AddressComponent({
    required this.adressFormKey,
    this.isLoading = false,
    required this.validateAdressFormKey,
    required this.canInsertMoreThanOneAddress,
    Key? key,
  }) : super(key: key);

  @override
  State<AddressComponent> createState() => _AddressComponentState();
}

class _AddressComponentState extends State<AddressComponent> {
  final FocusNode _cepFocusNode = FocusNode();
  final FocusNode _adressFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _complementFocusNode = FocusNode();
  final FocusNode _referenceFocusNode = FocusNode();

  _getAdressByCep({
    required AddressProvider addressProvider,
  }) async {
    if (!widget.canInsertMoreThanOneAddress &&
        addressProvider.addressesCount > 0) {
      ShowSnackbarMessage.show(
        message:
            "Não é possível inserir mais de um endereço! Remova o endereço informado para conseguir adicionar outro!",
        context: context,
      );
      return;
    } else if (addressProvider.cepController.text.length < 8) {
      ShowSnackbarMessage.show(
        message: "O CEP deve conter 8 dígitos!",
        context: context,
      );
      FocusScope.of(context).requestFocus(_cepFocusNode);
      return;
    }

    await addressProvider.getAddressByCep(
      context: context,
    );

    if (addressProvider.errorMessageGetAddressByCep == "") {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_numberFocusNode);
      });
    } else {
      ShowSnackbarMessage.show(
        message: addressProvider.errorMessageGetAddressByCep,
        context: context,
      );
    }
  }

  ValueNotifier<String?> _selectedStateDropDown = ValueNotifier<String?>("");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    AddressProvider addressProvider = Provider.of(context, listen: true);
    _selectedStateDropDown.value = addressProvider.selectedStateDropDown.value;
  }

  @override
  void dispose() {
    super.dispose();
    _cepFocusNode.dispose();
    _adressFocusNode.dispose();
    _districtFocusNode.dispose();
    _stateFocusNode.dispose();
    _cityFocusNode.dispose();
    _numberFocusNode.dispose();
    _complementFocusNode.dispose();
    _referenceFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AddressProvider addressProvider = Provider.of(context);
    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: widget.adressFormKey,
        child: Column(
          children: [
            FormFieldWidget(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              enabled:
                  widget.isLoading == false && !addressProvider.isLoadingCep,
              focusNode: _cepFocusNode,
              onFieldSubmitted: addressProvider.isLoadingCep
                  ? null
                  : (String? value) async {
                      await _getAdressByCep(
                        addressProvider: addressProvider,
                      );
                    },
              labelText: "CEP",
              textEditingController: addressProvider.cepController,
              limitOfCaracters: 8,
              validator: FormFieldValidations.cpf,
              suffixWidget: TextButton(
                child: addressProvider.isLoadingCep
                    ? const FittedBox(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Text(
                                "Pesquisando CEP",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        "Pesquisar CEP",
                        style: TextStyle(
                          color: addressProvider.isLoadingCep ||
                                  widget.isLoading == true
                              ? Colors.grey
                              : Theme.of(context).colorScheme.primary,
                        ),
                      ),
                onPressed: addressProvider.isLoadingCep
                    ? null
                    : () async {
                        await _getAdressByCep(
                          addressProvider: addressProvider,
                        );
                      },
              ),
            ),
            if (addressProvider.triedGetCep)
              Column(
                children: [
                  FormFieldWidget(
                    enabled: widget.isLoading == false &&
                        !addressProvider.isLoadingCep,
                    focusNode: _adressFocusNode,
                    labelText: "Logradouro",
                    textEditingController: addressProvider.addressController,
                    limitOfCaracters: 40,
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_districtFocusNode);
                    },
                    validator: (String? value) {
                      if ((value == null ||
                              value.isEmpty ||
                              value.length < 5) &&
                          addressProvider.cepController.text.length == 8) {
                        return "Logradouro muito curto";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormFieldWidget(
                          enabled: widget.isLoading == false &&
                              !addressProvider.isLoadingCep,
                          focusNode: _districtFocusNode,
                          onFieldSubmitted: addressProvider.isLoadingCep
                              ? null
                              : (String? value) {
                                  FocusScope.of(context)
                                      .requestFocus(_cityFocusNode);
                                },
                          labelText: "Bairro",
                          textEditingController:
                              addressProvider.districtController,
                          limitOfCaracters: 30,
                          validator: (String? value) {
                            if ((value == null ||
                                    value.isEmpty ||
                                    value.length < 2) &&
                                addressProvider.cepController.text.length ==
                                    8) {
                              return "Bairro muito curto";
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: FormFieldWidget(
                          enabled: widget.isLoading == false &&
                              !addressProvider.isLoadingCep,
                          focusNode: _cityFocusNode,
                          labelText: "Cidade",
                          textEditingController: addressProvider.cityController,
                          limitOfCaracters: 30,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_stateFocusNode);
                          },
                          validator: (String? value) {
                            if ((value == null ||
                                    value.isEmpty ||
                                    value.length < 2) &&
                                addressProvider.cepController.text.length ==
                                    8) {
                              return "Cidade muito curta";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: DropdownButtonFormField<dynamic>(
                          focusNode: _stateFocusNode,
                          value: _selectedStateDropDown.value,
                          isExpanded: true,
                          hint: Center(
                            child: Text(
                              'Estado',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          validator: (value) {
                            if (value == null &&
                                addressProvider.cepController.text.length ==
                                    8) {
                              return 'Selecione um estado!';
                            }
                            return null;
                          },
                          onChanged: addressProvider.isLoadingCep
                              ? null
                              : (value) {
                                  addressProvider.selectedStateDropDown.value =
                                      value;
                                },
                          items: addressProvider.states
                              .map(
                                (value) => DropdownMenuItem(
                                  alignment: Alignment.center,
                                  onTap: () {},
                                  value: value,
                                  child: FittedBox(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            value,
                                          ),
                                        ),
                                        const Divider(
                                          color: Colors.black,
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: FormFieldWidget(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          enabled: widget.isLoading == false &&
                              !addressProvider.isLoadingCep,
                          focusNode: _numberFocusNode,
                          onFieldSubmitted: addressProvider.isLoadingCep
                              ? null
                              : (String? value) async {
                                  FocusScope.of(context)
                                      .requestFocus(_complementFocusNode);
                                },
                          labelText: "Número",
                          textEditingController:
                              addressProvider.numberController,
                          limitOfCaracters: 6,
                          validator: (String? value) {
                            if ((value == null ||
                                    value.isEmpty ||
                                    value.length < 1) &&
                                addressProvider.cepController.text.length ==
                                    8) {
                              return "Digite o número!";
                            } else if (value!.contains("\.") ||
                                value.contains("\,") ||
                                value.contains("\-") ||
                                value.contains(" ")) {
                              return "Digite somente números";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FormFieldWidget(
                          enabled: widget.isLoading == false &&
                              !addressProvider.isLoadingCep,
                          focusNode: _complementFocusNode,
                          onFieldSubmitted: addressProvider.isLoadingCep
                              ? null
                              : (String? value) {
                                  FocusScope.of(context)
                                      .requestFocus(_referenceFocusNode);
                                },
                          labelText: "Complemento",
                          textEditingController:
                              addressProvider.complementController,
                          limitOfCaracters: 30,
                          validator: (String? value) {
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: FormFieldWidget(
                          enabled: widget.isLoading == false &&
                              !addressProvider.isLoadingCep,
                          focusNode: _referenceFocusNode,
                          labelText: "Referência",
                          textEditingController:
                              addressProvider.referenceController,
                          limitOfCaracters: 40,
                          validator: (String? value) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style:
                              TextButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () {
                            ShowAlertDialog.show(
                              context: context,
                              title: "Apagar dados digitados",
                              content: const SingleChildScrollView(
                                child: Text(
                                  "Deseja apagar todos os dados preenchidos?",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              function: () {
                                addressProvider.clearAddressControllers(
                                    clearCep: true);
                              },
                            );
                          },
                          child: const Text(
                            "Apagar dados",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: addressProvider.isLoadingCep
                              ? null
                              : () {
                                  bool isValid = widget.validateAdressFormKey();

                                  if (isValid &&
                                      addressProvider
                                          .cepController.text.isNotEmpty) {
                                    addressProvider.addAddress();
                                    if (addressProvider.errorMessageAddAddres !=
                                        "") {
                                      ShowSnackbarMessage.show(
                                        message: addressProvider
                                            .errorMessageAddAddres,
                                        context: context,
                                      );
                                    }
                                    FocusScope.of(context).unfocus();
                                  } else {
                                    ShowSnackbarMessage.show(
                                      message:
                                          "Insira os dados corretamente para salvar o endereço",
                                      context: context,
                                    );
                                  }
                                },
                          child: const Text(
                            "Adicionar endereço",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (addressProvider.addressesCount > 0)
              CustomerRegisterAddressesInformeds(
                isLoading: widget.isLoading == true,
              ),
          ],
        ),
      ),
    );
  }
}

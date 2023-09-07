import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerRegisterAdressesPage extends StatefulWidget {
  final GlobalKey<FormState> adressFormKey;
  final Function validateAdressFormKey;
  const CustomerRegisterAdressesPage({
    required this.adressFormKey,
    Key? key,
    required this.validateAdressFormKey,
  }) : super(key: key);

  @override
  State<CustomerRegisterAdressesPage> createState() =>
      _CustomerRegisterAdressesPageState();
}

class _CustomerRegisterAdressesPageState
    extends State<CustomerRegisterAdressesPage> {
  final FocusNode _cepFocusNode = FocusNode();
  final FocusNode _adressFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _complementFocusNode = FocusNode();
  final FocusNode _referenceFocusNode = FocusNode();
  String teste = "São Paulo";

  _getAdressByCep({
    required CustomerRegisterProvider customerRegisterProvider,
  }) async {
    if (customerRegisterProvider.cepController.text.length < 8) {
      ShowErrorMessage.showErrorMessage(
        error: "O CEP deve conter 8 dígitos!",
        context: context,
      );
      FocusScope.of(context).requestFocus(_cepFocusNode);
      return;
    }

    await customerRegisterProvider.getAddressByCep(
      context: context,
      cepControllerText: customerRegisterProvider.cepController.text,
      adressController: customerRegisterProvider.adressController,
      cityController: customerRegisterProvider.cityController,
      complementController: customerRegisterProvider.complementController,
      districtController: customerRegisterProvider.districtController,
      stateController: customerRegisterProvider.stateController,
    );
    setState(() {});

    if (customerRegisterProvider.errorMessageGetAdressByCep == "") {
      Future.delayed(const Duration(milliseconds: 100), () {
        FocusScope.of(context).requestFocus(_numberFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Form(
        key: widget.adressFormKey,
        child: Column(
          children: [
            CustomerRegisterFormField(
              keyboardType: TextInputType.number,
              enabled: customerRegisterProvider.isLoadingCep ? false : true,
              focusNode: _cepFocusNode,
              onFieldSubmitted: customerRegisterProvider.isLoadingCep
                  ? null
                  : (String? value) async {
                      await _getAdressByCep(
                        customerRegisterProvider: customerRegisterProvider,
                      );
                    },
              labelText: "CEP",
              textEditingController: customerRegisterProvider.cepController,
              limitOfCaracters: 8,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return null;
                } else if (value.length < 8) {
                  return "Quantidade de números inválido!";
                }
                return null;
              },
              suffixWidget: TextButton(
                child: const Text("Pesquisar CEP"),
                onPressed: customerRegisterProvider.isLoadingCep
                    ? null
                    : () async {
                        await _getAdressByCep(
                          customerRegisterProvider: customerRegisterProvider,
                        );
                      },
              ),
            ),
            if (customerRegisterProvider.triedGetCep)
              Column(
                children: [
                  CustomerRegisterFormField(
                    enabled:
                        customerRegisterProvider.isLoadingCep ? false : true,
                    focusNode: _adressFocusNode,
                    // onFieldSubmitted: customerRegisterProvider.isLoadingCep
                    //     ? null
                    //     : (String? value) async {
                    //         await customerRegisterProvider.getAddressByCep(
                    //           context: context,
                    //           cepControllerText: widget.cepController.text,
                    //         );
                    //       },
                    labelText: "Logradouro",
                    textEditingController:
                        customerRegisterProvider.adressController,
                    limitOfCaracters: 40,
                    validator: (String? value) {
                      if (value == null || value.isEmpty || value.length < 5) {
                        return "Logradouro muito curto";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomerRegisterFormField(
                          enabled: customerRegisterProvider.isLoadingCep
                              ? false
                              : true,
                          focusNode: _districtFocusNode,
                          onFieldSubmitted:
                              customerRegisterProvider.isLoadingCep
                                  ? null
                                  : (String? value) {
                                      FocusScope.of(context)
                                          .requestFocus(_cityFocusNode);
                                    },
                          labelText: "Bairro",
                          textEditingController:
                              customerRegisterProvider.districtController,
                          limitOfCaracters: 30,
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 2) {
                              return "Bairro muito curto";
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomerRegisterFormField(
                          enabled: customerRegisterProvider.isLoadingCep
                              ? false
                              : true,
                          focusNode: _cityFocusNode,
                          // onFieldSubmitted: customerRegisterProvider.isLoadingCep
                          //     ? null
                          //     : (String? value) async {
                          //         await customerRegisterProvider.getAddressByCep(
                          //           context: context,
                          //           cepControllerText: widget.cepController.text,
                          //         );
                          //       },
                          labelText: "Cidade",
                          textEditingController:
                              customerRegisterProvider.cityController,
                          limitOfCaracters: 30,
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 2) {
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
                          value: customerRegisterProvider.states[0],
                          // disabledHint: transferBetweenPackageProvider
                          //         .isLoadingTypeStockAndJustifications
                          //     ? Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           const FittedBox(
                          //             child: Text(
                          //               "Consultando",
                          //               textAlign: TextAlign.center,
                          //               style: const TextStyle(
                          //                 fontSize: 60,
                          //               ),
                          //             ),
                          //           ),
                          //           const SizedBox(width: 15),
                          //           Container(
                          //             height: 15,
                          //             width: 15,
                          //             child: const CircularProgressIndicator(),
                          //           ),
                          //         ],
                          //       )
                          //     : const Center(child: Text("Justificativas")),
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
                            if (value == null) {
                              return 'Selecione um estado!';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            print(value);
                          },
                          items: customerRegisterProvider.states
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
                        child: CustomerRegisterFormField(
                          keyboardType: TextInputType.number,
                          enabled: customerRegisterProvider.isLoadingCep
                              ? false
                              : true,
                          focusNode: _numberFocusNode,
                          onFieldSubmitted:
                              customerRegisterProvider.isLoadingCep
                                  ? null
                                  : (String? value) async {
                                      FocusScope.of(context)
                                          .requestFocus(_complementFocusNode);
                                    },
                          labelText: "Número",
                          textEditingController:
                              customerRegisterProvider.numberController,
                          limitOfCaracters: 6,
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 1) {
                              return "Digite o número!";
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
                        child: CustomerRegisterFormField(
                          enabled: customerRegisterProvider.isLoadingCep
                              ? false
                              : true,
                          focusNode: _complementFocusNode,
                          onFieldSubmitted:
                              customerRegisterProvider.isLoadingCep
                                  ? null
                                  : (String? value) {
                                      FocusScope.of(context)
                                          .requestFocus(_referenceFocusNode);
                                    },
                          labelText: "Complemento",
                          textEditingController:
                              customerRegisterProvider.complementController,
                          limitOfCaracters: 30,
                          validator: (String? value) {
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomerRegisterFormField(
                          enabled: customerRegisterProvider.isLoadingCep
                              ? false
                              : true,
                          focusNode: _referenceFocusNode,
                          // onFieldSubmitted: customerRegisterProvider.isLoadingCep
                          //     ? null
                          //     : (String? value) async {
                          //         await customerRegisterProvider.getAddressByCep(
                          //           context: context,
                          //           cepControllerText: widget.cepController.text,
                          //         );
                          //       },
                          labelText: "Referência",
                          textEditingController:
                              customerRegisterProvider.referenceController,
                          limitOfCaracters: 40,
                          validator: (String? value) {
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      onPressed: customerRegisterProvider.isLoadingCep
                          ? null
                          : () {
                              widget.validateAdressFormKey();
                            },
                      child: const Text("Adicionar endereço"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

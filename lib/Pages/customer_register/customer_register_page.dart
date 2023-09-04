import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerRegisterPage extends StatefulWidget {
  const CustomerRegisterPage({Key? key}) : super(key: key);

  @override
  State<CustomerRegisterPage> createState() => _CustomerRegisterPageState();
}

class _CustomerRegisterPageState extends State<CustomerRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reducedNameController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  String dateOfBirth = "";

  final FocusNode _cpfCnpjFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _reducedNameFocusNode = FocusNode();
  final FocusNode _cepFocusNode = FocusNode();
  final FocusNode _adressFocusNode = FocusNode();
  final FocusNode _districtFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _dateOfBirthFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _sexTypeFocusNode = FocusNode();
  final FocusNode _complementFocusNode = FocusNode();
  final FocusNode _referenceFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _cpfCnpjController.dispose();
    _nameController.dispose();
    _reducedNameController.dispose();
    _cepController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _adressController.dispose();
    _districtController.dispose();
    _complementController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _numberController.dispose();
    _referenceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    return WillPopScope(
      onWillPop: () async {
        //fazer algo que quiser quando o usuário clicar no botão de voltar
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CADASTRO DE CLIENTES',
          ),
          leading: IconButton(
            onPressed: () {
              //fazer algo que quiser quando o usuário clicar no botão de voltar
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomerRegisterFormField(
                  suffixWidget: const Text(
                    "obrigatório  ",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                    ),
                  ),
                  enabled: true,
                  focusNode: _nameFocusNode,
                  onFieldSubmitted: (String? value) {
                    FocusScope.of(context).requestFocus(_reducedNameFocusNode);
                  },
                  labelText: "Nome",
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório!';
                    } else if (value.length < 3) {
                      return "Nome inválido!";
                    }
                    return null;
                  },
                  textEditingController: _nameController,
                  limitOfCaracters: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomerRegisterFormField(
                        focusNode: _cpfCnpjFocusNode,
                        keyboardType: TextInputType.number,
                        enabled: true,
                        onFieldSubmitted: (String? value) {
                          FocusScope.of(context).requestFocus(_nameFocusNode);
                        },
                        labelText: "CPF/CNPJ",
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (value.length < 11) {
                            return "CPF inválido";
                          } else if (value.length == 11) {
                            return null;
                          } else if (value.length < 14) {
                            return "CNPJ inválido";
                          }
                          return null;
                        },
                        textEditingController: _cpfCnpjController,
                        limitOfCaracters: 14,
                      ),
                    ),
                    Expanded(
                      child: CustomerRegisterFormField(
                        enabled: true,
                        focusNode: _reducedNameFocusNode,
                        onFieldSubmitted: (String? value) {
                          FocusScope.of(context)
                              .requestFocus(_sexTypeFocusNode);
                        },
                        labelText: "Nome reduzido",
                        textEditingController: _reducedNameController,
                        limitOfCaracters: 25,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<dynamic>(
                        focusNode: _sexTypeFocusNode,
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
                            'Sexo',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        validator: (value) {
                          // if (value == null) {
                          //   return 'Selecione uma justificativa!';
                          // }
                          return null;
                        },
                        onChanged:
                            // transferBetweenPackageProvider
                            //             .isLoadingTypeStockAndJustifications ||
                            //         transferBetweenPackageProvider.isLoadingAdjustStock ||
                            //         transferBetweenPackageProvider.isLoadingProducts ||
                            //         transferBetweenPackageProvider.products.isEmpty
                            //     ? null
                            //     :
                            (value) {
                          print(value);
                        },
                        items: ["Masculino", "Feminino"]
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
                                        height: 4,
                                        color: Colors.black,
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
                      flex: 3,
                      child: CustomerRegisterFormField(
                        keyboardType: TextInputType.number,
                        enabled: true,
                        focusNode: _dateOfBirthFocusNode,
                        onFieldSubmitted: (String? value) {
                          FocusScope.of(context).requestFocus(_emailFocusNode);
                        },
                        labelText: "Nascimento",
                        isDate: true,
                        textEditingController: _dateOfBirthController,
                        limitOfCaracters: 10,
                        suffixWidget: IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () async {
                              DateTime? validityDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now().subtract(
                                  const Duration(days: 36500),
                                ),
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 1825)),
                                lastDate: DateTime.now()
                                    .subtract(const Duration(days: 1825)),
                              );

                              if (validityDate != null) {
                                setState(() {
                                  dateOfBirth = DateFormat('dd/MM/yyyy')
                                      .format(validityDate);
                                });
                              }
                            }),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }

                          // Verifique se a data está no formato correto (XX/XX/XXXX)
                          final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                          if (!datePattern.hasMatch(value)) {
                            return 'Formato inválido';
                          }

                          // Divida a data em dia, mês e ano
                          final parts = value.split('/');
                          final day = int.tryParse(parts[0]);
                          final month = int.tryParse(parts[1]);
                          final year = int.tryParse(parts[2]);

                          if (day == null || month == null || year == null) {
                            return 'Data inválida';
                          }

                          // Verifique se o dia está no intervalo correto (01-31)
                          if (day < 1 || day > 31) {
                            return 'Dia inválido';
                          }

                          // Verifique se o mês está no intervalo correto (01-12)
                          if (month < 1 || month > 12) {
                            return 'Mês inválido';
                          }

                          // Verifique se o ano está no intervalo correto (5 anos atrás até 100 anos no futuro)
                          final currentYear = DateTime.now().year;
                          if (year > currentYear - 5 ||
                              year > currentYear + 100) {
                            return 'Ano inválido';
                          }

                          return null; // A data é válida
                        },
                      ),
                    ),
                  ],
                ),
                CustomerRegisterFormField(
                  enabled: true,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (String? value) {
                    //executar o validate do email
                    if (_emailController.text.isEmpty) {
                      return;
                    }
                    customerRegisterProvider.addEmail(
                      emailController: _emailController,
                      context: context,
                    );
                  },
                  labelText: "E-mais",
                  textEditingController: _emailController,
                  limitOfCaracters: 40,
                  validator: (String? value) {
                    // if (value == null || value.isEmpty) {
                    //   return null;
                    // } else if (value.length < 8) {
                    //   return "Quantidade de números inválido!";
                    // }
                    return null;
                  },
                  suffixWidget: FittedBox(
                    child: TextButton(
                      onPressed: () {
                        customerRegisterProvider.addEmail(
                          emailController: _emailController,
                          context: context,
                        );
                      },
                      child: const Column(
                        children: [
                          Text("Adicionar"),
                          FittedBox(child: Icon(Icons.add)),
                        ],
                      ),
                    ),
                  ),
                ),
                if (customerRegisterProvider.emailsCount > 0)
                  Container(
                    height: double.parse(
                        "${customerRegisterProvider.emailsCount * 40}"),
                    child: PersonalizedCard.personalizedCard(
                      context: context,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            const Divider(), // ou outro separador, se necessário
                        itemCount: customerRegisterProvider.emailsCount,
                        itemBuilder: (context, index) {
                          String email = customerRegisterProvider.emails[index];
                          return Text(
                            email,
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ),
                CustomerRegisterFormField(
                  keyboardType: TextInputType.number,
                  enabled: customerRegisterProvider.isLoadingCep ? false : true,
                  focusNode: _cepFocusNode,
                  onFieldSubmitted: customerRegisterProvider.isLoadingCep
                      ? null
                      : (String? value) async {
                          await customerRegisterProvider.getAddressByCep(
                            context: context,
                            cepControllerText: _cepController.text,
                            adressController: _adressController,
                            cityController: _cityController,
                            complementController: _complementController,
                            districtController: _districtController,
                            stateController: _stateController,
                          );
                          setState(() {});
                        },
                  labelText: "CEP",
                  textEditingController: _cepController,
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
                    onPressed: customerRegisterProvider.isLoadingCep
                        ? null
                        : () async {
                            await customerRegisterProvider.getAddressByCep(
                              context: context,
                              cepControllerText: _cepController.text,
                              adressController: _adressController,
                              cityController: _cityController,
                              complementController: _complementController,
                              districtController: _districtController,
                              stateController: _stateController,
                            );
                            setState(() {});

                            if (customerRegisterProvider
                                .successToGetAdressByCep) {
                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
                                FocusScope.of(context)
                                    .requestFocus(_numberFocusNode);
                              });
                            }
                          },
                    child: const Text("Pesquisar CEP"),
                  ),
                ),
                if (customerRegisterProvider.triedGetCep)
                  Column(
                    children: [
                      CustomerRegisterFormField(
                        enabled: customerRegisterProvider.isLoadingCep ||
                                customerRegisterProvider.successToGetAdressByCep
                            ? false
                            : true,
                        focusNode: _adressFocusNode,
                        // onFieldSubmitted: customerRegisterProvider.isLoadingCep
                        //     ? null
                        //     : (String? value) async {
                        //         await customerRegisterProvider.getAddressByCep(
                        //           context: context,
                        //           cepControllerText: _cepController.text,
                        //         );
                        //       },
                        labelText: "Logradouro",
                        textEditingController: _adressController,
                        limitOfCaracters: 8,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          } else if (value.length < 8) {
                            return "Quantidade de números inválido!";
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomerRegisterFormField(
                              enabled: customerRegisterProvider.isLoadingCep ||
                                      customerRegisterProvider
                                          .successToGetAdressByCep
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
                              textEditingController: _districtController,
                              limitOfCaracters: 8,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8) {
                                  return "Quantidade de números inválido!";
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomerRegisterFormField(
                              enabled: customerRegisterProvider.isLoadingCep ||
                                      customerRegisterProvider
                                          .successToGetAdressByCep
                                  ? false
                                  : true,
                              focusNode: _cityFocusNode,
                              // onFieldSubmitted: customerRegisterProvider.isLoadingCep
                              //     ? null
                              //     : (String? value) async {
                              //         await customerRegisterProvider.getAddressByCep(
                              //           context: context,
                              //           cepControllerText: _cepController.text,
                              //         );
                              //       },
                              labelText: "Cidade",
                              textEditingController: _cityController,
                              limitOfCaracters: 8,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8) {
                                  return "Quantidade de números inválido!";
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
                              keyboardType: TextInputType.number,
                              enabled: customerRegisterProvider.isLoadingCep ||
                                      customerRegisterProvider
                                          .successToGetAdressByCep
                                  ? false
                                  : true,
                              focusNode: _stateFocusNode,
                              onFieldSubmitted:
                                  customerRegisterProvider.isLoadingCep
                                      ? null
                                      : (String? value) {
                                          FocusScope.of(context)
                                              .requestFocus(_numberFocusNode);
                                        },
                              labelText: "Estado",
                              textEditingController: _stateController,
                              limitOfCaracters: 8,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8) {
                                  return "Quantidade de números inválido!";
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
                              focusNode: _numberFocusNode,
                              onFieldSubmitted: customerRegisterProvider
                                      .isLoadingCep
                                  ? null
                                  : (String? value) async {
                                      FocusScope.of(context)
                                          .requestFocus(_complementFocusNode);
                                    },
                              labelText: "Número",
                              textEditingController: _numberController,
                              limitOfCaracters: 8,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8) {
                                  return "Quantidade de números inválido!";
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
                              onFieldSubmitted: customerRegisterProvider
                                      .isLoadingCep
                                  ? null
                                  : (String? value) {
                                      FocusScope.of(context)
                                          .requestFocus(_referenceFocusNode);
                                    },
                              labelText: "Complemento",
                              textEditingController: _complementController,
                              limitOfCaracters: 8,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8) {
                                  return "Quantidade de números inválido!";
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
                              focusNode: _referenceFocusNode,
                              // onFieldSubmitted: customerRegisterProvider.isLoadingCep
                              //     ? null
                              //     : (String? value) async {
                              //         await customerRegisterProvider.getAddressByCep(
                              //           context: context,
                              //           cepControllerText: _cepController.text,
                              //         );
                              //       },
                              labelText: "Referência",
                              textEditingController: _referenceController,
                              limitOfCaracters: 8,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                } else if (value.length < 8) {
                                  return "Quantidade de números inválido!";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() &&
                        dateOfBirth != "") {
                      print("Válido");
                    } else {
                      print("Inválido");
                    }
                  },
                  child: const Text("Cadastrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerRegisterPersonPage extends StatefulWidget {
  final GlobalKey<FormState> personFormKey;
  final Function validatePersonFormKey;
  const CustomerRegisterPersonPage({
    required this.personFormKey,
    required this.validatePersonFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterPersonPage> createState() =>
      _CustomerRegisterPersonPageState();
}

class _CustomerRegisterPersonPageState
    extends State<CustomerRegisterPersonPage> {
  String dateOfBirth = "";

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode reducedNameFocusNode = FocusNode();
  final FocusNode cpfCnpjFocusNode = FocusNode();
  final FocusNode sexTypeFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Form(
        key: widget.personFormKey,
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
              focusNode: nameFocusNode,
              onFieldSubmitted: (String? value) {
                bool isValid = widget.validatePersonFormKey();
                if (isValid) {
                  FocusScope.of(context).requestFocus(cpfCnpjFocusNode);
                } else {
                  FocusScope.of(context).requestFocus(nameFocusNode);
                }
              },
              labelText: "Nome",
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Nome é obrigatório!';
                } else if (value.length < 3) {
                  return "O nome deve conter pelo menos 3 letras";
                }
                return null;
              },
              textEditingController: customerRegisterProvider.nameController,
              limitOfCaracters: 50,
            ),
            CustomerRegisterFormField(
              focusNode: cpfCnpjFocusNode,
              keyboardType: TextInputType.number,
              enabled: true,
              onFieldSubmitted: (String? value) {
                bool isValid = widget.validatePersonFormKey();
                if (isValid) {
                  FocusScope.of(context).requestFocus(reducedNameFocusNode);
                } else {
                  FocusScope.of(context).requestFocus(cpfCnpjFocusNode);
                }
              },
              labelText: "CPF/CNPJ",
              validator: (String? cpfCnpj) {
                if (cpfCnpj == null || cpfCnpj.isEmpty) {
                  return null;
                } else if (cpfCnpj.contains(" ") ||
                    cpfCnpj.contains("\.") ||
                    cpfCnpj.contains(",") ||
                    cpfCnpj.contains("-")) {
                  customerRegisterProvider.cpfCnpjController.text =
                      customerRegisterProvider.cpfCnpjController.text
                          .replaceAll(RegExp(r' '), '');
                  return "Digite somente números!";
                } else if (cpfCnpj.length == 11 &&
                    CPFValidator.isValid(cpfCnpj)) {
                  return null;
                } else if (cpfCnpj.length == 11 &&
                    !CPFValidator.isValid(cpfCnpj)) {
                  return "CPF inválido!";
                } else if (cpfCnpj.length == 14 &&
                    CNPJValidator.isValid(cpfCnpj)) {
                  return null;
                } else if (cpfCnpj.length == 14 &&
                    !CNPJValidator.isValid(cpfCnpj)) {
                  return "CNPJ inválido!";
                } else if (cpfCnpj.length < 11) {
                  return "Quantidade de caracteres inválido";
                } else if (cpfCnpj.length > 11 && cpfCnpj.length < 14) {
                  return "Quantidade de caracteres inválido";
                }
              },
              textEditingController: customerRegisterProvider.cpfCnpjController,
              limitOfCaracters: 14,
            ),
            CustomerRegisterFormField(
              enabled: true,
              focusNode: reducedNameFocusNode,
              onFieldSubmitted: (String? value) {
                bool isValid = widget.validatePersonFormKey();
                if (isValid) {
                  FocusScope.of(context).requestFocus(dateOfBirthFocusNode);
                } else {
                  FocusScope.of(context).requestFocus(reducedNameFocusNode);
                }
              },
              labelText: "Nome reduzido",
              textEditingController:
                  customerRegisterProvider.reducedNameController,
              limitOfCaracters: 25,
            ),
            CustomerRegisterFormField(
              keyboardType: TextInputType.number,
              enabled: true,
              focusNode: dateOfBirthFocusNode,
              onFieldSubmitted: (String? value) {
                bool isValid = widget.validatePersonFormKey();
                if (isValid) {
                  FocusScope.of(context).requestFocus(emailFocusNode);
                } else {
                  FocusScope.of(context).requestFocus(dateOfBirthFocusNode);
                }
              },
              labelText: "Nascimento",
              isDate: true,
              textEditingController:
                  customerRegisterProvider.dateOfBirthController,
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
                      initialDate:
                          DateTime.now().subtract(const Duration(days: 1825)),
                      lastDate:
                          DateTime.now().subtract(const Duration(days: 1825)),
                    );

                    if (validityDate != null) {
                      setState(() {
                        dateOfBirth =
                            DateFormat('dd/MM/yyyy').format(validityDate);
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
                  return 'Data inválida!';
                }

                // Divida a data em dia, mês e ano
                final parts = value.split('/');
                final day = int.tryParse(parts[0]);
                final month = int.tryParse(parts[1]);
                final year = int.tryParse(parts[2]);

                if (day == null || month == null || year == null) {
                  return 'Data inválida!';
                }

                // Verifique se o dia está no intervalo correto (01-31)
                if (day < 1 || day > 31) {
                  return 'Dia inválido!';
                }

                // Verifique se o mês está no intervalo correto (01-12)
                if (month < 1 || month > 12) {
                  return 'Mês inválido!';
                }

                // Verifique se o ano está no intervalo correto (5 anos atrás até 100 anos no futuro)
                final currentYear = DateTime.now().year;
                if (year > currentYear - 5 || year > currentYear + 100) {
                  return 'Ano inválido!';
                }

                return null; // A data é válida
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: DropdownButtonFormField<dynamic>(
                focusNode: sexTypeFocusNode,
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
                decoration: const InputDecoration(
                  labelText: '',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 1.0,
                    ),
                  ),
                ),
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
          ],
        ),
      ),
    );
  }
}

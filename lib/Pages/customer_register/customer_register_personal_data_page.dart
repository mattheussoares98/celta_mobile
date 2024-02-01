import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomerRegisterPersonalDataPage extends StatefulWidget {
  final GlobalKey<FormState> personFormKey;
  const CustomerRegisterPersonalDataPage({
    required this.personFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterPersonalDataPage> createState() =>
      _CustomerRegisterPersonalDataPageState();
}

class _CustomerRegisterPersonalDataPageState
    extends State<CustomerRegisterPersonalDataPage> {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode reducedNameFocusNode = FocusNode();
  final FocusNode cpfCnpjFocusNode = FocusNode();
  final FocusNode sexTypeFocusNode = FocusNode();
  final FocusNode dateOfBirthFocusNode = FocusNode();

  ValueNotifier<String?> _selectedSexDropDown = ValueNotifier<String?>("");

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);
    _selectedSexDropDown.value =
        customerRegisterProvider.selectedSexDropDown.value;
  }

  @override
  void dispose() {
    super.dispose();
    nameFocusNode.dispose();
    reducedNameFocusNode.dispose();
    cpfCnpjFocusNode.dispose();
    sexTypeFocusNode.dispose();
    dateOfBirthFocusNode.dispose();
  }

  bool cpfCnpjEnabled = true;
  void updateCpfCnpjEnabled() {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: false);

    if (customerRegisterProvider.cpfCnpjController.text.length > 11) {
      setState(() {
        cpfCnpjEnabled = false;
      });
    } else {
      setState(() {
        cpfCnpjEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    updateCpfCnpjEnabled();

    return SingleChildScrollView(
      child: Form(
        key: widget.personFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomerRegisterFormField(
              enabled: true,
              focusNode: nameFocusNode,
              onFieldSubmitted: (String? value) {
                FocusScope.of(context).requestFocus(cpfCnpjFocusNode);
              },
              suffixWidget: IconButton(
                onPressed: () {
                  customerRegisterProvider.nameController.text = "";
                  FocusScope.of(context).requestFocus(nameFocusNode);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              labelText: "Nome",
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'O nome é obrigatório';
                } else {
                  List<String> nameParts = value.split(' ');

                  if (nameParts.length < 2) {
                    return 'Informe o nome e o sobrenome';
                  }

                  if (nameParts[0].length < 3 || nameParts[1].length < 3) {
                    return 'O nome e o sobrenome devem ter pelo menos 3 letras';
                  }

                  return null;
                }
              },
              textEditingController: customerRegisterProvider.nameController,
              limitOfCaracters: 50,
            ),
            CustomerRegisterFormField(
              focusNode: cpfCnpjFocusNode,
              keyboardType: TextInputType.number,
              enabled: true,
              onChanged: (value) {
                updateCpfCnpjEnabled();
              },
              suffixWidget: IconButton(
                onPressed: () {
                  customerRegisterProvider.cpfCnpjController.text = "";
                  FocusScope.of(context).requestFocus(cpfCnpjFocusNode);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              onFieldSubmitted: (String? value) {
                FocusScope.of(context).requestFocus(reducedNameFocusNode);
              },
              labelText: "CPF/CNPJ",
              validator: (String? cpfCnpj) {
                if (cpfCnpj == null || cpfCnpj.isEmpty) {
                  return "Informe o CPF ou CNPJ";
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

                return "CPF/CNPJ inválido!";
              },
              textEditingController: customerRegisterProvider.cpfCnpjController,
              limitOfCaracters: 14,
            ),
            CustomerRegisterFormField(
              enabled: true,
              focusNode: reducedNameFocusNode,
              suffixWidget: IconButton(
                onPressed: () {
                  customerRegisterProvider.reducedNameController.text = "";
                  FocusScope.of(context).requestFocus(reducedNameFocusNode);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
              onFieldSubmitted: (String? value) {
                FocusScope.of(context).requestFocus(dateOfBirthFocusNode);
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
                FocusScope.of(context).requestFocus(sexTypeFocusNode);
              },
              labelText: "Nascimento",
              isDate: true,
              textEditingController:
                  customerRegisterProvider.dateOfBirthController,
              limitOfCaracters: 10,
              suffixWidget: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
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
                            locale: const Locale('pt', 'BR'),
                          );

                          if (validityDate != null) {
                            customerRegisterProvider
                                    .dateOfBirthController.text =
                                DateFormat('dd/MM/yyyy').format(validityDate);
                          }
                        }),
                    IconButton(
                      onPressed: () {
                        customerRegisterProvider.dateOfBirthController.text =
                            "";
                        FocusScope.of(context)
                            .requestFocus(dateOfBirthFocusNode);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
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
            if (cpfCnpjEnabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonFormField<dynamic>(
                  value: _selectedSexDropDown.value,
                  focusNode: sexTypeFocusNode,
                  disabledHint: const Center(child: Text("Sexo")),
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
                    if (value == null && cpfCnpjEnabled) {
                      return 'Selecione uma opção!';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    customerRegisterProvider.selectedSexDropDown =
                        ValueNotifier(value);
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
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  ShowAlertDialog.showAlertDialog(
                    context: context,
                    title: "Limpar dados",
                    subtitle:
                        "Deseja realmente limpar todos dados pessoais digitados?",
                    function: () {
                      customerRegisterProvider.clearPersonalDataControllers();
                    },
                  );
                },
                child: const Text("Limpar dados"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

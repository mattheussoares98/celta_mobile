import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/components/Customer_register/customer_register_telephones_informeds.dart';
import 'package:celta_inventario/components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerRegisterTelephonePage extends StatefulWidget {
  final GlobalKey<FormState> telephoneFormKey;
  final Function validateTelephoneFormKey;
  const CustomerRegisterTelephonePage({
    required this.validateTelephoneFormKey,
    required this.telephoneFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterTelephonePage> createState() =>
      _CustomerRegisterTelephonePageState();
}

class _CustomerRegisterTelephonePageState
    extends State<CustomerRegisterTelephonePage> {
  final FocusNode telephoneFocusNode = FocusNode();
  final FocusNode dddFocusNode = FocusNode();

  void _addTelephone({
    required CustomerRegisterProvider customerRegisterProvider,
  }) {
    bool isValid = widget.validateTelephoneFormKey();

    if (isValid &&
        customerRegisterProvider.telephoneController.text.isNotEmpty) {
      customerRegisterProvider.addTelephone(
        context: context,
      );
      FocusScope.of(context).unfocus();
    } else {
      ShowErrorMessage.showErrorMessage(
        error: "Digite um telefone válido! Informe o número com o DDD",
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);

    return SingleChildScrollView(
      child: Form(
        key: widget.telephoneFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomerRegisterFormField(
                    keyboardType: TextInputType.number,
                    enabled: true,
                    focusNode: dddFocusNode,
                    onFieldSubmitted: (String? value) {
                      FocusScope.of(context).requestFocus(telephoneFocusNode);
                    },
                    labelText: "DDD",
                    textEditingController:
                        customerRegisterProvider.dddController,
                    limitOfCaracters: 2,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (value.length < 2) {
                        return 'Curto!';
                      } else if (int.tryParse(value) == null) {
                        return "Inválido!";
                      } else if (int.parse(value) < 11) {
                        return "Inválido!"; //menor DDD que existe é o 11
                      }
                      return null;
                    },
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: CustomerRegisterFormField(
                    keyboardType: TextInputType.number,
                    enabled: true,
                    focusNode: telephoneFocusNode,
                    onChanged: (value) {
                      value = value.replaceAll("-", "");

                      // Verifique o comprimento do número
                      if (value.length == 8) {
                        // Adicione o traço após o quarto dígito
                        value =
                            value.substring(0, 4) + "-" + value.substring(4);
                      } else if (value.length == 9) {
                        // Adicione o traço após o quinto dígito
                        value =
                            value.substring(0, 5) + "-" + value.substring(5);
                      }

                      // Atualiza o valor formatado no controlador
                      customerRegisterProvider.telephoneController.value =
                          customerRegisterProvider.telephoneController.value
                              .copyWith(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                    // onFieldSubmitted: (String? value) {
                    //   _addTelephone(
                    //     customerRegisterProvider: customerRegisterProvider,
                    //   );
                    // },
                    suffixWidget: IconButton(
                        onPressed: () {
                          customerRegisterProvider.clearTelephoneController();
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    labelText: "Telefone",
                    textEditingController:
                        customerRegisterProvider.telephoneController,
                    limitOfCaracters: 10,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (!RegExp(r"^[0-9-]+$").hasMatch(value)) {
                        return 'Digite somente números!';
                      } else if (value.length < 8) {
                        return 'Telefone muito curto!';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _addTelephone(
                  customerRegisterProvider: customerRegisterProvider,
                );
              },
              child: const Text(
                "Adicionar telefone",
              ),
            ),
            if (customerRegisterProvider.telephonesCount > 0)
              const CustomerRegisterTelephonesInformeds(),
          ],
        ),
      ),
    );
  }
}

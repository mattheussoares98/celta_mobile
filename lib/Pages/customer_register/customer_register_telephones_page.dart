import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import 'customer_register.dart';

class CustomerRegisterTelephonePage extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController areaCodeController;
  const CustomerRegisterTelephonePage({
    required this.phoneNumberController,
    required this.areaCodeController,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterTelephonePage> createState() =>
      _CustomerRegisterTelephonePageState();
}

class _CustomerRegisterTelephonePageState
    extends State<CustomerRegisterTelephonePage> {
  final FocusNode telephoneFocusNode = FocusNode();
  final FocusNode areaCodeFocusNode = FocusNode();
  final telephoneKey = GlobalKey<FormState>();
  bool telephoneIsValid = false;

  void _addTelephone({
    required CustomerRegisterProvider customerRegisterProvider,
  }) {
    bool? isValid = telephoneKey.currentState?.validate();

    if (isValid == true) {
      bool added = customerRegisterProvider.addTelephone(
        phoneNumber: widget.phoneNumberController.text,
        areaCode: widget.areaCodeController.text,
      );

      if (added) {
        widget.phoneNumberController.clear();
        widget.areaCodeController.clear();
      }
    } else {
      ShowSnackbarMessage.show(
        message: "Digite um telefone válido! Informe o número com o DDD",
        context: context,
      );
      if (widget.areaCodeController.text.length < 2) {
        Future.delayed(Duration.zero, () {
          areaCodeFocusNode.requestFocus();
        });
      } else {
        Future.delayed(Duration.zero, () {
          telephoneFocusNode.requestFocus();
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    telephoneFocusNode.dispose();
    areaCodeFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider =
        Provider.of(context, listen: true);

    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: telephoneKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FormFieldWidget(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
                    enabled: true,
                    focusNode: areaCodeFocusNode,
                    onFieldSubmitted: (String? value) {
                      FocusScope.of(context).requestFocus(telephoneFocusNode);
                    },
                    labelText: "DDD",
                    textEditingController: widget.areaCodeController,
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
                  child: FormFieldWidget(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: false),
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
                      widget.phoneNumberController.value =
                          widget.phoneNumberController.value.copyWith(
                        text: value,
                        selection:
                            TextSelection.collapsed(offset: value.length),
                      );
                    },
                    onFieldSubmitted: (String? value) {
                      _addTelephone(
                        customerRegisterProvider: customerRegisterProvider,
                      );
                    },
                    suffixWidget: IconButton(
                        onPressed: () {
                          customerRegisterProvider.clearTelephoneControllers(
                            telephoneController: widget.phoneNumberController,
                            dddController: widget.areaCodeController,
                          );
                          FocusScope.of(context)
                              .requestFocus(areaCodeFocusNode);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                    labelText: "Telefone",
                    textEditingController: widget.phoneNumberController,
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () {
                  _addTelephone(
                    customerRegisterProvider: customerRegisterProvider,
                  );
                },
                child: const Text(
                  "Adicionar telefone",
                ),
              ),
            ),
            if ((customerRegisterProvider.customer?.Telephones?.length ?? 0) >
                0)
              const CustomerRegisterTelephonesInformeds(),
          ],
        ),
      ),
    );
  }
}

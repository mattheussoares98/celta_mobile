import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/components/Global_widgets/personalized_card.dart';
import 'package:celta_inventario/components/Global_widgets/show_error_message.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerRegisterEmailPage extends StatefulWidget {
  final GlobalKey<FormState> emailFormKey;
  final Function validateAdressFormKey;
  const CustomerRegisterEmailPage({
    required this.validateAdressFormKey,
    required this.emailFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterEmailPage> createState() =>
      _CustomerRegisterEmailPageState();
}

class _CustomerRegisterEmailPageState extends State<CustomerRegisterEmailPage> {
  final FocusNode emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return SingleChildScrollView(
      child: Form(
        key: widget.emailFormKey,
        child: Column(
          children: [
            CustomerRegisterFormField(
              enabled: true,
              focusNode: emailFocusNode,
              onFieldSubmitted: (String? value) {
                //executar o validate do email
                if (customerRegisterProvider.emailController.text.isEmpty) {
                  return;
                }
                customerRegisterProvider.addEmail(
                  emailController: customerRegisterProvider.emailController,
                  context: context,
                );
                FocusScope.of(context).unfocus();
              },
              suffixWidget: IconButton(
                  onPressed: () {
                    customerRegisterProvider.clearEmailController();
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              labelText: "E-mail",
              textEditingController: customerRegisterProvider.emailController,
              limitOfCaracters: 40,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return null;
                } else if (!value.contains("@")) {
                  return 'O e-mail está inválido';
                } else if (!value.contains("\.")) {
                  return 'O e-mail está inválido';
                } else if (value.endsWith("\.")) {
                  return 'O e-mail está inválido';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                bool isValid = widget.validateAdressFormKey();

                if (isValid &&
                    customerRegisterProvider.emailController.text.isNotEmpty) {
                  customerRegisterProvider.addEmail(
                    emailController: customerRegisterProvider.emailController,
                    context: context,
                  );
                  FocusScope.of(context).unfocus();
                } else {
                  ShowErrorMessage.showErrorMessage(
                    error: "Digite um e-mail válido!",
                    context: context,
                  );
                }
              },
              child: const Text(
                "Adicionar e-mail",
              ),
            ),
            if (customerRegisterProvider.emailsCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customerRegisterProvider.emailsCount,
                  itemBuilder: (context, index) {
                    String email = customerRegisterProvider.emails[index];
                    return PersonalizedCard.personalizedCard(
                      context: context,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              email,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              customerRegisterProvider.removeEmail(index);
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

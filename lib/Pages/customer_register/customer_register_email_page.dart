import 'package:celta_inventario/components/Customer_register/customer_register_emails_informeds.dart';
import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
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

  void addEmail({
    required CustomerRegisterProvider customerRegisterProvider,
  }) {
    bool isValid = widget.validateAdressFormKey();

    if (isValid && customerRegisterProvider.emailController.text.isNotEmpty) {
      customerRegisterProvider.addEmail(
        context: context,
      );
      FocusScope.of(context).unfocus();
    } else {
      ShowErrorMessage.showErrorMessage(
        error: "Digite um e-mail válido!",
        context: context,
      );
    }
  }

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
                addEmail(customerRegisterProvider: customerRegisterProvider);
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
                } else if (!RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                    .hasMatch(value)) {
                  return 'E-mail inválido';
                } else if (RegExp(r"[^a-zA-Z0-9._%+-@]").hasMatch(value)) {
                  return 'Caracteres especiais não são permitidos';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                addEmail(customerRegisterProvider: customerRegisterProvider);
              },
              child: const Text(
                "Adicionar e-mail",
              ),
            ),
            if (customerRegisterProvider.emailsCount > 0)
              const CustomerRegisterEmailsInformeds(),
          ],
        ),
      ),
    );
  }
}

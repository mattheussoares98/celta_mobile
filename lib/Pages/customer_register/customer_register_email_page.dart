import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import './components/components.dart';

class CustomerRegisterEmailPage extends StatefulWidget {
  final GlobalKey<FormState> emailFormKey;
  final Function validateAdressFormKey;
  final TextEditingController emailController;
  const CustomerRegisterEmailPage({
    required this.validateAdressFormKey,
    required this.emailFormKey,
    required this.emailController,
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

    if (isValid && widget.emailController.text.isNotEmpty) {
      customerRegisterProvider.addEmail(widget.emailController);

      if (customerRegisterProvider.errorMessageAddEmail == "") {
        FocusScope.of(context).unfocus();
      } else {
        ShowSnackbarMessage.show(
          message: customerRegisterProvider.errorMessageAddEmail,
          context: context,
        );
      }
    } else {
      ShowSnackbarMessage.show(
        message: "Digite um e-mail válido!",
        context: context,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return SingleChildScrollView(
      primary: false,
      child: Form(
        key: widget.emailFormKey,
        child: Column(
          children: [
            FormFieldWidget(
              enabled: true,
              focusNode: emailFocusNode,
              onFieldSubmitted: (String? value) {
                addEmail(customerRegisterProvider: customerRegisterProvider);
              },
              suffixWidget: IconButton(
                  onPressed: () {
                    widget.emailController.clear();
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              labelText: "E-mail",
              textEditingController: widget.emailController,
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
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ElevatedButton(
                onPressed: () {
                  addEmail(customerRegisterProvider: customerRegisterProvider);
                },
                child: const Text(
                  "Adicionar e-mail",
                ),
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

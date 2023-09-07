import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:flutter/material.dart';

class CustomerRegisterTelephonesPage extends StatefulWidget {
  final GlobalKey<FormState> telephoneFormKey;
  const CustomerRegisterTelephonesPage({
    required this.telephoneFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterTelephonesPage> createState() =>
      _CustomerRegisterTelephonesPageState();
}

class _CustomerRegisterTelephonesPageState
    extends State<CustomerRegisterTelephonesPage> {
  final FocusNode telephonesFocusNode = FocusNode();
  final TextEditingController telephonesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.telephoneFormKey,
      child: CustomerRegisterFormField(
        keyboardType: TextInputType.number,
        enabled: true,
        focusNode: telephonesFocusNode,
        onFieldSubmitted: (String? value) {
          //executar o validate do email
          // if (emailController.text.isEmpty) {
          //   return;
          // }
          // customerRegisterProvider.addEmail(
          //   emailController: emailController,
          //   context: context,
          // );
        },
        labelText: "Telefone",
        textEditingController: telephonesController,
        limitOfCaracters: 10,
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
              // customerRegisterProvider.addEmail(
              //   emailController: emailController,
              //   context: context,
              // );
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
    );
  }
}

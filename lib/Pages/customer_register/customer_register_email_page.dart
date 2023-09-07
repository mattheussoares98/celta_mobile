import 'package:celta_inventario/components/Customer_register/customer_register_form_field.dart';
import 'package:celta_inventario/providers/customer_register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerRegisterEmailPage extends StatefulWidget {
  final GlobalKey<FormState> emailFormKey;
  const CustomerRegisterEmailPage({
    required this.emailFormKey,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomerRegisterEmailPage> createState() =>
      _CustomerRegisterEmailPageState();
}

class _CustomerRegisterEmailPageState extends State<CustomerRegisterEmailPage> {
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CustomerRegisterProvider customerRegisterProvider = Provider.of(context);

    return Form(
      key: widget.emailFormKey,
      child: Column(
        children: [
          CustomerRegisterFormField(
            enabled: true,
            focusNode: emailFocusNode,
            onFieldSubmitted: (String? value) {
              //executar o validate do email
              if (emailController.text.isEmpty) {
                return;
              }
              customerRegisterProvider.addEmail(
                emailController: emailController,
                context: context,
              );
              FocusScope.of(context).unfocus();
            },
            labelText: "E-mail",
            textEditingController: emailController,
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
                    emailController: emailController,
                    context: context,
                  );
                  FocusScope.of(context).unfocus();
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
              margin: const EdgeInsets.only(top: 5),
              height:
                  double.parse("${customerRegisterProvider.emailsCount * 50}"),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: customerRegisterProvider.emailsCount,
                itemBuilder: (context, index) {
                  String email = customerRegisterProvider.emails[index];
                  return Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: index.isEven ? Colors.grey[300] : Colors.white,
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
    );
  }
}

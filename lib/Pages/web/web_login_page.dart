import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import 'package:celta_inventario/api/api.dart';
import 'package:celta_inventario/components/global_widgets/global_widgets.dart';
import 'package:celta_inventario/pages/web/web_home_page.dart';
import 'package:celta_inventario/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/utils.dart';

class WebLoginPage extends StatefulWidget {
  const WebLoginPage({super.key});

  @override
  State<WebLoginPage> createState() => _WebLoginPageState();
}

class _WebLoginPageState extends State<WebLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final key = GlobalKey<FormState>();

  Future<void> login() async {
    bool isValid = key.currentState!.validate();

    if (!isValid) return;

    final userCredential = await FirebaseHelper.signIn(
      email: emailController.text,
      password: passwordController.text,
    );

    if (userCredential != null) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(APPROUTES.WEB_HOME, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    WebProvider webProvider = Provider.of(context);

    return FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget(
              message: "Aguarde...",
              isLoading: false,
            );
          } else if (snapshot.hasData) {
            return const WebHomePage();
          }

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text("Login"),
                  actions: null,
                  leading: const Text(""),
                ),
                body: Form(
                  key: key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: FormFieldHelper.decoration(
                            isLoading: false,
                            context: context,
                          ),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return "E-mail inválido";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!)) {
                              return "E-mail inválido";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          onFieldSubmitted: (_) async {
                            await login();
                          },
                          decoration: FormFieldHelper.decoration(
                            isLoading: false,
                            context: context,
                          ),
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return "Preencha a senha";
                            } else if (value!.length < 3) {
                              return "Senha curta";
                            }

                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () async {
                            await login();
                          },
                          child: const Text("Efetuar login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              loadingWidget(
                message: "Efetuando login...",
                isLoading: webProvider.isLoadingClients,
              ),
            ],
          );
        });
  }
}

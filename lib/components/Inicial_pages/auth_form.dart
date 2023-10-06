import 'package:celta_inventario/api/prefs_instance.dart';
import 'package:celta_inventario/components/Global_widgets/formfield_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';

class AuthForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const AuthForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animationWidth;
  Animation<double>? _animationBorder;

  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();

  _submit({required LoginProvider loginProvider}) async {
    bool isValid = widget.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    await loginProvider.login(
      user: loginProvider.userController.text,
      password: loginProvider.passwordController.text,
      context: context,
      enterpriseNameOrUrlCCSController:
          loginProvider.enterpriseNameOrUrlCCSController,
    );

    if (loginProvider.errorMessage == '') {
      loginProvider.passwordController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animationBorder = Tween<double>(
      begin: 0,
      end: 20,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(
          0.7,
          1,
        ), //esse intervalo é o proporcional do tempo de animação, levando em conta que o tempo de animação é 1. Se a animação for de um segundo, vai executar a animação a partir de 0,6 do tempo de animação até 1 de animação
      ),
    );
  }

  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    LoginProvider loginProvider = Provider.of(context, listen: true);

    if (!isLoaded) {
      await loginProvider.verifyIsLogged();

      await PrefsInstance.restoreUserAndEnterpriseNameOrUrlCCS(
        enterpriseNameOrUrlCCSController:
            loginProvider.enterpriseNameOrUrlCCSController,
        userController: loginProvider.userController,
      );

      isLoaded = true;
    }
  }

  @override //essa função serve para liberar qualquer tipo de memória que esteja sendo utilizado por esses FocusNode e Listner
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);

    _animationWidth = Tween<double>(
      begin: 0,
      end: MediaQuery.of(context).size.width,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(
          0,
          0.7,
        ), //esse intervalo é o proporcional do tempo de animação, levando em conta que o tempo de animação é 1.
      ),
    ); //precisei colocar o _animationWidget aqui porque
    //executando no initState da erro, pois o mediaquery ainda não havia
    //conseguido pegar o tamanho da largura do dispositivo

    _animationController!.forward();

    return Card(
      margin: const EdgeInsets.all(20),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: widget.formKey,
          child: AnimatedBuilder(
            animation: _animationController!,
            builder: (context, widget) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: _animationWidth!.value,
                    child: TextFormField(
                      enabled: loginProvider.isLoading ? false : true,
                      controller: loginProvider.userController,
                      focusNode: _userFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      validator: (_name) {
                        _name = loginProvider.userController.text;
                        if (loginProvider.userController.text.trim().isEmpty) {
                          return 'Preencha o nome';
                        }

                        loginProvider.userController.text =
                            loginProvider.userController.text.trimRight();
                        //fiz isso porque quando termina com espaço, a API retorna que a senha está
                        //inválida ao invés do usuário inválido e ninguém cadastra usuário com
                        //espaço no final do nome

                        return null;
                      },
                      style: FormFieldHelper.style(),
                      decoration: FormFieldHelper.decoration(
                        isLoading: loginProvider.isLoading,
                        context: context,
                        labelText: "Usuário",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: _animationWidth!.value,
                    child: TextFormField(
                      controller: loginProvider.passwordController,
                      enabled: loginProvider.isLoading ? false : true,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_urlFocusNode),
                      style: FormFieldHelper.style(),
                      validator: (_name) {
                        _name = loginProvider.passwordController.text;
                        if (loginProvider.passwordController.text
                            .trim()
                            .isEmpty) {
                          return 'Preencha a senha';
                        }
                        return null;
                      },
                      decoration: FormFieldHelper.decoration(
                        isLoading: loginProvider.isLoading,
                        context: context,
                        labelText: "Senha",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: _passwordVisible
                              ? Icon(
                                  Icons.remove_red_eye,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                ),
                        ),
                      ),
                      obscureText: _passwordVisible ? false : true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: _animationWidth!.value,
                    child: TextFormField(
                      onChanged: (value) {
                        loginProvider.changedEnterpriseNameOrUrlCcs = true;
                      },
                      enabled: loginProvider.isLoading ? false : true,
                      controller:
                          loginProvider.enterpriseNameOrUrlCCSController,
                      onFieldSubmitted: (_) =>
                          _submit(loginProvider: loginProvider),
                      focusNode: _urlFocusNode,
                      style: FormFieldHelper.style(),
                      validator: (_url) {
                        _url =
                            loginProvider.enterpriseNameOrUrlCCSController.text;
                        if (loginProvider.enterpriseNameOrUrlCCSController.text
                            .toLowerCase()
                            .trim()
                            .isEmpty) {
                          return 'Digite o nome da empresa ou URL do CCS';
                        }
                        // else if (!loginProvider.enterpriseNameOrUrlCCSController.text
                        //         .contains('http') ||
                        //     !loginProvider.enterpriseNameOrUrlCCSController.text.contains('//') ||
                        //     !loginProvider.enterpriseNameOrUrlCCSController.text.contains(':') ||
                        //     !loginProvider.enterpriseNameOrUrlCCSController.text.contains('ccs')) {
                        //   return 'URL inválida';
                        // }
                        return null;
                      },
                      decoration: FormFieldHelper.decoration(
                        isLoading: loginProvider.isLoading,
                        context: context,
                        labelText: "Nome da empresa ou CCS",
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, widget) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(_animationWidth!.value, 60),
                        backgroundColor: loginProvider.isLoading
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        maximumSize: Size(_animationWidth!.value, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(_animationBorder!.value),
                        ),
                      ),
                      onPressed: loginProvider.isLoading
                          ? null
                          : () => _submit(
                                loginProvider: loginProvider,
                              ),
                      child: loginProvider.isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 4,
                              color: Colors.grey,
                            )
                          : const FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  'Login',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

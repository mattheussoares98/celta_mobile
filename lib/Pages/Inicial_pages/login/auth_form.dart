import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../providers/providers.dart';
import '../../../components/components.dart';
import '../../../utils/utils.dart';

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
  final userController = TextEditingController();
  final enterpriseNameController = TextEditingController();
  final passwordController = TextEditingController();
  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();

  Future<void> _submit({required LoginProvider loginProvider}) async {
    bool isValid = widget.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    await loginProvider.login(
      user: userController.text,
      password: passwordController.text,
      context: context,
      enterpriseName: enterpriseNameController,
    );
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
        curve: const Interval(0.7, 1),
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

      await PrefsInstance.updateUserAndEnterpriseName(
        enterpriseNameController: enterpriseNameController,
        userController: userController,
      );

      isLoaded = true;
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    userController.dispose();
    enterpriseNameController.dispose();
    passwordController.dispose();
    _userFocusNode.dispose();
    _passwordFocusNode.dispose();
    _urlFocusNode.dispose();
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
        curve: const Interval(0, 0.7),
      ),
    );

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
                      controller: userController,
                      focusNode: _userFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      validator: (_name) {
                        _name = userController.text;
                        if (userController.text.trim().isEmpty) {
                          return 'Preencha o nome';
                        }

                        userController.text = userController.text.trimRight();
                        //fiz isso porque quando termina com espaço, a API retorna que a senha está
                        //inválida ao invés do usuário inválido e ninguém cadastra usuário com
                        //espaço no final do nome

                        return null;
                      },
                      style: FormFieldStyle.style(),
                      decoration: FormFieldDecoration.decoration(
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
                      controller: passwordController,
                      enabled: loginProvider.isLoading ? false : true,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_urlFocusNode),
                      style: FormFieldStyle.style(),
                      validator: (_name) {
                        _name = passwordController.text;
                        if (passwordController.text.trim().isEmpty) {
                          return 'Preencha a senha';
                        }
                        return null;
                      },
                      decoration: FormFieldDecoration.decoration(
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
                      controller: enterpriseNameController,
                      onFieldSubmitted: (_) async {
                        await _submit(loginProvider: loginProvider);
                      },
                      focusNode: _urlFocusNode,
                      style: FormFieldStyle.style(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o nome da empresa!';
                        } else if (ConvertString.isUrl(value)) {
                          return 'Login pelo CCS desabilitado!';
                        }

                        return null;
                      },
                      decoration: FormFieldDecoration.decoration(
                        isLoading: loginProvider.isLoading,
                        context: context,
                        labelText: "Nome da empresa",
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
                          : () async {
                              await _submit(
                                loginProvider: loginProvider,
                              );
                            },
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

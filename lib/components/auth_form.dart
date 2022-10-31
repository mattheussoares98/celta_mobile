import 'package:celta_inventario/utils/base_url.dart';
import 'package:celta_inventario/utils/show_error_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/login_provider.dart';

class AuthForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const AuthForm({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  @override
  State<AuthForm> createState() => _AuthFormState();
}

TextEditingController _urlController = TextEditingController();
TextEditingController _userController = TextEditingController();
TextEditingController _passwordController = TextEditingController();

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animationWidth;
  Animation<double>? _animationBorder;

  final _userFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _urlFocusNode = FocusNode();

  _saveUserAndUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', _urlController.text);
    await prefs.setString('user', _userController.text);
  }

  _submit({required LoginProvider loginProvider}) async {
    bool isValid = widget.formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    await _saveUserAndUrl();

    await loginProvider.login(
      user: _userController.text,
      password: _passwordController.text,
      baseUrl: _urlController.text,
    );

    if (loginProvider.errorMessage != '') {
      ShowErrorMessage.showErrorMessage(
        error: loginProvider.errorMessage,
        context: context,
      );
    } else {
      _passwordController.clear();
    }

    BaseUrl.url = _urlController.text;
  }

  _restoreUserAndUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //logo que instala o app, logicamente ainda não tem nada salvo nas URLs se
    //não fizer essa verificação, vai dar erro no debug console
    if (prefs.getString('url') == null || prefs.getString('user') == null) {
      return;
    }

    _urlController.text = prefs.getString('url')!;
    _userController.text = prefs.getString('user')!;
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
    _restoreUserAndUrl();
  }

  @override //essa função serve para liberar qualquer tipo de memória que esteja sendo utilizado por esses FocusNode e Listner
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider _loginProvider = Provider.of(context, listen: true);

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
                      enabled: _loginProvider.isLoading ? false : true,
                      controller: _userController,
                      focusNode: _userFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_passwordFocusNode),
                      validator: (_name) {
                        _name = _userController.text;
                        if (_userController.text.trim().isEmpty) {
                          return 'Preencha o nome';
                        }

                        _userController.text = _userController.text.trimRight();
                        //fiz isso porque quando termina com espaço, a API retorna que a senha está
                        //inválida ao invés do usuário inválido e ninguém cadastra usuário com
                        //espaço no final do nome

                        return null;
                      },
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                        decorationColor: Colors.black,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        labelText: 'Usuário',
                        counterStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: _animationWidth!.value,
                    child: TextFormField(
                      controller: _passwordController,
                      enabled: _loginProvider.isLoading ? false : true,
                      focusNode: _passwordFocusNode,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_urlFocusNode),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                        decorationColor: Colors.black,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      validator: (_name) {
                        _name = _passwordController.text;
                        if (_passwordController.text.trim().isEmpty) {
                          return 'Preencha a senha';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        labelText: 'Senha',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: _animationWidth!.value,
                    child: TextFormField(
                      enabled: _loginProvider.isLoading ? false : true,
                      controller: _urlController,
                      onFieldSubmitted: (_) =>
                          _submit(loginProvider: _loginProvider),
                      focusNode: _urlFocusNode,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontFamily: 'OpenSans',
                        decorationColor: Colors.black,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      validator: (_url) {
                        _url = _urlController.text;
                        if (_urlController.text.trim().isEmpty) {
                          return 'Preencha a url';
                        } else if (!_urlController.text.contains('http') ||
                            !_urlController.text.contains('//') ||
                            !_urlController.text.contains(':')) {
                          return 'URL inválida';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        labelText: 'URL',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedBuilder(
                    animation: _animationController!,
                    builder: (context, widget) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(_animationWidth!.value, 60),
                        maximumSize: Size(_animationWidth!.value, 60),
                        primary: _loginProvider.isLoading
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(_animationBorder!.value),
                        ),
                      ),
                      onPressed: _loginProvider.isLoading
                          ? null
                          : () => _submit(
                                loginProvider: _loginProvider,
                              ),
                      child: _loginProvider.isLoading
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

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../pages/Inicial_pages/inicial_pages.dart';
import '../../../providers/providers.dart';

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

  bool allControllersAreFilled() {
    return userController.text.isNotEmpty &&
        enterpriseNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Future<void> _doLogin(LoginProvider loginProvider) async {
    if (widget.formKey.currentState!.validate() != true) {
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
                  NameField(
                    animationWidth: _animationWidth!,
                    userController: userController,
                    userFocusNode: _userFocusNode,
                    passwordFocusNode: _passwordFocusNode,
                    allControllersAreFilled: allControllersAreFilled(),
                    doLogin: () async {
                      await _doLogin(loginProvider);
                    },
                  ),
                  const SizedBox(height: 10),
                  PasswordField(
                    animationWidth: _animationWidth!,
                    passwordController: passwordController,
                    passwordFocusNode: _passwordFocusNode,
                    urlFocusNode: _urlFocusNode,
                    allControllersAreFilled: allControllersAreFilled(),
                    doLogin: () async {
                      await _doLogin(loginProvider);
                    },
                  ),
                  const SizedBox(height: 10),
                  EnterpriseField(
                    enterpriseNameController: enterpriseNameController,
                    doLogin: () async {
                      await _doLogin(loginProvider);
                    },
                    animationWidth: _animationWidth!,
                    urlFocusNode: _urlFocusNode,
                  ),
                  const SizedBox(height: 20),
                  LoginButton(
                    animationController: _animationController!,
                    animationWidth: _animationWidth!,
                    animationBorder: _animationBorder!,
                    doLogin: () async {
                      await _doLogin(loginProvider);
                    },
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

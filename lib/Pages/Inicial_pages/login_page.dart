import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:platform_plus/platform_plus.dart';

import '../../api/api.dart';
import '../../components/global_widgets/global_widgets.dart';
import '../../components/inicial_pages/inicial_pages.dart';
import '../../utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animationOpacity;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(
          0,
          1,
        ), //esse intervalo é o proporcional do tempo de animação, levando em conta que o tempo de animação é 1. Se a animação for de um segundo, vai executar a animação a partir de 0,6 do tempo de animação até 1 de animação
      ),
    );

    super.initState();
    showMessageToInstallApp();
  }

  Future<void> showMessageToInstallApp() async {
    if (PlatformPlus.platform.isAndroidWeb) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Instalar aplicativo?",
        subtitle:
            "Você está usando o site por um android, por isso o ideal é utilizar o aplicativo\n\nDeseja instalar o aplicativo?",
        function: () {
          UrlLauncher.searchAndLaunchUrl(
            url:
                "https://play.google.com/store/apps/details?id=br.com.celtaware.inventario",
            context: context,
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController!.forward();
    final _key = GlobalKey<FormState>();
    return Scaffold(
      resizeToAvoidBottomInset: kIsWeb ? false : true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(51, 255, 51, 1),
                  Color.fromRGBO(0, 102, 0, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
    primary: false, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: AnimatedBuilder(
                      animation: _animationController!,
                      child: FadeTransition(
                        opacity: _animationOpacity!,
                        child: Container(
                          transform: Matrix4.rotationZ(-8 * pi / 180)
                            ..translate(-10.0),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: const FittedBox(
                            child: Text(
                              'Celta mobile',
                              style: TextStyle(
                                fontSize: 100,
                                color: ColorsTheme.text,
                                fontFamily: 'BebasNeue',
                              ),
                            ),
                          ),
                        ),
                      ),
                      builder: (context, child) {
                        return child!;
                      },
                    ),
                  ),
                  AuthForm(
                    formKey: _key,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

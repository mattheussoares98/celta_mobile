// import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api/api.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animationOpacity;
  Animation? _animationScale;

  Future<void> initFirebaseMessageAndGetLocalNotifications() async {
    NotificationsProvider notificationsProvider =
        Provider.of(context, listen: false);
    await FirebaseHelper.initNotifications(notificationsProvider);
  }

  @override
  void initState() {
    initFirebaseMessageAndGetLocalNotifications();

    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationScale = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(_animationController!);

    _animationOpacity = Tween<double>(
      begin: 0.2,
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

    Future.delayed(const Duration(seconds: 3), () {
      if (kIsWeb /* || Platform.isWindows */) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(APPROUTES.WEB_LOGIN, (route) => false);
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            APPROUTES.LOGIN_OR_HOME_PAGE, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController!.forward();

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          builder: (context, widget) {
            return Transform.scale(
              scale: _animationScale!.value,
              child: widget,
            );
          },
          animation: _animationScale!,
          child: FadeTransition(
            opacity: _animationOpacity!,
            child: Image.asset('lib/assets/Images/LogoCeltaTransparente.png'),
          ),
        ),
      ),
    );
  }
}

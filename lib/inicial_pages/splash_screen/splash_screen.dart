import 'package:celta_inventario/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animationOpacity;
  Animation? _animationScale;

  @override
  void initState() {
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
      Navigator.of(context).pushNamedAndRemoveUntil(
          APPROUTES.LOGIN_OR_HOME_PAGE, (route) => false);
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

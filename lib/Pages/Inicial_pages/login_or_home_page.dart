import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../providers/providers.dart';
import '../home/home.dart';
import '../login/login.dart';

class AuthOrHoMePage extends StatefulWidget {
  const AuthOrHoMePage({Key? key}) : super(key: key);

  @override
  State<AuthOrHoMePage> createState() => _AuthOrHoMePageState();
}

class _AuthOrHoMePageState extends State<AuthOrHoMePage> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);

    return Scaffold(
      body: StreamBuilder<bool>(
        stream: loginProvider.authStream,
        builder: (context, snapshot) {
          if (snapshot.data == false || snapshot.data == null) {
            return const LoginPage();
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}

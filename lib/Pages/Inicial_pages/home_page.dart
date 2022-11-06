import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:celta_inventario/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/login_provider.dart';
import '../../components/image_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: ColorsTheme.text,
            ),
            onPressed: () async {
              ShowAlertDialog().showAlertDialog(
                context: context,
                title: 'Deseja fazer o logout?',
                function: () async {
                  await loginProvider.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      APPROUTES.LOGIN_OR_HOME_PAGE, (route) => false);
                },
              );
            },
          ),
        ],
        title: const Center(
          child: const FittedBox(
            child: Text(
              'Selecione a rotina desejada',
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/consultPrice.jpg',
              routine: 'Consulta de preços',
              route: APPROUTES.ENTERPRISE,
              nextRoute: APPROUTES.PRICE_CONFERENCE,
              context: context,
            ),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/inventory.jpg',
              routine: 'Inventário',
              route: APPROUTES.ENTERPRISE,
              nextRoute: APPROUTES.INVENTORY,
              context: context,
            ),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/receipt.jpg',
              routine: 'Recebimento de mercadorias',
              route: APPROUTES.ENTERPRISE,
              nextRoute: APPROUTES.RECEIPT,
              context: context,
            ),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/adjustStock.jpg',
              routine: 'Ajuste de estoque',
              route: APPROUTES.ENTERPRISE,
              nextRoute: APPROUTES.ADJUST_STOCK,
              context: context,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

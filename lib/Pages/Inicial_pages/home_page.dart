import 'package:celta_inventario/utils/app_routes.dart';
import 'package:celta_inventario/utils/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/Global_widgets/image_component.dart';
import '../../Components/Global_widgets/show_alert_dialog.dart';
import '../../providers/login_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    LoginProvider loginProvider = Provider.of(context, listen: true);
    super.didChangeDependencies();

    if (!isLoaded) {
      await loginProvider.restoreBaseUrl();
      userName = await loginProvider.getUserName();
      setState(() {});

      isLoaded = true;
    }
  }

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
        title: Center(
          child: Text(
            userName,
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2, // define o número de colunas
        childAspectRatio: 1.2, // define a proporção de largura/altura dos itens
        padding: const EdgeInsets.only(top: 8),
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        children: [
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
          ImageComponent.image(
            imagePath: 'lib/assets/Images/transferBetweenStocks.jpg',
            routine: 'Transferência entre estoques',
            route: APPROUTES.ENTERPRISE,
            nextRoute: APPROUTES.TRANSFER_BETWEEN_STOCK,
            context: context,
          ),
          ImageComponent.image(
            imagePath: 'lib/assets/Images/saleRequest.jpg',
            routine: 'Pedido de vendas',
            route: APPROUTES.ENTERPRISE,
            nextRoute: APPROUTES.SALE_REQUEST_MODEL,
            context: context,
          ),
          ImageComponent.image(
            imagePath: 'lib/assets/Images/transfer.jpg',
            routine: 'Pedido de transferência',
            route: APPROUTES.TRANSFER_REQUEST_MODEL,
            nextRoute: APPROUTES.TRANSFER_ORIGIN_ENTERPRISE,
            context: context,
          ),
        ],
      ),
    );
  }
}

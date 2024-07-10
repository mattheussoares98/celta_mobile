import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../components/global_widgets/global_widgets.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!isLoaded) {
      UserData.userName = await PrefsInstance.getUserName();

      setState(() {});
      ConfigurationsProvider configurationsProvider =
          Provider.of(context, listen: false);
      await configurationsProvider.restoreConfigurations();

      isLoaded = true;
    }
  }

  int returnSize() {
    if (MediaQuery.of(context).size.width > 900) {
      return 4;
    } else if (MediaQuery.of(context).size.width > 600) {
      return 3;
    } else
      return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            UserData.userName,
          ),
        ),
        // actions: [
        //   Stack(
        //     children: [
        //       IconButton(
        //         icon: const Icon(
        //           Icons.notifications_active,
        //           color: Colors.white,
        //           size: 33,
        //           shadows: [
        //             Shadow(
        //               offset: Offset(1, 1),
        //               blurRadius: 3.0,
        //               color: Colors.black,
        //             ),
        //           ],
        //         ),
        //         //se não houver um modelo de pedido padrão informado,
        //         //desativa o botão pra ir até o carrinho
        //         onPressed: () {
        //           setState(() {
        //             Navigator.of(context).pushNamed(APPROUTES.NOTIFICATIONS);
        //           });
        //         },
        //       ),
        //       if (notificationsProvider.hasUnreadNotifications)
        //         Positioned(
        //           top: 0,
        //           right: 6,
        //           child: CircleAvatar(
        //             backgroundColor: Colors.red,
        //             child: Container(),
        //             maxRadius: 9,
        //           ),
        //         ),
        //     ],
        //   ),
        // ],
      ),
      drawer: const MyDrawer(),
      body: PopScope(
        canPop: false,
        onPopInvoked: (_) async {
          ShowAlertDialog.showAlertDialog(
            context: context,
            title: "Fechar o aplicativo",
            subtitle: "Deseja realmente fechar o aplicativo?",
            function: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          );
        },
        child: GridView.count(
          crossAxisCount: returnSize(), // define o número de colunas
          childAspectRatio: MediaQuery.of(context).size.width > 900
              ? 1.4
              : 1.4, // define a proporção de largura/altura dos itens
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 0.0,
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
            // ImageComponent.image(
            //   imagePath: 'lib/assets/Images/transferBetweenStocks.jpg',
            //   routine: 'Transferência entre embalagens',
            //   route: APPROUTES.ENTERPRISE,
            //   nextRoute: APPROUTES.TRANSFER_BETWEEN_PACKAGE,
            //   context: context,
            // ),
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
            ImageComponent.image(
              imagePath: 'lib/assets/Images/newClient.jpg',
              routine: 'Cadastro de clientes',
              route: APPROUTES.CUSTOMER_REGISTER,
              context: context,
            ),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/buyRequest.jpg',
              routine: 'Pedido de compras',
              route: APPROUTES.BUYERS,
              // nextRoute: APPROUTES.BUYERS,
              context: context,
            ),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/search_concurrent_price.jpg',
              routine: 'Preços concorrentes',
              route: APPROUTES.ENTERPRISE,
              nextRoute: APPROUTES.RESEARCH_PRICES,
              context: context,
            ),
            ImageComponent.image(
              imagePath: 'lib/assets/Images/LogoCeltaTransparente.png',
              routine: 'Alteração de preços',
              route: APPROUTES.ENTERPRISE,
              nextRoute: APPROUTES.ADJUST_SALE_PRICE,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}

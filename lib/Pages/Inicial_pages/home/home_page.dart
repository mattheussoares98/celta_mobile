import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int returnSize() {
    if (MediaQuery.of(context).size.width > 900) {
      return 4;
    } else if (MediaQuery.of(context).size.width > 600) {
      return 3;
    } else
      return 2;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        EnterpriseProvider enterpriseProvider =
            Provider.of(context, listen: false);

        UserData.userName = await PrefsInstance.getString(PrefsKeys.user);

        setState(() {});
        ConfigurationsProvider configurationsProvider =
            Provider.of(context, listen: false);
        await configurationsProvider.restoreConfigurations();
        await enterpriseProvider.updateFirebaseEnterpriseModel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider = Provider.of(context);

    debugPrint("Width: ${MediaQuery.of(context).size.width}");
    debugPrint("Height: ${MediaQuery.of(context).size.height}");

    return Stack(
      children: [
        Scaffold(
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
            onPopInvokedWithResult: (_, __) async {
              ShowAlertDialog.show(
                context: context,
                title: "Fechar o aplicativo",
                content: const SingleChildScrollView(
                  child: Text(
                    "Deseja realmente fechar o aplicativo?",
                    textAlign: TextAlign.center,
                  ),
                ),
                function: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              );
            },
            child: Column(
              children: [
                if (enterpriseProvider.firebaseEnterpriseModel == null)
                  searchAgain(
                    errorMessage: enterpriseProvider.errorMessage,
                    request: enterpriseProvider.updateFirebaseEnterpriseModel,
                  ),
                if (enterpriseProvider.firebaseEnterpriseModel != null)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount:
                          returnSize(), // define o número de colunas
                      childAspectRatio:
                          1.7, // define a proporção de largura/altura dos itens
                      mainAxisSpacing: 0.0,
                      crossAxisSpacing: 0.0,
                      shrinkWrap: true,
                      children: [
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/adjustPrice.png',
                          routine: 'Alteração de preços'.toUpperCase(),
                          nextRoute: APPROUTES.ADJUST_SALE_PRICE_PRODUCTS,
                          context: context,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/adjustStock.png',
                          routine: 'Ajuste de estoque'.toUpperCase(),
                          nextRoute: APPROUTES.ADJUST_STOCK,
                          context: context,
                        ),
                        // ImageComponent.image(
                        //   imagePath: 'lib/assets/Images/LogoCeltaTransparente.png',
                        //   routine: 'Avaliação e sugestôes'.toUpperCase(),
                        //   context: context,

                        //   moduleIsLiberated: true,
                        // ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/newClient.png',
                          routine: 'Cadastro de clientes'.toUpperCase(),
                          context: context,
                          onlyForValidateModule: true,
                          nextRoute: APPROUTES.CUSTOMER_REGISTER,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/productsConference.png',
                          routine: 'Conferência de produtos (expedição)'
                              .toUpperCase(),
                          nextRoute: APPROUTES
                              .EXPEDITION_CONFERENCE_CONTROLS_TO_CONFERENCE,
                          context: context,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/consultPrice.png',
                          routine: 'Consulta de preços'.toUpperCase(),
                          nextRoute: APPROUTES.PRICE_CONFERENCE,
                          context: context,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/buyQuotation.png',
                          routine: 'Cotação de compras'.toUpperCase(),
                          nextRoute: APPROUTES.BUY_QUOTATION,
                          context: context,
                          isNew: true,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/inventory.png',
                          routine: 'Inventário'.toUpperCase(),
                          nextRoute: APPROUTES.INVENTORY,
                          context: context,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/buyRequest.png',
                          routine: 'Pedido de compras'.toUpperCase(),
                          nextRoute: APPROUTES.BUYERS,
                          context: context,
                          onlyForValidateModule: true,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/transfer.png',
                          routine: 'Pedido de transferência'.toUpperCase(),
                          nextRoute: APPROUTES.TRANSFER_REQUEST_MODEL,
                          context: context,
                          onlyForValidateModule: true,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/saleRequest.png',
                          routine: 'Pedido de vendas'.toUpperCase(),
                          nextRoute: APPROUTES.SALE_REQUEST_MODEL,
                          context: context,
                        ),
                        ImageComponent.image(
                          imagePath:
                              'lib/assets/Images/searchConcurrentPrice.png',
                          routine: 'Preços concorrentes'.toUpperCase(),
                          nextRoute: APPROUTES.RESEARCH_PRICES,
                          context: context,
                        ),
                        ImageComponent.image(
                          imagePath: 'lib/assets/Images/receipt.jpg',
                          routine: 'Recebimento de mercadorias'.toUpperCase(),
                          nextRoute: APPROUTES.RECEIPT,
                          context: context,
                        ),

                        ImageComponent.image(
                          imagePath:
                              'lib/assets/Images/transferBetweenStocks.png',
                          routine: 'Transferência entre estoques'.toUpperCase(),
                          nextRoute: APPROUTES.TRANSFER_BETWEEN_STOCK,
                          context: context,
                        ),
                        // ImageComponent.image(
                        //   imagePath: 'lib/assets/Images/transferBetweenStocks.jpg',
                        //   routine: 'Transferência entre embalagens'.toUpperCase(),
                        //   nextRoute: APPROUTES.TRANSFER_BETWEEN_PACKAGE,
                        //   context: context,
                        // ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        loadingWidget(enterpriseProvider.isLoading),
      ],
    );
  }
}

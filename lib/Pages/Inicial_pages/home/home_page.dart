import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../api/api.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import 'components/components.dart';
import 'components/my_drawer.dart';

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
                      children: ModulesItems.modules,
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

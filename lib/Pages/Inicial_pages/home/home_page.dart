import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';
import './components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? manualsUrl;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        EnterpriseProvider enterpriseProvider =
            Provider.of(context, listen: false);

        ConfigurationsProvider configurationsProvider =
            Provider.of(context, listen: false);
        await configurationsProvider.restoreConfigurations();
        manualsUrl = await configurationsProvider.getManualsUrl();
        await enterpriseProvider.updateFirebaseEnterpriseModel();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider = Provider.of(context);
    ConfigurationsProvider configurationsProvider = Provider.of(context);

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
                    child: ModulesItems(manualsUrl: manualsUrl),
                  ),
              ],
            ),
          ),
        ),
        loadingWidget(enterpriseProvider.isLoading),
        loadingWidget(configurationsProvider.isLoading),
      ],
    );
  }
}

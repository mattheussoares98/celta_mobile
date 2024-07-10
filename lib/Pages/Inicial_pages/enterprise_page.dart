import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => EnterprisePageState();
}

class EnterprisePageState extends State<EnterprisePage> {
  getEnterprises(EnterpriseProvider enterpriseProvider) async {
    await enterpriseProvider.getEnterprises();
  }

  @override
  void initState() {
    super.initState();
    EnterpriseProvider enterpriseProvider = Provider.of(context, listen: false);
    getEnterprises(enterpriseProvider);
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider =
        Provider.of<EnterpriseProvider>(context, listen: true);

    final String nextRoute =
        ModalRoute.of(context)!.settings.arguments as String;
    //essa rota vem para essa página através de um parâmetro do ImageComponent

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'EMPRESAS',
            ),
            actions: [
              IconButton(
                onPressed: enterpriseProvider.isLoadingEnterprises
                    ? null
                    : () async {
                        await enterpriseProvider.getEnterprises(
                          isConsultingAgain: true,
                        );
                      },
                tooltip: "Consultar empresas",
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await enterpriseProvider.getEnterprises(
                isConsultingAgain: true,
              );
            },
            child: Column(
              children: [
                if (enterpriseProvider.errorMessage != '' &&
                    !enterpriseProvider.isLoadingEnterprises)
                  Expanded(
                    child: searchAgain(
                      errorMessage: enterpriseProvider.errorMessage,
                      request: () async {
                        setState(() {});
                        await getEnterprises(enterpriseProvider);
                      },
                    ),
                  ),
                if (enterpriseProvider.errorMessage == "" &&
                    !enterpriseProvider.isLoadingEnterprises)
                  Expanded(child: EnterpriseItems(nextPageRoute: nextRoute)),
              ],
            ),
          ),
        ),
        loadingWidget(
          message: "Consultando empresas...",
          isLoading: enterpriseProvider.isLoadingEnterprises,
        )
      ],
    );
  }
}

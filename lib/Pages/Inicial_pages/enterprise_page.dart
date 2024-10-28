import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../providers/providers.dart';
import '../../utils/utils.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => EnterprisePageState();
}

class EnterprisePageState extends State<EnterprisePage> {
  Future<void> getEnterprises(EnterpriseProvider enterpriseProvider) async {
    final String nextRoute =
        ModalRoute.of(context)!.settings.arguments as String;

    await enterpriseProvider.getEnterprises(
      verifyUserCanAdjustSalePrice:
          nextRoute == APPROUTES.ADJUST_SALE_PRICE_PRODUCTS,
    );
  }

  @override
  void initState() {
    super.initState();

    EnterpriseProvider enterpriseProvider = Provider.of(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await getEnterprises(enterpriseProvider);
      }
    });
  }

  bool canShowEnterprises({
    required EnterpriseProvider enterpriseProvider,
    required String nextRoute,
  }) {
    if (enterpriseProvider.isLoading) {
      return false;
    } else if (enterpriseProvider.errorMessage != "") {
      return false;
    } else if (enterpriseProvider.enterprises.isEmpty) {
      return false;
    } else if (nextRoute == APPROUTES.ADJUST_SALE_PRICE_PRODUCTS &&
        !enterpriseProvider.userCanAdjustSalePrice) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseProvider enterpriseProvider =
        Provider.of<EnterpriseProvider>(context, listen: true);

    final String nextRoute =
        ModalRoute.of(context)!.settings.arguments as String;
    //essa rota vem para essa página através de um parâmetro do ImageComponent

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        enterpriseProvider.clearEnterprises();
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text(
                'EMPRESAS',
              ),
              actions: [
                IconButton(
                  onPressed: enterpriseProvider.isLoading
                      ? null
                      : () async {
                          await enterpriseProvider.getEnterprises();
                        },
                  tooltip: "Consultar empresas",
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () async {
                  await enterpriseProvider.getEnterprises();
                },
                child: Column(
                  children: [
                    if (!enterpriseProvider.isLoading &&
                        enterpriseProvider.errorMessage != '')
                      searchAgain(
                        errorMessage: enterpriseProvider.errorMessage,
                        request: () async {
                          await getEnterprises(enterpriseProvider);
                        },
                      ),
                    if (canShowEnterprises(
                      enterpriseProvider: enterpriseProvider,
                      nextRoute: nextRoute,
                    ))
                      EnterpriseItems(nextPageRoute: nextRoute),
                  ],
                ),
              ),
            ),
          ),
          loadingWidget(enterpriseProvider.isLoading)
        ],
      ),
    );
  }
}

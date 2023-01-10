import 'package:celta_inventario/Components/Global_widgets/enterprise_items.dart';
import 'package:celta_inventario/providers/enterprise_provider.dart';
import 'package:celta_inventario/Components/Global_widgets/consulting_widget.dart';
import 'package:celta_inventario/Components/Global_widgets/try_again.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/enterprise_provider.dart';

class EnterprisePage extends StatefulWidget {
  const EnterprisePage({Key? key}) : super(key: key);

  @override
  State<EnterprisePage> createState() => EnterprisePageState();
}

class EnterprisePageState extends State<EnterprisePage> {
  getEnterprises(EnterpriseProvider enterpriseProvider) async {
    await enterpriseProvider.getEnterprises(
      context: context,
    );
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMPRESAS',
        ),
      ),
      body: Column(
        children: [
          if (enterpriseProvider.isLoadingEnterprises)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando empresas'),
            ),
          if (enterpriseProvider.errorMessage != '' &&
              !enterpriseProvider.isLoadingEnterprises)
            Expanded(
              child: TryAgainWidget.tryAgain(
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
    );
  }
}

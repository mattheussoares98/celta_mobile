import 'package:celta_inventario/utils/consulting_widget.dart';
import 'package:celta_inventario/utils/try_again.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Components/Global_widgets/enterprise_json_items.dart';
import '../providers/enterprise_json_provider.dart';

///criei essa página diferente da EnterprisePage porque a consulta de empresas
///retorna informações diferentes da EnterprisePage. Essas informações são
///utilizadas somente no pedido de vendas
class EnterpriseJsonPage extends StatefulWidget {
  const EnterpriseJsonPage({Key? key}) : super(key: key);

  @override
  State<EnterpriseJsonPage> createState() => EnterprisePageSJsontate();
}

class EnterprisePageSJsontate extends State<EnterpriseJsonPage> {
  getEnterprises(EnterpriseJsonProvider enterpriseJsonProvider) async {
    await enterpriseJsonProvider.getEnterprises(
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    EnterpriseJsonProvider enterpriseJsonProvider =
        Provider.of(context, listen: false);
    getEnterprises(enterpriseJsonProvider);
  }

  @override
  Widget build(BuildContext context) {
    EnterpriseJsonProvider enterpriseJsonProvider =
        Provider.of<EnterpriseJsonProvider>(context, listen: true);

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
          if (enterpriseJsonProvider.isLoadingEnterprises)
            Expanded(
              child: ConsultingWidget.consultingWidget(
                  title: 'Consultando empresas'),
            ),
          if (enterpriseJsonProvider.errorMessage != '' &&
              !enterpriseJsonProvider.isLoadingEnterprises)
            Expanded(
              child: TryAgainWidget.tryAgain(
                errorMessage: enterpriseJsonProvider.errorMessage,
                request: () async {
                  setState(() {});
                  await getEnterprises(enterpriseJsonProvider);
                },
              ),
            ),
          if (enterpriseJsonProvider.errorMessage == "" &&
              !enterpriseJsonProvider.isLoadingEnterprises)
            Expanded(
              child: EnterpriseJsonItems(nextPageRoute: nextRoute),
            ),
        ],
      ),
    );
  }
}

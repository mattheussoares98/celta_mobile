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

    if (nextRoute == APPROUTES.ADJUST_SALE_PRICE_PRODUCTS) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Bem-vindo ao módulo de Alteração de preços!",
        function: () {},
        showConfirmAndCancelMessage: false,
        showCloseAlertDialogButton: true,
        subtitleSize: 17,
        subtitle:
            "Este módulo estará disponível gratuitamente por um período de 30 dias. Após esse período, o acesso ao módulo será bloqueado e você precisará entrar em contato com o setor administrativo para solicitar a liberação, além de aceitar a cobrança associada.\nEssa iniciativa nos permitirá melhorar cada vez mais o aplicativo e adicionar novos recursos para você. Agradecemos sua compreensão e apoio!\nPara mais informações, entre em contato com nossa equipe de atendimento.\nAproveite o módulo!",
      );
    } else if (nextRoute ==
        APPROUTES.EXPEDITION_CONFERENCE_CONTROLS_TO_CONFERENCE) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Bem-vindo ao módulo de Controle de Produtos (Expedição)!",
        function: () {},
        showConfirmAndCancelMessage: false,
        showCloseAlertDialogButton: true,
        subtitleSize: 17,
        subtitle:
            "Este módulo estará disponível gratuitamente por um período de 30 dias. Após esse período, o acesso ao módulo será bloqueado e você precisará entrar em contato com o setor administrativo para solicitar a liberação, além de aceitar a cobrança associada.\nEssa iniciativa nos permitirá melhorar cada vez mais o aplicativo e adicionar novos recursos para você. Agradecemos sua compreensão e apoio!\nPara mais informações, entre em contato com nossa equipe de atendimento.\nAproveite o módulo!",
      );
    }
    await enterpriseProvider.getEnterprises();
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
                onPressed: enterpriseProvider.isLoading
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
                    !enterpriseProvider.isLoading)
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
                    !enterpriseProvider.isLoading)
                  Expanded(child: EnterpriseItems(nextPageRoute: nextRoute)),
              ],
            ),
          ),
        ),
        loadingWidget(
          message: "Consultando empresas...",
          isLoading: enterpriseProvider.isLoading,
        )
      ],
    );
  }
}

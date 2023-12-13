import 'package:celta_inventario/Models/buy_request_models/buy_request_enterprise_model.dart';
import 'package:celta_inventario/components/Global_widgets/searchAgain.dart';
import 'package:celta_inventario/components/Global_widgets/searching_widget.dart';
import 'package:celta_inventario/components/Global_widgets/show_alert_dialog.dart';
import 'package:celta_inventario/components/Global_widgets/title_and_value.dart';
import 'package:celta_inventario/providers/buy_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyRequestEnterprises extends StatefulWidget {
  final bool showOnlySelectedsEnterprises;
  const BuyRequestEnterprises({
    this.showOnlySelectedsEnterprises = false,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestEnterprises> createState() => _BuyRequestEnterprisesState();
}

class _BuyRequestEnterprisesState extends State<BuyRequestEnterprises> {
  TextEditingController searchValueController = TextEditingController();

  Future<void> _getEnterprises(BuyRequestProvider buyRequestProvider) async {
    if (buyRequestProvider.productsInCartCount > 0) {
      ShowAlertDialog.showAlertDialog(
        context: context,
        title: "Consultar empresas",
        subtitle:
            "Se consultar as empresas novamente, todos produtos serão removidos!\n\nDeseja realmente consultar as empresas novamente?",
        function: () async {
          await buyRequestProvider.getEnterprises(
            context: context,
            isSearchingAgain: true,
          );
        },
      );
    } else {
      await buyRequestProvider.getEnterprises(
        context: context,
        isSearchingAgain: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: buyRequestProvider.enterprisesCount > 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          if (!buyRequestProvider.isLoadingEnterprises &&
              buyRequestProvider.enterprisesCount > 0)
            const Text(
              "Empresas",
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buyRequestProvider.enterprisesCount,
            itemBuilder: (context, index) {
              BuyRequestEnterpriseModel enterprise =
                  buyRequestProvider.enterprises[index];

              if (widget.showOnlySelectedsEnterprises && !enterprise.selected) {
                return Container();
              }

              return Card(
                child: CheckboxListTile(
                  enabled: widget.showOnlySelectedsEnterprises ? false : true,
                  value: enterprise.selected,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  onChanged: (bool? value) {
                    buyRequestProvider.updateSelectedEnterprise(
                      context: context,
                      enterprise: enterprise,
                    );
                  },
                  subtitle: Column(
                    children: [
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Código",
                        value: enterprise.PersonalizedCode.toString(),
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Nome",
                        value: enterprise.Name,
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "Nome fantasia",
                        value: enterprise.FantasizesName,
                      ),
                      TitleAndSubtitle.titleAndSubtitle(
                        title: "CPF/CNPJ",
                        value: enterprise.CnpjNumber,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (!widget.showOnlySelectedsEnterprises &&
              !buyRequestProvider.isLoadingEnterprises)
            searchAgain(
              errorMessage: buyRequestProvider.errorMessageEnterprises,
              request: () async => _getEnterprises(buyRequestProvider),
            ),
          if (buyRequestProvider.isLoadingEnterprises)
            searchingWidget(title: "Consultando empresas"),
        ],
      ),
    );
  }
}

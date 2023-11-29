import 'package:celta_inventario/Models/buy_request_models/buy_request_enterprise_model.dart';
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

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return SingleChildScrollView(
      child: Container(
        height: widget.showOnlySelectedsEnterprises
            ? null
            : MediaQuery.of(context).size.height,
        width: widget.showOnlySelectedsEnterprises
            ? null
            : MediaQuery.of(context).size.width,
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
            if (buyRequestProvider.errorMessageEnterprises != "")
              Text(
                buyRequestProvider.errorMessageEnterprises,
                style: const TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buyRequestProvider.enterprisesCount,
              itemBuilder: (context, index) {
                BuyRequestEnterpriseModel enterprise =
                    buyRequestProvider.enterprises[index];

                if (widget.showOnlySelectedsEnterprises &&
                    !enterprise.selected) {
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
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
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
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Consultar empresas novamente"),
                      SizedBox(width: 20),
                      Icon(Icons.refresh),
                    ],
                  ),
                ),
              ),
            if (buyRequestProvider.isLoadingEnterprises)
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Consultando empresas",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 20),
                        CircularProgressIndicator(color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

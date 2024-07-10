import 'package:celta_inventario/pages/buy_request/enterprises/enterprise_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/buy_request/buy_request.dart';
import '../../../providers/providers.dart';
import '../../../components/components.dart';

class EnterpriseItems extends StatelessWidget {
  final bool checkBoxEnabled;
  const EnterpriseItems({
    required this.checkBoxEnabled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

    Future<void> _getEnterprises() async {
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

    return SingleChildScrollView(
      primary: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: buyRequestProvider.enterprisesCount > 0
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buyRequestProvider.enterprisesCount,
            itemBuilder: (context, index) {
              BuyRequestEnterpriseModel enterprise =
                  buyRequestProvider.enterprises[index];

              return EnterpriseItem(
                enterpriseModel: enterprise,
                enableCheckBox: checkBoxEnabled,
              );
            },
          ),
          if (!buyRequestProvider.isLoadingEnterprises && checkBoxEnabled)
            searchAgain(
              errorMessage: buyRequestProvider.errorMessageEnterprises,
              request: () async => _getEnterprises(),
            ),
        ],
      ),
    );
  }
}

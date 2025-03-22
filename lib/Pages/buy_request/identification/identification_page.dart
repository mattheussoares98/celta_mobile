import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../buy_request.dart';
import '../../../components/components.dart';
import '../../../providers/providers.dart';

class IdentificationPage extends StatefulWidget {
  final GlobalKey<FormFieldState> buyersKey;
  final GlobalKey<FormFieldState> requestsKey;

  const IdentificationPage({
    required this.buyersKey,
    required this.requestsKey,
    Key? key,
  }) : super(key: key);

  @override
  State<IdentificationPage> createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await restoreDataAndGetRequestsAndBuyers();
    });
  }

  Future<void> restoreDataAndGetRequestsAndBuyers() async {
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: false);

    await buyRequestProvider.restoreDataByDatabase();

    if (buyRequestProvider.requestsTypeCount == 0 &&
        buyRequestProvider.selectedRequestModel == null &&
        !buyRequestProvider.isLoadingRequestsType) {
      await buyRequestProvider.getRequestsType(context: context);
    }
    if (buyRequestProvider.buyersCount == 0 &&
        buyRequestProvider.selectedBuyer == null &&
        !buyRequestProvider.isLoadingBuyer) {
      await buyRequestProvider.getBuyers(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    BuyRequestProvider buyRequestProvider = Provider.of(context);
    return SingleChildScrollView(
      primary: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleComponent(
              title: "Comprador",
              isError: false,
              errorTitle: null,
            ),
            BuyersDropDown(
              value: buyRequestProvider.selectedBuyer,
              dropdownKey: widget.buyersKey,
              disabledHintText: "Comprador",
              buyers: buyRequestProvider.buyers,
              onChanged: (value) {
                buyRequestProvider.selectedBuyer = value;
              },
              reloadBuyers: () async {
                await buyRequestProvider.getBuyers(
                  isSearchingAgain: true,
                  context: context,
                );
              },
              showRefreshIcon: true,
              onTap: () {},
              validator: (value) {
                if (value == null) {
                  return "Selecione um comprador";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const TitleComponent(
              title: "Modelo de pedido de compra",
              isError: false,
              errorTitle: null,
            ),
            RequestsTypeDropdown(requestsKey: widget.requestsKey),
            const SizedBox(height: 20),
            const TitleComponent(
              title: "Fornecedores",
              isError: false,
              errorTitle: null,
            ),
            const Suplliers(),
          ],
        ),
      ),
    );
  }
}

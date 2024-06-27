import 'package:celta_inventario/pages/buy_request/components/title_component.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../providers/providers.dart';
import 'identification.dart';

class IdentificationPage extends StatefulWidget {
  final GlobalKey<FormFieldState> buyersKey;
  final GlobalKey<FormFieldState> requestsKey;

  const IdentificationPage({
    required this.buyersKey,
    required this.requestsKey,
    Key? key,
  }) : super(key: key);

  @override
  State<IdentificationPage> createState() =>
      _IdentificationPageState();
}

class _IdentificationPageState
    extends State<IdentificationPage> {
  bool _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (!_isLoaded) {
      _isLoaded = true;
      await restoreDataAndGetRequestsAndBuyers();
    }
  }

  Future<void> restoreDataAndGetRequestsAndBuyers() async {
    BuyRequestProvider buyRequestProvider = Provider.of(context);

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
            BuyersDropwodn(buyersKey: widget.buyersKey),
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

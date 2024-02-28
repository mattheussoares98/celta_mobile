import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buy_request/buy_request.dart';
import '../../providers/providers.dart';

class BuyRequestIdentificationPage extends StatefulWidget {
  final GlobalKey<FormFieldState> buyersKey;
  final GlobalKey<FormFieldState> requestsKey;

  const BuyRequestIdentificationPage({
    required this.buyersKey,
    required this.requestsKey,
    Key? key,
  }) : super(key: key);

  @override
  State<BuyRequestIdentificationPage> createState() =>
      _BuyRequestIdentificationPageState();
}

class _BuyRequestIdentificationPageState
    extends State<BuyRequestIdentificationPage> {
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
    BuyRequestProvider buyRequestProvider = Provider.of(context, listen: true);

    await buyRequestProvider.restoreDataByDatabase();

    if (buyRequestProvider.requestsTypeCount == 0 &&
        buyRequestProvider.selectedRequestModel == null &&
        !buyRequestProvider.isLoadingRequestsType) {
      buyRequestProvider.getRequestsType(context: context);
    }
    if (buyRequestProvider.buyersCount == 0 &&
        buyRequestProvider.selectedBuyer == null &&
        !buyRequestProvider.isLoadingBuyer) {
      buyRequestProvider.getBuyers(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buyRequestTitleComponent(
              title: "Comprador",
              context: context,
            ),
            BuyRequestBuyersDropwodn(buyersKey: widget.buyersKey),
            const SizedBox(height: 20),
            buyRequestTitleComponent(
              title: "Modelo de pedido de compra",
              context: context,
            ),
            BuyRequestRequestsTypeDropdown(requestsKey: widget.requestsKey),
            const SizedBox(height: 20),
            buyRequestTitleComponent(
              title: "Fornecedores",
              context: context,
            ),
            const BuyRequestSuplliers(),
          ],
        ),
      ),
    );
  }
}

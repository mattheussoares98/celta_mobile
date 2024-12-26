import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../providers/providers.dart';
import 'cart_details.dart';

class CartDetailsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  final bool keyboardIsOpen;
  final TextEditingController observationsController;
  final TextEditingController instructionsController;
  const CartDetailsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    required this.keyboardIsOpen,
    required this.observationsController,
    required this.instructionsController,
    Key? key,
  }) : super(key: key);

  @override
  State<CartDetailsPage> createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  bool userCanChangePrices = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        userCanChangePrices = await SoapHelper.userCanAccessResource(
          resourceCode: 666,
          routineInt: 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    return Column(
      children: [
        if (saleRequestProvider
                .cartProductsCount(widget.enterpriseCode.toString()) ==
            0)
          Expanded(
            child: Container(
              width: double.infinity,
              child: const Center(
                child: FittedBox(
                  child: Text(
                    "O carrinho está vazio",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (saleRequestProvider
                        .cartProductsCount(widget.enterpriseCode.toString()) >
                    0)
                  ObservationsAndInstructionsFields(
                    observationsController: widget.observationsController,
                    instructionsController: widget.instructionsController,
                  ),
                CartItems(
                  enterpriseCode: widget.enterpriseCode,
                  userCanChangePrices: userCanChangePrices,
                ),
                LastSaleRequestSaved(saleRequestProvider: saleRequestProvider),
              ],
            ),
          ),
        ),
        if (widget.keyboardIsOpen)
          SaveSaleRequestInformationsAndButton(
            enterpriseCode: widget.enterpriseCode,
            requestTypeCode: widget.requestTypeCode,
            instructions: widget.instructionsController.text,
            observations: widget.observationsController.text,
          ),
      ],
    );
  }
}

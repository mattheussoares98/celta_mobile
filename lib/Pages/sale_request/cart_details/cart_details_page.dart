import 'package:provider/provider.dart';

import 'package:flutter/material.dart';

import '../../../providers/providers.dart';
import 'cart_details.dart';

class CartDetailsPage extends StatefulWidget {
  final int enterpriseCode;
  final int requestTypeCode;
  final bool keyboardIsOpen;
  const CartDetailsPage({
    required this.enterpriseCode,
    required this.requestTypeCode,
    required this.keyboardIsOpen,
    Key? key,
  }) : super(key: key);

  @override
  State<CartDetailsPage> createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  final quantityController = TextEditingController();
  final observationsController = TextEditingController();
  final instructionsController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    quantityController.dispose();
    observationsController.dispose();
    instructionsController.dispose();
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
                    observationsController: observationsController,
                    instructionsController: instructionsController,
                  ),
                CartItems(
                  enterpriseCode: widget.enterpriseCode,
                  quantityController: quantityController,
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
            instructions: instructionsController.text,
            observations: observationsController.text,
          ),
      ],
    );
  }
}

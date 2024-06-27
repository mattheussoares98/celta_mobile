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
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider =
        Provider.of(context, listen: true);

    return Column(
      children: [
        CartItems(
          enterpriseCode: widget.enterpriseCode,
          textEditingController: _textEditingController,
        ),
        if (saleRequestProvider
                .cartProductsCount(widget.enterpriseCode.toString()) ==
            0)
          Expanded(
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      "O carrinho está vazio",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontFamily: "OpenSans",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        LastSaleRequestSaved(saleRequestProvider: saleRequestProvider),
        if (widget.keyboardIsOpen)
          SaveSaleRequestInformationsAndButton(
            enterpriseCode: widget.enterpriseCode,
            requestTypeCode: widget.requestTypeCode,
          ),
      ],
    );
  }
}

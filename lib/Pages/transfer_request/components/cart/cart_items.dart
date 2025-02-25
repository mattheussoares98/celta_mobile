import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/models.dart';
import '../../../../providers/providers.dart';
import '../../../../components/components.dart';
import '../components.dart';

class CartItems extends StatefulWidget {
  final TransferRequestEnterpriseModel originEnterprise;
  final TransferRequestEnterpriseModel destinyEnterprise;
  final TransferRequestModel selectedTransferRequestModel;
  const CartItems({
    required this.originEnterprise,
    required this.destinyEnterprise,
    required this.selectedTransferRequestModel,
    Key? key,
  }) : super(key: key);

  @override
  State<CartItems> createState() => _SaleRequestCartItemsState();
}

class _SaleRequestCartItemsState extends State<CartItems> {
  int _selectedIndex = -1;

  Future<void> selectIndexAndFocus(int index) async {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      FocusScope.of(context).unfocus();
      setState(() {
        _selectedIndex = -1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TransferRequestProvider transferRequestProvider = Provider.of(context);

    int cartProductsCount = transferRequestProvider.cartProductsCount(
      enterpriseOriginCode: widget.originEnterprise.Code.toString(),
      enterpriseDestinyCode: widget.destinyEnterprise.Code.toString(),
      requestTypeCode: widget.selectedTransferRequestModel.Code.toString(),
    );

    List<TransferRequestCartProductsModel> cartProducts =
        transferRequestProvider.getCartProducts(
      enterpriseOriginCode: widget.originEnterprise.Code.toString(),
      enterpriseDestinyCode: widget.destinyEnterprise.Code.toString(),
      requestTypeCode: widget.selectedTransferRequestModel.Code.toString(),
    );

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: cartProducts.length,
                itemBuilder: (context, index) {
                  final product = cartProducts[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                selectIndexAndFocus(index);
                              },
                              child: Column(
                                children: [
                                  ProductInformationAndRemoveIcon(
                                    product: product,
                                    index: index,
                                    originEnterprise: widget.originEnterprise,
                                    destinyEnterprise: widget.destinyEnterprise,
                                    selectedTransferRequestModel:
                                        widget.selectedTransferRequestModel,
                                  ),
                                  Summary(product: product),
                                ],
                              ),
                            ),
                            if (index == _selectedIndex)
                              EditQuantityAndPrice(
                                selectedTransferRequestModel:
                                    widget.selectedTransferRequestModel,
                                destinyEnterprise: widget.originEnterprise,
                                originEnterprise: widget.destinyEnterprise,
                                product: product,
                                unselectIndex: () {
                                  setState(() {
                                    _selectedIndex = -1;
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                      if (index == cartProductsCount - 1 &&
                          cartProductsCount > 1)
                        TextButton(
                          onPressed: () {
                            ShowAlertDialog.show(
                              context: context,
                              title: "Limpar carrinho",
                              content: const SingleChildScrollView(
                                child: Text(
                                  "Deseja realmente limpar todos produtos do carrinho?",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              function: () async {
                                await transferRequestProvider.clearCart(
                                  enterpriseOriginCode:
                                      widget.originEnterprise.Code.toString(),
                                  enterpriseDestinyCode:
                                      widget.destinyEnterprise.Code.toString(),
                                  requestTypeCode: widget
                                      .selectedTransferRequestModel.Code
                                      .toString(),
                                );
                              },
                            );
                          },
                          child: const Text(
                            "Limpar carrinho",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

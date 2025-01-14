import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class UpdateQuantityAndManualPrice extends StatefulWidget {
  final GetProductJsonModel product;
  final double? controllerInDouble;
  final FocusNode quantityFocusNode;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController newQuantityController;
  final int enterpriseCode;
  final void Function() callSetState;
  final bool userCanChangePrices;
  final void Function() clearSelectedIndex;
  final int productIndex;

  const UpdateQuantityAndManualPrice({
    required this.product,
    required this.controllerInDouble,
    required this.quantityFocusNode,
    required this.quantityFormKey,
    required this.newQuantityController,
    required this.enterpriseCode,
    required this.callSetState,
    required this.userCanChangePrices,
    required this.clearSelectedIndex,
    required this.productIndex,
    super.key,
  });

  @override
  State<UpdateQuantityAndManualPrice> createState() =>
      _UpdateQuantityAndManualPriceState();
}

class _UpdateQuantityAndManualPriceState
    extends State<UpdateQuantityAndManualPrice> {
  final manualPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.newQuantityController.text = widget.product.quantity
            .toString()
            .toBrazilianNumber()
            .replaceAll(RegExp(r'\.'), '');

        SaleRequestProvider saleRequestProvider =
            Provider.of(context, listen: false);
        if (!saleRequestProvider.needProcessCart) {
          manualPriceController.text = widget.product.value
              .toString()
              .toBrazilianNumber()
              .replaceAll(RegExp(r'\.'), '');
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    manualPriceController.dispose();
  }

  void updateProductInCart({
    required SaleRequestProvider saleRequestProvider,
    required GetProductJsonModel product,
    required int index,
  }) {
    double? controllerInDouble = double.tryParse(
      widget.newQuantityController.text.replaceAll(RegExp(r'\,'), '.'),
    );

    bool? isValid = widget.quantityFormKey.currentState!.validate();

    if (controllerInDouble == null || controllerInDouble == 0) return;

    if (isValid) {
      double productValue;
      if (widget.userCanChangePrices) {
        productValue = double.tryParse(
          manualPriceController.text.replaceAll(RegExp(r'\,'), '.'),
        )!;
      } else {
        productValue = saleRequestProvider.getPracticedPrice(
          quantityToAdd: controllerInDouble,
          product: product,
          enterpriseCode: widget.enterpriseCode.toString(),
        );
      }

      saleRequestProvider.updateProductFromCart(
        enterpriseCode: widget.enterpriseCode.toString(),
        quantity: controllerInDouble,
        updateToNeedProcessCartAgain: widget.userCanChangePrices ? false : true,
        value: productValue,
        index: index,
      );
      widget.newQuantityController.clear();
      widget.clearSelectedIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    SaleRequestProvider saleRequestProvider = Provider.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Preço venda",
                      subtitle: ConvertString.convertToBRL(
                        widget.product.retailPracticedPrice,
                      ),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Mín. atacado",
                      subtitle: widget.product.minimumWholeQuantity
                          .toString()
                          .toBrazilianNumber(),
                    ),
                    TitleAndSubtitle.titleAndSubtitle(
                      title: "Preço atacado",
                      subtitle: ConvertString.convertToBRL(
                        widget.product.wholePracticedPrice,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: widget.controllerInDouble == null ||
                        widget.controllerInDouble == 0
                    ? null
                    : () {
                        updateProductInCart(
                          saleRequestProvider: saleRequestProvider,
                          product: widget.product,
                          index: widget.productIndex,
                        );
                      },
                child: const Text("ATUALIZAR"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 55,
                child: Column(
                  children: [
                    InsertQuantityTextFormField(
                      lengthLimitingTextInputFormatter: 8,
                      focusNode: widget.quantityFocusNode,
                      formKey: widget.quantityFormKey,
                      newQuantityController: widget.newQuantityController,
                      onFieldSubmitted: () {
                        updateProductInCart(
                          saleRequestProvider: saleRequestProvider,
                          product: widget.product,
                          index: widget.productIndex,
                        );
                      },
                      onChanged: widget.callSetState,
                      labelText: "Digite a nova quantidade",
                      hintText: "Nova quantidade",
                    ),
                    if (widget.userCanChangePrices)
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: !saleRequestProvider.needProcessCart,
                                  controller: manualPriceController,
                                  style: FormFieldStyle.style(),
                                  onFieldSubmitted: (_) {
                                    updateProductInCart(
                                      saleRequestProvider: saleRequestProvider,
                                      product: widget.product,
                                      index: widget.productIndex,
                                    );
                                  },
                                  onChanged: (_) {
                                    widget.callSetState();
                                  },
                                  onTap: () {
                                    manualPriceController.selection =
                                        TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          manualPriceController.text.length,
                                    );
                                  },
                                  decoration: FormFieldDecoration.decoration(
                                    context: context,
                                    hintText:
                                        saleRequestProvider.needProcessCart
                                            ? "Calcule os preços"
                                            : "Preço manual R\$",
                                    labelText:
                                        saleRequestProvider.needProcessCart
                                            ? "Calcule os preços"
                                            : "Preço manual R\$",
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                tooltip:
                                    "Essa opção aparece somente quando o usuário possui permissão para alterar preços no pedido de vendas",
                              )
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    const FittedBox(
                      child: Text(
                        "TOTAL",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        saleRequestProvider
                            .getNewPrice(
                              product: widget.product,
                              enterpriseCode: widget.enterpriseCode.toString(),
                              newQuantityController:
                                  widget.newQuantityController,
                              manualWrittedPriceController:
                                  manualPriceController,
                            )
                            .toString()
                            .toBrazilianNumber()
                            .addBrazilianCoin(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

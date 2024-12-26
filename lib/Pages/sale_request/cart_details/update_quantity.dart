import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/components.dart';
import '../../../models/models.dart';
import '../../../providers/providers.dart';
import '../../../utils/utils.dart';

class UpdateQuantity extends StatefulWidget {
  final GetProductJsonModel product;
  final double? controllerInDouble;
  final void Function() updateProductInCart;
  final FocusNode quantityFocusNode;
  final GlobalKey<FormState> quantityFormKey;
  final TextEditingController newQuantityController;
  final int enterpriseCode;
  final void Function() callSetState;

  const UpdateQuantity({
    required this.product,
    required this.controllerInDouble,
    required this.updateProductInCart,
    required this.quantityFocusNode,
    required this.quantityFormKey,
    required this.newQuantityController,
    required this.enterpriseCode,
    required this.callSetState,
    super.key,
  });

  @override
  State<UpdateQuantity> createState() => _UpdateQuantityState();
}

class _UpdateQuantityState extends State<UpdateQuantity> {
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
              Expanded(
                flex: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 60),
                  ),
                  onPressed: widget.controllerInDouble == null ||
                          widget.controllerInDouble == 0
                      ? null
                      : widget.updateProductInCart,
                  child: const Text("ATUALIZAR"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 55,
                child: InsertQuantityTextFormField(
                  lengthLimitingTextInputFormatter: 8,
                  focusNode: widget.quantityFocusNode,
                  formKey: widget.quantityFormKey,
                  newQuantityController: widget.newQuantityController,
                  onFieldSubmitted: () {
                    ShowAlertDialog.show(
                      context: context,
                      title: "Atualizar o preço",
                      content: const SingleChildScrollView(
                        child: Text(
                          "Deseja realmente atualizar a quantidade e o preço?",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      function: widget.updateProductInCart,
                    );
                  },
                  onChanged: widget.callSetState,
                  labelText: "Digite a nova quantidade",
                  hintText: "Nova quantidade",
                ),
              ),
              Expanded(
                flex: 45,
                child: Column(
                  children: [
                    const FittedBox(
                      child: Text(
                        " NOVO PREÇO",
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
